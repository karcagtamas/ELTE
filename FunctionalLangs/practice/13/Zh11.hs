{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-tabs -Wno-noncanonical-monad-instances #-}

import Control.Applicative
import Control.Monad
import Data.Char
import Data.Foldable
import Data.Functor

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

-- Döntés és Hiba
instance Alternative Parser where
  empty :: Parser a
  empty = Parser (const empty)

  (<|>) :: Parser a -> Parser a -> Parser a
  (<|>) (Parser a) (Parser b) = Parser (\s -> a s <|> b s)

-- Hiba szöveggel. Do notációban hasznos!
instance MonadFail Parser where
  fail :: String -> Parser a
  fail = const empty

-- Alternative és Monad kombinációja
instance MonadPlus Parser where
  mzero :: Parser a
  mzero = empty

  mplus :: Parser a -> Parser a -> Parser a
  mplus = (<|>)

-- Csak azokat a bemeneteket ismeri fel amiket az adott minta nem ismer fel.
negative :: Parser a -> Parser ()
negative (Parser p) = Parser $ \s -> if null (p s) then pure ((), s) else empty

-- Kizárólag az üres bemenetet ismeri fel
eof :: Parser ()
eof = Parser $ \s -> case s of
  [] -> pure ((), [])
  _ -> empty

-- Egyetlen, az adott feltételt teljesítő karaktert fogad el
satisfy :: (Char -> Bool) -> Parser Char
satisfy f = Parser $ \s -> case s of
  [] -> empty
  (x : xs) -> (x, xs) <$ guard (f x)

-- A konkrét karaktert fogadja el
char :: Char -> Parser ()
char c = void $ satisfy (== c)

-- A konkrét szöveget fogadja el
string :: String -> Parser ()
string [] = pure ()
string (x : xs) = char x *> string xs

-- Természetes szám
natural :: Parser Integer
natural = read <$> some (satisfy isDigit)

-- Egész szám
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

-- Szintaxis segédfüggvények
--------------------------------------------------------------------------------

-- Szóköz
ws :: Parser ()
ws = void $ many (satisfy isSpace)

sepBy :: Parser a -> Parser sep -> Parser [a]
sepBy pa psep = sepBy1 pa psep <|> pure []

sepBy1 :: Parser a -> Parser sep -> Parser [a]
sepBy1 pa psep = (:) <$> pa <*> many (psep *> pa)

relaxedSepBy :: Parser a -> Parser sep -> Parser [a]
relaxedSepBy pa psep = concatMap toList <$> sepBy (optional pa) psep

-- Top level
topLevel :: Parser a -> Parser a
topLevel pa = ws *> pa <* eof

-- Operátor segédfüggvények
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

{-
Változónév: nemüres alfabetikus string, ami nem kulcs szó
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

-- While nyelv parsolása
--------------------------------------------------------------------------------

type Program = [Statement] -- st1; st2; st3; ... st4

data Statement
  = Assign String Exp -- <var> := <e>
  | While Exp Program -- while <e> do <prog> end
  | If Exp Program Program -- if <e> then <prog> else <prog> end
  | Print Exp
  | Swap String String
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
      <|> Swap <$> (string' "swap" *> identifier)
    <*> identifier

program :: Parser Program
program = relaxedSepBy statement (char' ';')

-- A feladat:
--------------------------------------------------------------------------------

-- Egészítsd ki a fenti Statement adattípust és statement parser-t egy swap
-- utasítással.
-- Jelentés: "swap x y;" Felcseréli az "x" és "y" nevű változók értékét.
-- Kizárólag változó nevek szerepelhetnek.

-- A függvényeket lecserélheted a salyát implementációdra.
