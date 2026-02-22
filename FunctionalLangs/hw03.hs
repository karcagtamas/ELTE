{-# OPTIONS_GHC -Wincomplete-patterns #-}

import Control.Monad

data Exp
  = IntLit Int
  | Add Exp Exp
  | Sub Exp Exp
  | Mul Exp Exp
  | BoolLit Bool
  | And Exp Exp
  | Or Exp Exp
  | Not Exp
  | Eq Exp Exp
  | Var String
  deriving (Eq, Show)

type Program = [Statement]

data Statement
  = Assign String Exp
  | While Exp Program
  | If Exp Program Program
  deriving (Eq, Show)

data Ty = TInt | TBool deriving (Eq, Show)

type Ctx = [(String, Ty)]

inferExp :: Ctx -> Exp -> Maybe Ty
inferExp _ (IntLit _) = Just TInt
inferExp _ (BoolLit _) = Just TBool
inferExp cxt (Add e1 e2) = inferBinExp TInt cxt e1 e2
inferExp cxt (Sub e1 e2) = inferBinExp TInt cxt e1 e2
inferExp cxt (Mul e1 e2) = inferBinExp TInt cxt e1 e2
inferExp cxt (And e1 e2) = inferBinExp TBool cxt e1 e2
inferExp cxt (Or e1 e2) = inferBinExp TBool cxt e1 e2
inferExp cxt (Not e) = do
  ty <- inferExp cxt e

  if ty == TBool then return TBool else Nothing
inferExp cxt (Eq e1 e2) = do
  ty1 <- inferExp cxt e1
  ty2 <- inferExp cxt e2

  if ty1 == ty2 then return TBool else Nothing
inferExp cxt (Var x) = lookup x cxt

inferBinExp :: Ty -> Ctx -> Exp -> Exp -> Maybe Ty
inferBinExp typ cxt e1 e2 = do
  ty1 <- inferExp cxt e1
  ty2 <- inferExp cxt e2

  if ty1 == typ && ty2 == typ then return typ else Nothing

check :: Program -> Bool
check prog = case inferProgram [] prog of
  Nothing -> False
  _ -> True

inferProgram :: Ctx -> Program -> Maybe Ty
inferProgram _ [] = Nothing
inferProgram ctx [st] = case st of
  Assign x e -> do
    ty <- inferExp ctx e

    case inferExp ctx (Var x) of
      Nothing -> return ty
      Just t -> if ty == t then return t else Nothing
  If f u v -> do
    fTy <- inferExp ctx f

    if fTy == TBool
      then do
        uTy <- inferProgram ctx u
        vTy <- inferProgram ctx v

        if uTy == vTy then return uTy else Nothing
      else Nothing
  While f u -> do
    fTy <- inferExp ctx f

    if fTy == TBool
      then inferProgram ctx u
      else Nothing
inferProgram ctx (st : sts) = case st of
  Assign x e -> do
    ty <- inferExp ctx e

    case inferExp ctx (Var x) of
      Nothing -> inferProgram ((x, ty) : ctx) sts
      Just t -> if ty == t then inferProgram ctx sts else Nothing
  If f u v -> do
    fTy <- inferExp ctx f

    if fTy == TBool
      then do
        uTy <- inferProgram ctx u
        vTy <- inferProgram ctx v

        if uTy == vTy then inferProgram ctx sts else Nothing
      else Nothing
  While f u -> do
    fTy <- inferExp ctx f

    if fTy == TBool
      then do
        ty <- inferProgram ctx u

        inferProgram ctx sts
      else Nothing

-- Tests
-- rövidítések
i0 = IntLit 10

true = BoolLit True

false = BoolLit False

vx = Var "x"

vy = Var "y"

vz = Var "z"

-- esetek, amire check True-t ad
suc1 =
  [ Assign "x" i0,
    Assign "x" i0
  ]

suc2 =
  [ Assign "x" i0,
    Assign "y" vx,
    Assign "y" (Add vx vx)
  ]

suc3 =
  [ While true [Assign "x" i0],
    Assign "x" true
  ]

suc4 =
  [ Assign "x" true,
    If vx [Assign "y" i0] [Assign "y" i0],
    Assign "y" true
  ]

suc5 = [Assign "x" (Eq i0 i0)]

suc6 = [Assign "x" (Eq true true)]

suc7 = [Assign "x" (Or (Eq i0 i0) (Eq i0 i0))]

suc8 = [Assign "x" (And (Eq i0 i0) (Or true false))]

suc9 = [Assign "x" (Not true)]

suc10 = [Assign "x" (Not (Eq true false))]

suc11 = [Assign "x" (Mul i0 i0)]

suc12 = [Assign "x" (Sub (Mul i0 i0) i0)]

suc13 = [Assign "x" (Add (Mul i0 i0) i0)]

-- esetek, amire check False-t ad
fail1 =
  [ Assign "x" i0,
    Assign "x" false
  ]

fail2 = [Assign "x" (Add i0 false)]

fail3 =
  [ Assign "x" true,
    While true [Assign "x" i0]
  ]

fail4 =
  [ Assign "x" true,
    Assign "y" true,
    If (Var "x") [Assign "y" i0] [Assign "y" i0]
  ]

fail5 = [Assign "x" (Eq i0 false)]

fail6 = [Assign "x" vx]

fail7 = [While vx []]

fail8 = [Assign "x" (Or i0 (Eq i0 i0))]

fail9 = [Assign "x" (And (Eq i0 i0) i0)]

fail10 = [Assign "x" (Not i0)]

fail11 = [Assign "x" (Mul i0 true)]

fail12 = [Assign "x" (Sub (Mul i0 i0) false)]

fail13 = [Assign "x" (Add (Mul i0 i0) (Eq i0 i0))]

-- a test függvénnyel lehet tömören kinyomtatni a teszteseteket

successes =
  [suc1, suc2, suc3, suc4, suc5, suc6, suc7, suc8, suc9, suc10, suc11, suc12, suc13]

failures =
  [ fail1,
    fail2,
    fail3,
    fail4,
    fail5,
    fail6,
    fail7,
    fail8,
    fail9,
    fail10,
    fail11,
    fail12,
    fail13
  ]

test :: IO ()
test = do
  forM_ (zip [1 ..] successes) $ \(i, p) -> do
    putStrLn $ "success " ++ show i ++ ": " ++ show (check p)

  forM_ (zip [1 ..] failures) $ \(i, p) -> do
    putStrLn $ "failure " ++ show i ++ ": " ++ show (check p)