{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-tabs -Wno-noncanonical-monad-instances #-}

import Control.Applicative
import Control.Monad
import Data.Char
import Data.Functor
import Data.Maybe (fromJust)

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

take1 :: (Foldable f, Alternative g) => f a -> g a
take1 f = foldr (const . pure) empty f

evalParser :: Parser p -> String -> Maybe p
evalParser p s = fst <$> (take1 $ runParser p s)

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

-- Egész szám
integer :: Parser Integer
integer = (negate . read <$ char '-' <|> pure read) <*> some (satisfy isDigit)

-- Szóköz
ws :: Parser ()
ws = void $ many (satisfy isSpace)

char' :: Char -> Parser ()
char' c = char c <* ws

string' :: String -> Parser ()
string' s = string s <* ws

integer' :: Parser Integer
integer' = integer <* ws

-- Olvassunk 1 vagy többet, psep-el elválasztva
sepBy1 :: Parser a -> Parser sep -> Parser [a]
sepBy1 pa psep = (:) <$> pa <*> many (psep *> pa)

-- Olvassunk 0 vagy többet, psep-el elválasztva
sepBy :: Parser a -> Parser sep -> Parser [a]
sepBy pa psep = sepBy1 pa psep <|> pure []

-- pList segédfüggvény: Listát olvasó parser
pList :: Parser a -> Parser [a]
pList a = char' '[' *> sepBy a (char' ',') <* char' ']'

-- pPair segédfüggvény: Párt olvasó parser
pPair :: Parser a -> Parser b -> Parser (a, b)
pPair a b = char' '(' *> ((,) <$> a <*> (char' ',' *> b <* char' ')'))

-- Szintaxis segédfüggvények
--------------------------------------------------------------------------------

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
  = NatLit Integer -- egész szám
  | Plus Exp Exp -- e + e
  | Sub Exp Exp -- e - e
  | Mul Exp Exp -- e * e
  | Var String -- szimbólum
  | BoolLit Bool -- bool érték
  | Not Exp -- not e
  | Eq Exp Exp -- e == e
  deriving (Show)

pVar :: Parser Exp
pVar = Var <$> (some (satisfy isAlpha) <* ws)

pNat :: Parser Exp
pNat = NatLit <$> (read <$> (some (satisfy isDigit))) <* ws

pBool :: Parser Exp
pBool = BoolLit <$> (string' "True" $> True <|> string' "False" $> False)

pEnclosed :: Parser Exp
pEnclosed = char' '(' *> pExp <* char' ')'

atom :: Parser Exp
atom = pVar <|> pNat <|> pBool <|> pEnclosed

pNot :: Parser Exp
pNot = prefix Not atom (char' '!')

pMul :: Parser Exp
pMul = rightAssoc Mul pNot (char' '*')

pSub :: Parser Exp
pSub = rightAssoc Sub pMul (char' '-')

pAdd :: Parser Exp
pAdd = rightAssoc Plus pSub (char' '+')

pEq :: Parser Exp
pEq = nonAssoc Eq pAdd (string' "==")

pExp :: Parser Exp
pExp = pEq

evalExp :: (String -> Maybe (Either Integer Bool)) -> Exp -> Maybe (Either Integer Bool)
evalExp f (NatLit a) = pure $ Left a
evalExp f (BoolLit a) = pure $ Right a
evalExp f (Var s) = f s
evalExp f (Plus a b) = do
  (Left a) <- evalExp f a
  (Left b) <- evalExp f b
  return $ Left (a + b)
evalExp f (Sub a b) = do
  (Left a) <- evalExp f a
  (Left b) <- evalExp f b
  return $ Left (a - b)
evalExp f (Mul a b) = do
  (Left a) <- evalExp f a
  (Left b) <- evalExp f b
  return $ Left (a * b)
evalExp f (Not a) = do
  (Right a) <- evalExp f a
  return $ Right (not a)
evalExp f (Eq a b) = do
  a <- evalExp f a
  b <- evalExp f b
  case (a, b) of
    (Left a, Left b) -> return $ Right (a == b)
    (Right a, Right b) -> return $ Right (a == b)
    (_, _) -> Nothing

-- A feladat:
--------------------------------------------------------------------------------

-- Egészítsd ki a fenti Exp adattípust, Parser függvényeket és evalExp függvényt
-- egy kivonás (-) bináris operátorral. Az operátor kötési erőssége a
-- matematikában használt megszokott értelmezést eredményezze.

-- Legyen megfelelően kiértékelve például: 20 + 5 - 10 + 5 == 20

-- A függvényeket lecserélheted a salyát implementációdra.