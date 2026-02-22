{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE LambdaCase #-}
{-# OPTIONS_GHC -Wincomplete-patterns #-}

module Megoldas where

import Control.Applicative
import Control.Exception
import Control.Monad.State
import Data.Char
import Data.Foldable

--- Data Exercise

data FList f a = FCons (f a) (FList f a) | FNil deriving (Eq, Show)

infixr 5 `FCons`

f1 :: FList [] Int
f1 = [1, 2, 3] `FCons` [4, 5] `FCons` [6] `FCons` FNil

f2 :: FList Maybe Bool
f2 = Just True `FCons` f2

f3 :: FList [] Char
f3 = "hello" `FCons` "world" `FCons` FNil

instance Functor f => Functor (FList f) where
  fmap _ FNil = FNil
  fmap fm (FCons x ne) = FCons (fmap fm x) (fmap fm ne)

instance Foldable f => Foldable (FList f) where
  foldr _ b FNil = b
  foldr fm b (FCons x ne) = foldr fm (foldr fm b ne) x

instance Traversable f => Traversable (FList f) where
  sequenceA FNil = pure FNil
  sequenceA (FCons x ne) = FCons <$> sequenceA x <*> sequenceA ne

flistToList :: FList f a -> [f a]
flistToList FNil = []
flistToList (FCons f fl) = f : flistToList fl

listToFlist :: [f a] -> FList f a
listToFlist xs = foldr FCons FNil xs

runToIO :: FList IO a -> IO (FList Maybe a)
runToIO FNil = do
  return FNil
runToIO (FCons f fl) = do
  r <- runToIO fl

  return (FCons Nothing r)

-- Parser monad

newtype Parser a = MkParser {runParser :: String -> Maybe (String, a)}
  deriving (Functor)

instance Applicative Parser where
  pure a = MkParser $ \s -> Just (s, a)
  (<*>) = ap

instance Monad Parser where
  (MkParser a) >>= f = MkParser $ \s -> case a s of
    Nothing -> Nothing
    Just (s', p) -> runParser (f p) s'

instance Alternative Parser where
  empty = MkParser $ const Nothing
  (MkParser f) <|> (MkParser g) = MkParser $ \a -> f a <|> g a

-- Primitive parser combinators

satisfy :: (Char -> Bool) -> Parser Char
satisfy p = MkParser $ \case
  (c : cs) | p c -> Just (cs, c)
  _ -> Nothing

eof :: Parser ()
eof = MkParser $ \case
  [] -> Just ([], ())
  _ -> Nothing

-- Non-primitive parser combinators

char, char' :: Char -> Parser ()
char c = void $ satisfy (== c)
char' = tok . char

anychar, anychar' :: Parser Char
anychar = satisfy (const True)
anychar' = tok anychar

string, string' :: String -> Parser ()
string = mapM_ char
string' = tok . string

sepBy1 :: Parser a -> Parser sep -> Parser [a]
sepBy1 a sep = liftA2 (:) a ((sep *> sepBy1 a sep) |> [])

sepBy :: Parser a -> Parser sep -> Parser [a]
sepBy a sep = sepBy1 a sep |> []

between :: Parser l -> Parser a -> Parser r -> Parser a
between l a r = l *> a <* r

-- Alternative combinators

many_ :: Parser a -> Parser ()
many_ = void . many

some_ :: Parser a -> Parser ()
some_ = void . some

choice :: [Parser a] -> Parser a
choice = asum

choice_ :: [Parser a] -> Parser ()
choice_ = void . choice

(|>) :: (Alternative f) => f a -> a -> f a
f |> a = f <|> pure a

infixl 3 |>

-- Whitespace & Tokenization

ws :: Parser ()
ws = many_ $ satisfy isSpace

tok :: Parser a -> Parser a
tok p = p <* ws

topLevel :: Parser a -> Parser a
topLevel p = ws *> tok p <* eof

-- Prognyelv

pDigit :: Parser Int
pDigit = digitToInt <$> satisfy isDigit

pPos, pPos' :: Parser Int
pPos = do
  ds <- some pDigit
  pure $ sum $ zipWith (*) (reverse ds) (iterate (* 10) 1)
pPos' = tok pPos

rightAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
rightAssoc f pa psep = chainr1 pa (f <$ psep)

leftAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
leftAssoc f pa psep = chainl1 pa (f <$ psep)

chainr1 :: Parser a -> Parser (a -> a -> a) -> Parser a
chainr1 v op = do
  val <- v
  ( do
      opr <- op
      res <- chainr1 v op
      pure (opr val res)
    )
    <|> pure val

chainl1 :: Parser a -> Parser (a -> a -> a) -> Parser a
chainl1 v op = v >>= parseLeft
  where
    parseLeft val =
      ( do
          opr <- op
          val2 <- v
          parseLeft (opr val val2)
      )
        <|> pure val

nonAssoc :: (a -> a -> a) -> Parser a -> Parser sep -> Parser a
nonAssoc f pa psep = do
  exps <- sepBy1 pa psep
  case exps of
    [e] -> pure e
    [e1, e2] -> pure (f e1 e2)
    _ -> empty

prefix :: (a -> a) -> Parser a -> Parser op -> Parser a
prefix f pa pop = (pop *> (f <$> pa)) <|> pa

-- RDP Algorithm

{-

Precedence Table
+---------------+---------------+---------------+
| Name          | Precedence    | Direction     |
+---------------+---------------+---------------+
| not           | 7             | Prefix        |
+---------------+---------------+---------------+
| *             | 6             | Right         |
+---------------+---------------+---------------+
| +             | 5             | Right         |
+---------------+---------------+---------------+
| -             | 4             | Right         |
+---------------+---------------+---------------+
| &&            | 3             | Right         |
+---------------+---------------+---------------+
| ||            | 2             | Right         |
+---------------+---------------+---------------+
| ==            | 1             | None          |
+---------------+---------------+---------------+

-}

data Exp
  = IntLit Int -- Int literal
  | Add Exp Exp -- e + e
  | Sub Exp Exp -- e - e
  | Mul Exp Exp -- e * e
  | BoolLit Bool -- true|false
  | And Exp Exp -- e && e
  | Or Exp Exp -- e || e
  | Not Exp -- not e
  | Eq Exp Exp -- e == e
  | Var String -- <variable>
  | Delay Exp -- ~
  | Force Exp -- !
  | Closure Env Exp
  deriving (Eq, Show)

keywords = ["not", "true", "false", "while", "if", "do", "end", "then", "else", "lazy"]

ident' :: Parser String
ident' = do
  x <- some (satisfy isAlpha) <* ws
  if x `elem` keywords
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
    <|> (IntLit <$> pPos')
    <|> (BoolLit True <$ keyword' "true")
    <|> (BoolLit False <$ keyword' "false")
    <|> (char' '(' *> pExp <* char' ')')

forceExp :: Parser Exp
forceExp = prefix Force atom (char' '!') <|> atom

delayExp :: Parser Exp
delayExp = prefix Delay forceExp (char' '~') <|> forceExp

notExp :: Parser Exp
notExp =
  prefix Not delayExp (keyword' "not")
    <|> delayExp

mulExp :: Parser Exp
mulExp = rightAssoc Mul notExp (char' '*')

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

-- AST Evaluation
data Val = VInt Int | VBool Bool | VThunk Exp
  deriving (Eq, Show)

type Env = [(String, Val)]

evalExp :: Env -> Exp -> Val
evalExp env e = case e of
  IntLit n -> VInt n
  BoolLit b -> VBool b
  Add e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VInt n1, VInt n2) -> VInt (n1 + n2)
    (VThunk e1, VThunk e2) -> VThunk (Closure env (Add e1 e2))
    (VThunk e1, _) -> VThunk (Closure env (Add e1 e2))
    (_, VThunk e2) -> VThunk (Closure env (Add e1 e2))
    _ -> error "type error in one of the operands of +"
  Sub e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VInt n1, VInt n2) -> VInt (n1 - n2)
    (VThunk e1, VThunk e2) -> VThunk (Closure env (Sub e1 e2))
    (VThunk e1, _) -> VThunk (Closure env (Sub e1 e2))
    (_, VThunk e2) -> VThunk (Closure env (Sub e1 e2))
    _ -> error "type error in one of the operands of -"
  Mul e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VInt n1, VInt n2) -> VInt (n1 * n2)
    (VThunk e1, VThunk e2) -> VThunk (Closure env (Mul e1 e2))
    (VThunk e1, _) -> VThunk (Closure env (Mul e1 e2))
    (_, VThunk e2) -> VThunk (Closure env (Mul e1 e2))
    _ -> error "type error in one of the operands of *"
  Or e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VBool b1, VBool b2) -> VBool (b1 || b2)
    (VThunk e1, VThunk e2) -> VThunk (Closure env (Or e1 e2))
    (VThunk e1, _) -> VThunk (Closure env (Or e1 e2))
    (_, VThunk e2) -> VThunk (Closure env (Or e1 e2))
    _ -> error "type error in one of the operands of ||"
  And e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VBool b1, VBool b2) -> VBool (b1 && b2)
    (VThunk e1, VThunk e2) -> VThunk (Closure env (And e1 e2))
    (VThunk e1, _) -> VThunk (Closure env (And e1 e2))
    (_, VThunk e2) -> VThunk (Closure env (And e1 e2))
    _ -> error "type error in one of the operands of &&"
  Eq e1 e2 -> case (evalExp env e1, evalExp env e2) of
    (VBool b1, VBool b2) -> VBool (b1 == b2)
    (VInt n1, VInt n2) -> VBool (n1 == n2)
    (VThunk e1, VThunk e2) -> VThunk (Closure env (Eq e1 e2))
    (VThunk e1, _) -> VThunk (Closure env (Eq e1 e2))
    (_, VThunk e2) -> VThunk (Closure env (Eq e1 e2))
    _ -> error "type error in one of the operands of =="
  Not e -> case evalExp env e of
    VBool b -> VBool (not b)
    VThunk e -> VThunk (Closure env (Not e))
    _ -> error "type error in the operand of not"
  Var x -> case lookup x env of
    Just v -> v
    Nothing -> error $ "name not in scope: " ++ x
  Delay e -> VThunk (Closure env e)
  Force e -> case evalExp env e of
    VThunk e -> evalExp env (Force e)
    x -> x
  Closure savedEnv e -> evalExp savedEnv e

-- Program statements

type Program = [Statement] -- st1; st2; st3; ... st4

data Statement
  = Assign String Exp -- x := e
  | While Exp Program -- while e do prog end
  | If Exp Program Program -- if e then prog1 else prog2 end
  | AutoLazyAssign String Exp -- lazy x := e
  deriving (Eq, Show)

statement :: Parser Statement
statement =
  (AutoLazyAssign <$> (string' "lazy" *> ident') <*> (string' ":=" *> pExp))
    <|> ( Assign
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

program :: Parser Program
program = sepBy statement (char' ';')

inNewScope :: State Env a -> State Env a
inNewScope ma = do
  l <- gets length
  a <- ma
  modify (take l)
  pure a

updateEnv :: String -> Val -> Env -> Env
updateEnv x v [] = [(x, v)]
updateEnv x v ((y, v') : env)
  | x == y = (x, v) : env
  | otherwise = (y, v') : updateEnv x v env

evalStatement :: Statement -> State Env ()
evalStatement st = case st of
  AutoLazyAssign x e -> do
    env <- get
    put $ updateEnv x (VThunk (Closure env e)) env
  Assign x e -> do
    env <- get
    let val = evalExp env e
    put $ updateEnv x val env
  While e p -> do
    env <- get
    case evalExp env (Force e) of
      VBool True -> inNewScope (evalProgram p) >> evalStatement (While e p)
      VBool False -> pure ()
      _ -> error "type error in the loop condition of while"
  If e p1 p2 -> do
    env <- get
    case evalExp env (Force e) of
      VBool True -> inNewScope (evalProgram p1)
      VBool False -> inNewScope (evalProgram p2)
      _ -> error "type error in the branch condition of if"

evalProgram :: Program -> State Env ()
evalProgram = mapM_ evalStatement

run :: String -> Env
run str = case runParser (topLevel program) str of
  Just (_, prog) -> execState (evalProgram prog) []
  Nothing -> error "parse error"
