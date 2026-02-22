{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wincomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use tuple-section" #-}

import Control.Applicative
import Control.Monad
import Data.Char

newtype State s a = State {runState :: s -> (a, s)} deriving (Functor)

instance Applicative (State s) where
  pure a = State (\s -> (a, s))
  (<*>) = ap

instance Monad (State s) where
  (State f) >>= g = State $ \s -> let (a, s') = f s in runState (g a) s'

put :: s -> State s ()
put s = State $ \_ -> ((), s)

get :: State s s
get = State $ \s -> (s, s)

modify :: (s -> s) -> State s ()
modify f = do s <- get; put (f s)

evalState :: State s a -> s -> a
evalState sta s = fst (runState sta s)

execState :: State s a -> s -> s
execState sta s = snd (runState sta s)

-- FELADATOK
--------------------------------------------------------------------------------

data Pipe a = Wait (Pipe a) | ProduceOne a (Pipe a) | ProduceMany [a] (Pipe a) | EOF
  deriving (Show)

infixr 5 `ProduceOne`, `ProduceMany`

p1 :: Pipe Int
p1 = 1 `ProduceOne` 2 `ProduceOne` Wait ([3, 4] `ProduceMany` EOF)

p2 :: Pipe String
p2 = [] `ProduceMany` "Hello" `ProduceOne` "World" `ProduceOne` EOF

p3 :: Pipe Int
p3 = Wait $ ProduceOne 1 $ Wait $ Wait $ ProduceOne 2 EOF

p4 :: Pipe Bool
p4 = ProduceOne True $ Wait $ not <$> p4

instance Eq a => Eq (Pipe a) where
  (==) :: Pipe a -> Pipe a -> Bool
  (==) (Wait p1) (Wait p2) = p1 == p2
  (==) (ProduceOne a1 p1) (ProduceOne a2 p2) = a1 == a2 && p1 == p2
  (==) (ProduceMany a1 p1) (ProduceMany a2 p2) = a1 == a2 && p1 == p2
  (==) EOF EOF = True
  (==) _ _ = False

-- elég a foldr/foldMap közül az egyik
instance Foldable Pipe where
  foldr :: (a -> b -> b) -> b -> Pipe a -> b
  foldr _ b EOF = b
  foldr f b (Wait p) = foldr f b p
  foldr f b (ProduceOne a p) = f a (foldr f b p)
  foldr f b (ProduceMany a p) = foldr f (foldr f b p) a

-- foldMap :: Monoid m => (a -> m) -> Pipe a -> m
-- foldMap = undefined

instance Functor Pipe where
  fmap :: (a -> b) -> Pipe a -> Pipe b
  fmap f EOF = EOF
  fmap f (Wait p) = Wait (f <$> p)
  fmap f (ProduceOne a p) = ProduceOne (f a) (f <$> p)
  fmap f (ProduceMany a p) = ProduceMany (f <$> a) (f <$> p)

-- elég a sequenceA/traverse közül az egyik
instance Traversable Pipe where
  -- traverse :: Applicative f => (a -> f b) -> Pipe a -> f (Pipe b)
  -- traverse = undefined
  sequenceA :: Applicative f => Pipe (f a) -> f (Pipe a)
  sequenceA EOF = pure EOF
  sequenceA (Wait p) = Wait <$> sequenceA p
  sequenceA (ProduceOne a p) = ProduceOne <$> a <*> sequenceA p
  sequenceA (ProduceMany a p) = ProduceMany <$> sequenceA a <*> sequenceA p

readUntilSemaphore :: Pipe a -> ([a], Pipe a)
readUntilSemaphore (Wait p) = ([], p)
readUntilSemaphore EOF = ([], EOF)
readUntilSemaphore (ProduceOne a p) = (a : ra, rb)
  where
    (ra, rb) = readUntilSemaphore p
readUntilSemaphore (ProduceMany a p) = (a ++ ra, rb)
  where
    (ra, rb) = readUntilSemaphore p

flattenPipe :: Pipe a -> Pipe a
flattenPipe EOF = EOF
flattenPipe (Wait p) = ProduceMany [] (Wait (flattenPipe p))
flattenPipe (ProduceMany a p) = case flattenPipe p of
  (ProduceOne x p') -> ProduceMany (a ++ [x]) p'
  (ProduceMany x p') -> ProduceMany (a ++ x) p'
  x -> ProduceMany a x
flattenPipe (ProduceOne a p) = case flattenPipe p of
  (ProduceOne x p') -> ProduceMany [a, x] p'
  (ProduceMany x p') -> ProduceMany (a : x) p'
  x -> ProduceMany [a] x

processPipe :: IO (Pipe Int)
processPipe = do
  line <- getLine

  if line == "EOF"
    then do
      return EOF
    else
      if line == ""
        then do
          Wait <$> processPipe
        else do
          let w = words line

          if length w == 1
            then do
              ProduceOne (read (head w)) <$> processPipe
            else do
              ProduceMany (map read w) <$> processPipe

labelPipe :: Pipe a -> Pipe (a, Int)
labelPipe EOF = EOF
labelPipe (Wait p) = Wait (labelPipe p)
labelPipe (ProduceOne x p) = ProduceOne (x, 1) (labelPipe p)
labelPipe (ProduceMany x p) = ProduceMany (map (\k -> (k, 1)) x) (labelPipe p)

-- Parser lib
--------------------------------------------------------------------------------

newtype Parser a = Parser {runParser :: String -> Maybe (a, String)}
  deriving (Functor)

instance Applicative Parser where
  pure a = Parser $ \s -> Just (a, s)
  (<*>) = ap

instance Monad Parser where
  return = pure
  Parser f >>= g = Parser $ \s -> case f s of
    Nothing -> Nothing
    Just (a, s) -> runParser (g a) s

eof :: Parser ()
eof = Parser $ \s -> case s of
  "" -> Just ((), "")
  _ -> Nothing

-- egy karaktert olvassunk az input elejéről, amire
-- igaz egy feltétel
satisfy :: (Char -> Bool) -> Parser Char
satisfy f = Parser $ \s -> case s of
  c : s | f c -> Just (c, s)
  _ -> Nothing

-- olvassunk egy konkrét karaktert
char :: Char -> Parser ()
char c = () <$ satisfy (== c)

-- satisfy (==c)   hiba: Parser Char helyett Parser () kéne

instance Alternative Parser where
  empty = Parser $ \_ -> Nothing
  (<|>) (Parser f) (Parser g) = Parser $ \s -> case f s of
    Nothing -> g s
    x -> x

-- konkrét String olvasása:
string :: String -> Parser ()
string = mapM_ char -- minden karakterre alkalmazzuk a char-t

-- standard függvények (Control.Applicative-ból)
-- many :: Parser a -> Parser [a]
--    (0-szor vagy többször futtatunk egy parser-t)
-- some :: Parser a -> Parser [a]
--    (1-szor vagy többször futtatunk egy parser-t)

many_ :: Parser a -> Parser ()
many_ pa = () <$ many pa

some_ :: Parser a -> Parser ()
some_ pa = () <$ some pa

-- olvassunk 0 vagy több pa-t, psep-el elválasztva
sepBy :: Parser a -> Parser sep -> Parser [a]
sepBy pa psep = sepBy1 pa psep <|> pure []

-- olvassunk 1 vagy több pa-t, psep-el elválasztva
sepBy1 :: Parser a -> Parser sep -> Parser [a]
sepBy1 pa psep = (:) <$> pa <*> many (psep *> pa)

pDigit :: Parser Int
pDigit = digitToInt <$> satisfy isDigit

-- pozitív Int olvasása
pPos :: Parser Int
pPos = do
  ds <- some pDigit
  pure $ sum $ zipWith (*) (reverse ds) (iterate (* 10) 1)

rightAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
rightAssoc f pa psep = foldr1 f <$> sepBy1 pa psep

leftAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
leftAssoc f pa psep = foldl1 f <$> sepBy1 pa psep

nonAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
nonAssoc f pa psep = do
  exps <- sepBy1 pa psep
  case exps of
    [e] -> pure e
    [e1, e2] -> pure (f e1 e2)
    _ -> empty

-- nem láncolható prefix operátor
prefix :: (a -> a) -> Parser a -> Parser op -> Parser a
prefix f pa pop = (pop *> (f <$> pa)) <|> pa

ws :: Parser ()
ws = many_ (satisfy isSpace)

char' :: Char -> Parser ()
char' c = char c <* ws

string' :: String -> Parser ()
string' s = string s <* ws

topLevel :: Parser a -> Parser a
topLevel p = ws *> p <* eof

-- PARSER/INTERPRETER kiegészítés
--------------------------------------------------------------------------------

data Exp
  = IntLit Int -- int literál (pozitív)
  | Add Exp Exp -- e + e
  | Sub Exp Exp -- e - e
  | Mul Exp Exp -- e * e
  | BoolLit Bool -- true|false
  | And Exp Exp -- e && e
  | Or Exp Exp -- e || e
  | Not Exp -- not e
  | Eq Exp Exp -- e == e
  | Var String -- (változónév)
  | EmptyStack
  | IsEmpty Exp
  deriving (Eq, Show)

{-
Változónév: nemüres alfabetikus string

Kötési erősségek csökkenő sorrendben:
  - atom: zárójelezett kifejezés, literál, változónév
  - not alkalmazás
  - *  : jobbra asszoc
  - +  : jobbra asszoc
  - -  : jobbra asszoc
  - && : jobbra asszoc
  - || : jobbra asszoc
  - == : nem asszoc
-}

posInt' :: Parser Int
posInt' = do
  digits <- some (satisfy isDigit)
  ws
  pure (read digits)

keywords :: [String]
keywords = ["not", "true", "false", "while", "if", "do", "end", "then", "else", "empty", "pop", "into", "push"]

ident' :: Parser String
ident' = do
  x <- some (satisfy isAlpha) <* ws
  if elem x keywords
    then empty
    else pure x

keyword' :: String -> Parser ()
keyword' s = do
  string s
  m <- optional (satisfy isLetter)
  case m of
    Just _ -> empty
    _ -> ws

atom :: Parser Exp
atom =
  (Var <$> ident')
    <|> (IntLit <$> posInt')
    <|> (BoolLit True <$ keyword' "true")
    <|> (BoolLit False <$ keyword' "false")
    <|> (char' '(' *> pExp <* char' ')')
    <|> (EmptyStack <$ char' '<' <* char' '>')

notOrEmptyExp :: Parser Exp
notOrEmptyExp =
  (keyword' "not" *> (Not <$> atom))
    <|> (keyword' "empty" *> (IsEmpty <$> atom))
    <|> atom

mulExp :: Parser Exp
mulExp = rightAssoc Mul notOrEmptyExp (char' '*')

addExp :: Parser Exp
addExp = rightAssoc Add mulExp (char' '+')

subExp :: Parser Exp
subExp = rightAssoc Sub addExp (char' '-')

andExp :: Parser Exp
andExp = rightAssoc And subExp (string' "&&")

orExp :: Parser Exp
orExp = rightAssoc Or andExp (string' "||")

eqExp :: Parser Exp
eqExp = nonAssoc Eq orExp (string' "==")

pExp :: Parser Exp
pExp = eqExp

data Val = VInt Int | VBool Bool | VStack [Val]
  deriving (Eq, Show)

type Env = [(String, Val)]

evalExp :: Env -> Exp -> Val
evalExp env e = case e of
  IntLit n -> VInt n
  BoolLit b -> VBool b
  EmptyStack -> VStack []
  IsEmpty e -> case evalExp env e of
    (VStack []) -> VBool True
    (VStack _) -> VBool False
    _ -> error "type error"
  Add e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VInt n1, VInt n2) -> VInt (n1 + n2)
    _ -> error "type error"
  Sub e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VInt n1, VInt n2) -> VInt (n1 - n2)
    _ -> error "type error"
  Mul e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VInt n1, VInt n2) -> VInt (n1 * n2)
    _ -> error "type error"
  Or e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VBool b1, VBool b2) -> VBool (b1 || b2)
    _ -> error "type error"
  And e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VBool b1, VBool b2) -> VBool (b1 && b2)
    _ -> error "type error"
  Eq e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VBool b1, VBool b2) -> VBool (b1 == b2)
    (VInt n1, VInt n2) -> VBool (n1 == n2)
    _ -> error "type error"
  Not e -> case evalExp env e of
    VBool b -> VBool (not b)
    _ -> error "type error"
  Var x -> case lookup x env of
    Just v -> v
    Nothing -> error $ "name not in scope: " ++ x

--------------------------------------------------------------------------------

type Program = [Statement] -- st1; st2; st3; ... st4

data Statement
  = Assign String Exp -- x := e
  | While Exp Program -- while e do prog end
  | If Exp Program Program -- if e then prog1 else prog2 end
  | PopInto String String
  | Push String Exp
  deriving (Eq, Show)

statement :: Parser Statement
statement =
  ( Assign
      <$> ident'
      <*> (string' ":=" *> pExp)
  )
    <|> ( While
            <$> (keyword' "while" *> pExp <* keyword' "do")
            <*> (program <* keyword' "end")
        )
    <|> ( If
            <$> (keyword' "if" *> pExp <* keyword' "then")
            <*> (program <* keyword' "else")
            <*> (program <* keyword' "end")
        )
    <|> (PopInto <$> (keyword' "pop" *> ident') <*> (keyword' "into" *> ident'))
    <|> (Push <$> (keyword' "push" *> ident')) <*> pExp

program :: Parser Program
program = sepBy statement (char' ';')

-- Ha valami newScope-ban fut, akkor a futás után az újonnan felvett változókat
-- eldobjuk az Env-ből.
inNewScope :: State Env a -> State Env a
inNewScope ma = do
  l <- length <$> get
  a <- ma
  modify (take l)
  pure a

updateEnv :: String -> Val -> Env -> Env
updateEnv x v [] = [(x, v)]
updateEnv x v ((y, v') : env)
  | x == y = (x, v) : env
  | otherwise = (y, v') : updateEnv x v env

getVarVal :: String -> Env -> Maybe Val
getVarVal _ [] = Nothing
getVarVal n ((x, y) : xs) = if x == n then Just y else getVarVal n xs

evalStatement :: Statement -> State Env ()
evalStatement st = case st of
  Assign x e -> do
    env <- get
    let val = evalExp env e
    put $ updateEnv x val env
  While e p -> do
    env <- get
    case evalExp env e of
      VBool True -> inNewScope (evalProgram p) >> evalStatement (While e p)
      VBool False -> pure ()
      _ -> error "type error"
  If e p1 p2 -> do
    env <- get
    case evalExp env e of
      VBool True -> inNewScope (evalProgram p1)
      VBool False -> inNewScope (evalProgram p2)
      _ -> error "type error"
  Push x e -> do
    env <- get
    case getVarVal x env of
      Just (VStack s) -> do
        let ex = evalExp env e
        put $ updateEnv x (VStack (ex : s)) env
      _ -> error "type error"
  PopInto x y -> do
    env <- get
    case getVarVal x env of
      Just (VStack []) -> do
        return ()
      Just (VStack (k : ks)) -> do
        put $ updateEnv y k (updateEnv x (VStack ks) env)
      _ -> error "type error"

evalProgram :: Program -> State Env ()
evalProgram = mapM_ evalStatement

run :: String -> Env
run str = case runParser (topLevel program) str of
  Just (prog, _) -> execState (evalProgram prog) []
  Nothing -> error "parse error"
