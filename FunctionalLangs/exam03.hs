{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wincomplete-patterns #-}

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

data Stream a = Append a (Stream a) | Cycle [a]
  deriving (Show)

infixr 5 `Append`

s1 :: Stream Int
s1 = 1 `Append` 2 `Append` (Cycle [3])

s2 :: Stream Int
s2 = Cycle [1 .. 10]

s3 :: Stream Bool
s3 = True `Append` (not <$> s3)

instance Eq a => Eq (Stream a) where
  (==) (Cycle c1) (Cycle c2) = c1 == c2
  (==) (Append a1 s1) (Append a2 s2) = a1 == a2 && s1 == s2
  (==) _ _ = False

-- elég a foldr/foldMap közül az egyik
instance Foldable Stream where
  foldr f b (Cycle c) = foldr f b c
  foldr f b (Append a s) = f a (foldr f b s)

instance Functor Stream where
  fmap f (Cycle c) = Cycle (fmap f c)
  fmap f (Append a s) = Append (f a) (fmap f s)

-- elég a sequenceA/traverse közül az egyik
instance Traversable Stream where
  sequenceA (Cycle c) = Cycle <$> sequenceA c
  sequenceA (Append a s) = Append <$> a <*> sequenceA s

streamToList :: Stream a -> [a]
streamToList (Cycle c) = cycle c
streamToList (Append a s) = a : streamToList s

insertBeforeCycle :: Stream a -> [a] -> Stream a
insertBeforeCycle s [] = s
insertBeforeCycle (Cycle c) (x : xs) = Append x (insertBeforeCycle (Cycle c) xs)
insertBeforeCycle (Append a s) xs = Append a (insertBeforeCycle s xs)

readStream :: IO (Stream Int)
readStream = do
  l1 <- getLine
  let l = map read $ words l1
  l2 <- getLine
  let l' = map read $ words l2
  return (insertBeforeCycle (Cycle l') l)

cyclePart :: Stream a -> Stream a
cyclePart (Cycle c) = Cycle c
cyclePart (Append a s) = cyclePart s

reverseSt :: Stream a -> Stream a
reverseSt (Cycle c) = Cycle (reverse c)
reverseSt (Append a s) = undefined
  where
    cyc = cyclePart s

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
  | Index Exp Exp
  | List [Exp]
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
keywords = ["not", "true", "false", "while", "if", "do", "end", "then", "else"]

ident' :: Parser String
ident' = do
  x <- some (satisfy isAlpha) <* ws
  if elem x keywords
    then empty
    else pure x

keyword' :: String -> Parser ()
keyword' s = do
  string s
  (satisfy isLetter >> empty) <|> ws

atom :: Parser Exp
atom =
  (Var <$> ident')
    <|> (IntLit <$> posInt')
    <|> (BoolLit True <$ keyword' "true")
    <|> (BoolLit False <$ keyword' "false")
    <|> (char' '(' *> pExp <* char' ')')
    <|> (List <$> (char' '[' *> sepBy pExp (char' ',') <* char' ']'))

notExp :: Parser Exp
notExp =
  (keyword' "not" *> (Not <$> atom))
    <|> atom

mulExp :: Parser Exp
mulExp = rightAssoc Mul notExp (char' '*')

indexExp :: Parser Exp
indexExp = leftAssoc Index mulExp (string' "!!")

addExp :: Parser Exp
addExp = rightAssoc Add indexExp (char' '+')

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

data Val = VInt Int | VBool Bool | VList [Val]
  deriving (Eq, Show)

type Env = [(String, Val)]

evalExp :: Env -> Exp -> Val
evalExp env e = case e of
  IntLit n -> VInt n
  BoolLit b -> VBool b
  List l -> VList (map (\x -> evalExp env x) l)
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
    (VList l1, VList l2) -> VBool (l1 == l2)
    _ -> error "type error"
  Not e -> case evalExp env e of
    VBool b -> VBool (not b)
    _ -> error "type error"
  Var x -> case lookup x env of
    Just v -> v
    Nothing -> error $ "name not in scope: " ++ x
  Index e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VList l, VInt n1) -> l !! n1
    _ -> error "type error"

--------------------------------------------------------------------------------

type Program = [Statement] -- st1; st2; st3; ... st4

data Statement
  = Assign String Exp -- x := e
  | While Exp Program -- while e do prog end
  | If Exp Program Program -- if e then prog1 else prog2 end
  | AssignAt String Exp Exp
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
    <|> (AssignAt <$> ident' <*> (string' "!!" *> pExp) <*> (string' ":=" *> pExp))

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
getVarVal x ((v, y) : vs) = if v == x then Just y else getVarVal x vs

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
  AssignAt x i e -> do
    env <- get
    case (getVarVal x env, evalExp env i) of
      (Just (VList l), VInt n) -> do
        let e' = evalExp env e
        put $ updateEnv x (VList (take n l ++ [e'] ++ drop (n + 1) l)) env
      _ -> error "type error"

evalProgram :: Program -> State Env ()
evalProgram = mapM_ evalStatement

run :: String -> Env
run str = case runParser (topLevel program) str of
  Just (prog, _) -> execState (evalProgram prog) []
  Nothing -> error "parse error"