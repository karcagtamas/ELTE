{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-tabs -Wno-noncanonical-monad-instances #-}

import Control.Applicative
import Control.Monad
import Data.Char
import Data.Foldable
import Data.Functor
import Prelude hiding (lookup)

-- Bármit használhatsz a megoldáshoz, más személy vagy M.I. segítségén kívül.

-- Parser
--------------------------------------------------------------------------------

-- Válassz nehézségi szintet:

-- Könnyű mód --
-- newtype Parser a = Parser {runParser :: String -> [(a, String)]}

-- Nagyon könnyű mód --
newtype Parser a = Parser {runParser :: String -> Maybe (a, String)}

-- A választott Parser-el működnie kell a megoldásnak
-- Ugyanannyi pont jár összesen független melyiket választod

--------------------------------------------------------------------------------

instance Functor Parser where
  fmap :: (a -> b) -> Parser a -> Parser b
  fmap = liftM

instance Applicative Parser where
  pure :: a -> Parser a
  pure = Parser . curry pure

  (<*>) :: Parser (a -> b) -> Parser a -> Parser b
  (<*>) = ap

instance Monad Parser where
  (>>=) :: Parser a -> (a -> Parser b) -> Parser b
  (>>=) (Parser p1) f = Parser (p1 >=> uncurry (runParser . f))

instance Alternative Parser where
  empty :: Parser a
  empty = Parser (const empty)

  (<|>) :: Parser a -> Parser a -> Parser a
  (<|>) (Parser a) (Parser b) = Parser (\s -> a s <|> b s)

instance MonadFail Parser where
  fail :: String -> Parser a
  fail = const empty

instance MonadPlus Parser where
  mzero :: Parser a
  mzero = empty

  mplus :: Parser a -> Parser a -> Parser a
  mplus = (<|>)

negative :: Parser a -> Parser ()
negative (Parser p) = Parser $ \s -> if null (p s) then pure ((), s) else empty

eof :: Parser ()
eof = Parser $ \s -> case s of
  [] -> pure ((), [])
  _ -> empty

satisfy :: (Char -> Bool) -> Parser Char
satisfy f = Parser $ \s -> case s of
  [] -> empty
  (x : xs) -> (x, xs) <$ guard (f x)

char :: Char -> Parser ()
char c = void $ satisfy (== c)

string :: String -> Parser ()
string [] = pure ()
string (x : xs) = char x *> string xs

natural :: Parser Integer
natural = read <$> some (satisfy isDigit)

integer :: Parser Integer
integer = (negate <$ char '-' <|> pure id) <*> natural

char' :: Char -> Parser ()
char' c = char c <* ws

string' :: String -> Parser ()
string' s = string s <* ws

natural' :: Parser Integer
natural' = natural <* ws

integer' :: Parser Integer
integer' = integer <* ws

ws :: Parser ()
ws = void $ many (satisfy isSpace)

sepBy :: Parser a -> Parser sep -> Parser [a]
sepBy pa psep = sepBy1 pa psep <|> pure []

sepBy1 :: Parser a -> Parser sep -> Parser [a]
sepBy1 pa psep = (:) <$> pa <*> many (psep *> pa)

relaxedSepBy :: Parser a -> Parser sep -> Parser [a]
relaxedSepBy pa psep = concatMap toList <$> sepBy (optional pa) psep

topLevel :: Parser a -> Parser a
topLevel pa = ws *> pa <* eof

rightAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
rightAssoc f pa psep = foldr1 f <$> sepBy1 pa psep

leftAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
leftAssoc f pa psep = foldl1 f <$> sepBy1 pa psep

nonAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
nonAssoc f pa psep = pa >>= \left -> f left <$> (psep *> pa) <|> pure left

prefix :: (a -> a) -> Parser a -> Parser op -> Parser a
prefix f pa pop = (pop *> (f <$> pa)) <|> pa

-- Szintaxisfa
--------------------------------------------------------------------------------

data Exp
  = IntLit Integer -- int literál (pozitív)
  | Add Exp Exp -- e + e
  | Sub Exp Exp -- e - e
  | Mul Exp Exp -- e * e
  | BoolLit Bool -- true|false
  | And Exp Exp -- e && e
  | Or Exp Exp -- e || e
  | Not Exp -- not e
  | Eq Exp Exp -- e == e
  | Var String -- (változónév)
  deriving (Eq, Show)

keywords :: [String]
keywords = ["not", "true", "false", "while", "if", "do", "end", "then", "else", "print"]

identifier :: Parser String
identifier = do
  x <- some (satisfy isAlpha)
  guard (not (elem x keywords))
  ws
  return x

keyword :: String -> Parser ()
keyword s = do
  string s
  negative (satisfy isAlpha)
  ws

pVar :: Parser Exp
pVar = Var <$> identifier

pNat :: Parser Exp
pNat = IntLit <$> integer'

pBool :: Parser Exp
pBool = BoolLit <$> (string' "true" $> True <|> string' "false" $> False)

pEnclosed :: Parser Exp
pEnclosed = char' '(' *> pExp <* char' ')'

atom :: Parser Exp
atom = pVar <|> pNat <|> pBool <|> pEnclosed

pNot :: Parser Exp
pNot = prefix Not atom (string' "not")

pMul :: Parser Exp
pMul = rightAssoc Mul pNot (char' '*')

pSub :: Parser Exp
pSub = rightAssoc Sub pMul (char' '-')

pAdd :: Parser Exp
pAdd = rightAssoc Add pSub (char' '+')

pAnd :: Parser Exp
pAnd = rightAssoc And pAdd (string' "&&")

pOr :: Parser Exp
pOr = rightAssoc And pAnd (string' "||")

pEq :: Parser Exp
pEq = nonAssoc Eq pOr (string' "==")

pExp :: Parser Exp
pExp = pEq

type Program = [Statement]

data Statement
  = Assign String Exp -- <var> := <e>
  | While Exp Program -- while <e> do <prog> end
  | If Exp Program Program -- if <e> then <prog> else <prog> end
  | Print Exp
  | DoWhile Program Exp -- do <prog> while <e>
  deriving (Eq, Show)

statement :: Parser Statement
statement =
  Assign <$> identifier
    <*> (string' ":=" *> pExp)
      <|> While <$> (string' "while" *> pExp)
    <*> (string' "do" *> program <* string' "end")
      <|> If <$> (string' "if" *> pExp)
    <*> (string' "then" *> program)
    <*> (((string' "else" *> program) <|> pure []) <* string' "end")
      <|> Print <$> (string' "print" *> pExp)
      <|> DoWhile <$> (string' "do" *> program)
    <*> (string' "while" *> pExp)

program :: Parser Program
program = relaxedSepBy statement (char' ';')

newtype StateF s a = StateF {runState :: s -> Either String (a, s)}

instance Functor (StateF s) where
  fmap = liftM

instance Applicative (StateF s) where
  (<*>) = ap
  pure = return

instance Monad (StateF s) where
  return a = StateF $ \s -> Right (a, s)
  (>>=) m k = StateF $ \s0 -> runState m s0 >>= \(a, s1) -> runState (k a) s1

instance MonadFail (StateF s) where
  fail = StateF . const . Left

evalStateFail :: StateF s a -> s -> Either String a
evalStateFail = (fmap fst .) . runState

execStateFail :: StateF s a -> s -> Either String s
execStateFail = (fmap snd .) . runState

get :: StateF s s
get = StateF (\s -> Right (s, s))

put :: s -> StateF s ()
put = StateF . const . Right . (,) ()

modify :: (s -> s) -> StateF s ()
modify f = get >>= put . f

data Val = VInt Integer | VBool Bool
  deriving (Eq, Show)

type Env = [(String, Val)]

lookup :: Eq a => a -> [(a, b)] -> Maybe b
lookup a [] = Nothing
lookup a ((x, y) : s) = if a == x then Just y else lookup a s

updateEnv :: String -> Val -> Env -> Env
updateEnv l v [] = [(l, v)]
updateEnv l v ((l', v') : x) = if l == l' then (l, v) : x else (l', v') : updateEnv l v x

instance MonadFail (Either String) where
  fail = Left

evalExp :: Exp -> Env -> Either String Val
evalExp (IntLit a) _ = return (VInt a)
evalExp (BoolLit a) _ = return (VBool a)
evalExp (Add a b) env = do
  (VInt a) <- evalExp a env
  (VInt b) <- evalExp b env
  return (VInt (a + b))
evalExp (Sub a b) env = do
  (VInt a) <- evalExp a env
  (VInt b) <- evalExp b env
  return (VInt (a - b))
evalExp (Mul a b) env = do
  (VInt a) <- evalExp a env
  (VInt b) <- evalExp b env
  return (VInt (a * b))
evalExp (And a b) env = do
  (VBool a) <- evalExp a env
  (VBool b) <- evalExp b env
  return (VBool (a && b))
evalExp (Or a b) env = do
  (VBool a) <- evalExp a env
  (VBool b) <- evalExp b env
  return (VBool (a || b))
evalExp (Not a) env = do
  (VBool a) <- evalExp a env
  return (VBool (not a))
evalExp (Eq a b) env = do
  a <- evalExp a env
  b <- evalExp b env
  case (a, b) of
    (VInt a, VInt b) -> return (VBool (a == b))
    (VBool a, VBool b) -> return (VBool (a == b))
    _ -> fail "Type error in =="
evalExp (Var a) env = do
  (Just a) <- return (lookup a env)
  return a

inNewScope :: StateF Env a -> StateF Env a
inNewScope s = do
  len <- length <$> get
  ret <- s
  modify (take len)
  return ret

evalEither :: (MonadFail m) => Either String e -> m e
evalEither (Left s) = fail s
evalEither (Right e) = return e

evalStatement :: Statement -> StateF Env String
evalStatement (Assign l exp) = do
  env <- get
  v <- evalEither $ evalExp exp env
  put (updateEnv l v env)
  return ""
evalStatement (If c yes no) = do
  env <- get
  (VBool c) <- evalEither $ evalExp c env
  inNewScope $
    if c
      then evalProgram yes
      else evalProgram no
evalStatement (While c core) = do
  env <- get
  (VBool c') <- evalEither $ evalExp c env
  if c'
    then do
      a <- inNewScope $ (evalProgram core)
      b <- evalStatement (While c core)
      return (a ++ b)
    else return ""
evalStatement (DoWhile core c) = do
  env <- get
  (VBool c') <- evalEither $ evalExp c env
  a <- inNewScope $ evalProgram core

  if c'
    then do
      b <- evalStatement (DoWhile core c)
      return (a ++ b)
    else return ""
evalStatement (Print v) = do
  env <- get
  v <- evalEither $ evalExp v env
  case v of
    (VBool a) -> return (show a ++ "\n")
    (VInt a) -> return (show a ++ "\n")

evalProgram :: Program -> StateF Env String
evalProgram = fmap fold . traverse evalStatement

-- A feladat:
--------------------------------------------------------------------------------

-- Egészítsd ki a Statement adattípust, a statement parser-t, és az
-- evalStatement függvényt egy do-while ciklussal.
-- Jelentés: "do <program> while <statement>;"
-- A ciklus mag programot futtatjuk amíg az állítás teljesül.
-- A cilus végén történjen a ciklusfeltétel ellenőrzése. A ciklusmag minden
-- esetben fusson le legalább egyszer.

-- A függvényeket lecserélheted a salyát implementációdra.
