{-# LANGUAGE DeriveFunctor #-}
{-# OPTIONS_GHC -Wincomplete-patterns #-}

import Control.Applicative
import Control.Monad
import Data.Binary.Get (skip)
import Data.Maybe
import Data.String
import Data.Traversable
import Debug.Trace

newtype State s a = State {runState :: s -> (a, s)} deriving (Functor)

instance Applicative (State s) where
  pure a = State (\s -> (a, s))
  (<*>) = ap

instance Monad (State s) where
  return = pure
  State f >>= g = State (\s -> case f s of (a, s') -> runState (g a) s')

get :: State s s
get = State (\s -> (s, s))

put :: s -> State s ()
put s = State (\_ -> ((), s))

modify :: (s -> s) -> State s ()
modify f = do s <- get; put (f s)

evalState :: State s a -> s -> a
evalState ma = fst . runState ma

execState :: State s a -> s -> s
execState ma = snd . runState ma

data ProgState = ProgState
  { r1 :: Int,
    r2 :: Int,
    r3 :: Int,
    cmp :: Ordering,
    memory :: [Int]
  }
  deriving (Eq, Show)

startState :: ProgState
startState = ProgState 0 0 0 EQ (replicate 10 0)

type Label = String -- címke a programban, ahová ugrani lehet

data Register
  = R1
  | R2
  | R3
  deriving (Eq, Show)

data Destination
  = DstReg Register -- regiszterbe írunk
  | DstDeref Register -- memóriába írunk, az adott regiszterben tárolt index helyére
  deriving (Eq, Show)

data Source
  = SrcReg Register -- regiszterből olvasunk
  | SrcDeref Register -- memóriából olvasunk, az adott regiszterben tárolt index helyéről
  | SrcLit Int -- szám literál
  deriving (Eq, Show)

data Instruction
  = Mov Destination Source -- írjuk a Destination-be a Source értékét
  | Add Destination Source -- adjuk a Destination-höz a Source értékét
  | Mul Destination Source -- szorozzuk a Destination-t a Source értékével
  | Sub Destination Source -- vonjuk ki a Destination-ből a Source értékét
  | Cmp Source Source -- hasonlítsunk össze két Source értéket `compare`-el, az eredményt
  -- írjuk a `cmp` regiszterbe
  | Jeq Label -- Ugorjunk az adott címkére ha a `cmp` regiszterben `EQ` van
  | Jlt Label -- Ugorjunk az adott címkére ha a `cmp` regiszterben `LT` van
  | Jgt Label -- Ugorjunk az adott címkére ha a `cmp` regiszterben `GT` van
  deriving (Eq, Show)

type RawProgram = [Either Label Instruction]

-- Beírunk r1-be 10-et, r2-be 20-at
p1 :: RawProgram
p1 =
  [ Left "start",
    Right $ Mov (DstReg R1) (SrcLit 10),
    Left "l1", -- tehetünk bárhova címkét, nem muszáj használni a programban
    Right $ Mov (DstReg R2) (SrcLit 20)
  ]

-- Kiszámoljuk 10 faktoriálisát, az eredményt r2-ben tároljuk
p2 :: RawProgram
p2 =
  [ Left "start",
    Right $ Mov (DstReg R1) (SrcLit 10),
    Right $ Mov (DstReg R2) (SrcLit 1),
    Left "loop",
    Right $ Mul (DstReg R2) (SrcReg R1),
    Right $ Sub (DstReg R1) (SrcLit 1),
    Right $ Cmp (SrcReg R1) (SrcLit 0),
    Right $ Jgt "loop"
  ]

-- Feltöltjük 0-9-el a memóriát
p3 :: RawProgram
p3 =
  [ Left "start",
    Right $ Mov (DstDeref R1) (SrcReg R1),
    Right $ Add (DstReg R1) (SrcLit 1),
    Right $ Cmp (SrcReg R1) (SrcLit 10),
    Right $ Jlt "start"
  ]

-- Megnöveljük 1-el a memória összes mezőjét
p4 :: RawProgram
p4 =
  [ Left "start",
    Right $ Add (DstDeref R2) (SrcLit 1),
    Right $ Add (DstReg R2) (SrcLit 1),
    Right $ Cmp (SrcReg R2) (SrcLit 10),
    Right $ Jlt "start"
  ]

-- Kétszer hozzáadunk 1-et a harmadik regiszterhez
p5 :: RawProgram
p5 =
  [ Left "start",
    Right $ Jeq "first",
    Left "first",
    Right $ Add (DstReg R3) (SrcLit 1),
    Left "second",
    Right $ Add (DstReg R3) (SrcLit 1)
  ]

type Program = [(Label, [Instruction])]

toProgram :: RawProgram -> Program
toProgram [] = []
toProgram ((Left label) : xs) = (label, allAfter xs) : toProgram (dropWhile pred xs)
  where
    allAfter :: [Either Label Instruction] -> [Instruction]
    allAfter [] = []
    allAfter ((Right i) : xs) = i : allAfter xs
    allAfter (_ : xs) = allAfter xs
    pred :: Either Label Instruction -> Bool
    pred (Right _) = True
    pred _ = False
toProgram ((Right instruction) : xs) = toProgram xs

{-
toProgram p1 == [("start",[Mov (DstReg R1) (SrcLit 10),Mov (DstReg R2) (SrcLit 20)]),("l1",[Mov (DstReg R2) (SrcLit 20)])]
toProgram [Left "start", Left "l1", Right $ Mov (DstReg R1) (SrcLit 10)] == [("start",[Mov (DstReg R1) (SrcLit 10)]),("l1",[Mov (DstReg R1) (SrcLit 10)])]
toProgram [Left "start", Right $ Mov (DstReg R1) (SrcLit 10),  Left "l1"] == [("start",[Mov (DstReg R1) (SrcLit 10)]),("l1",[])]
-}
type M a = State ProgState a

eval :: Program -> [Instruction] -> M ()
eval _ [] = return ()
eval p ((Jeq lbl) : xs) = do
  is <- evalJump p EQ lbl xs
  eval p is
eval p ((Jgt lbl) : xs) = do
  is <- evalJump p GT lbl xs
  eval p is
eval p ((Jlt lbl) : xs) = do
  is <- evalJump p LT lbl xs
  eval p is
eval p (x : xs) = do
  s <- get
  evalInstruction s x
  eval p xs

evalInstruction :: ProgState -> Instruction -> M ()
evalInstruction s (Mov dest src) = do
  x <- getSourceValue s src
  put (update s dest x)
evalInstruction s (Add dest src) = do
  x <- getSourceValue s src
  y <- getDestinationValue s dest
  put (update s dest (x + y))
evalInstruction s (Mul dest src) = do
  x <- getSourceValue s src
  y <- getDestinationValue s dest
  put (update s dest (y * x))
evalInstruction s (Sub dest src) = do
  x <- getSourceValue s src
  y <- getDestinationValue s dest
  put (update s dest (y - x))
evalInstruction s (Cmp src1 src2) = do
  x <- getSourceValue s src1
  y <- getSourceValue s src2
  put (updateCmp s x y)
  where
    updateCmp :: ProgState -> Int -> Int -> ProgState
    updateCmp (ProgState r1 r2 r3 cmp m) x y = ProgState r1 r2 r3 (compare x y) m
evalInstruction _ _ = return ()

evalJump :: Program -> Ordering -> Label -> [Instruction] -> M [Instruction]
evalJump p o lbl xs = do
  s <- get
  if isExecutable s o then return $ getInstructions p lbl else return xs
  where
    getInstructions :: Program -> Label -> [Instruction]
    getInstructions [] _ = []
    getInstructions ((l, is) : xs) lbl
      | l == lbl = is
      | otherwise = getInstructions xs lbl
    isExecutable :: ProgState -> Ordering -> Bool
    isExecutable (ProgState _ _ _ cmp _) o = cmp == o

-- Helper functions
getSourceValue :: ProgState -> Source -> M Int
getSourceValue _ (SrcLit n) = return n
getSourceValue s (SrcReg r) = return (getRegValue s r)
getSourceValue s (SrcDeref r) = return (getValueFromMemory s (getRegValue s r))

getDestinationValue :: ProgState -> Destination -> M Int
getDestinationValue s (DstReg r) = return (getRegValue s r)
getDestinationValue s (DstDeref r) = return (getValueFromMemory s (getRegValue s r))

getRegValue :: ProgState -> Register -> Int
getRegValue (ProgState v _ _ _ _) R1 = v
getRegValue (ProgState _ v _ _ _) R2 = v
getRegValue (ProgState _ _ v _ _) R3 = v

getValueFromMemory :: ProgState -> Int -> Int
getValueFromMemory (ProgState _ _ _ _ m) i = m !! i

update :: ProgState -> Destination -> Int -> ProgState
update (ProgState _ r2 r3 cmp m) (DstReg R1) i = ProgState i r2 r3 cmp m
update (ProgState r1 _ r3 cmp m) (DstReg R2) i = ProgState r1 i r3 cmp m
update (ProgState r1 r2 _ cmp m) (DstReg R3) i = ProgState r1 r2 i cmp m
update (ProgState r1 r2 r3 cmp m) (DstDeref r) i = ProgState r1 r2 r3 cmp (take index m ++ [i] ++ drop (index + 1) m)
  where
    index = getRegValue (ProgState r1 r2 r3 cmp m) r

-- futtatunk egy nyers programot a startState-ből kiindulva
runProgram :: RawProgram -> ProgState
runProgram rprog = case toProgram rprog of
  [] -> startState
  prog@((_, start) : _) -> execState (eval prog start) startState

{-
runProgram p1 == ProgState {r1 = 10, r2 = 20, r3 = 0, cmp = EQ, memory = [0,0,0,0,0,0,0,0,0,0]}
runProgram p2 == ProgState {r1 = 0, r2 = 3628800, r3 = 0, cmp = EQ, memory = [0,0,0,0,0,0,0,0,0,0]}
runProgram p3 == ProgState {r1 = 10, r2 = 0, r3 = 0, cmp = EQ, memory = [0,1,2,3,4,5,6,7,8,9]}
runProgram p4 == ProgState {r1 = 0, r2 = 10, r3 = 0, cmp = EQ, memory = [1,1,1,1,1,1,1,1,1,1]}
runProgram p5 == ProgState {r1 = 0, r2 = 0, r3 = 2, cmp = EQ, memory = [0,0,0,0,0,0,0,0,0,0]}
-}
