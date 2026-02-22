{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveTraversable #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-tabs -Wno-noncanonical-monad-instances #-}

import Control.Applicative
import Control.Monad
import Data.Char
import Data.Functor

-- Bármit használhatsz a megoldáshoz, más személy vagy M.I. segítségén kívül.

-- Parser
--------------------------------------------------------------------------------

-- Válassz nehézségi szintet:

-- Könnyű mód --
-- newtype Parser a = Parser {runParser :: String -> [(a, String)]}

-- Nagyon könnyű mód --
newtype Parser a = Parser {runParser :: String -> Maybe (a, String)}

-- Mindkét feladatot ugyanazzal kell megoldani
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

-- 1. Feladat
--------------------------------------------------------------------------------

-- Írj Parser-t ami értelmezi az Either típust Haskell szintaxis szerint.
-- Példa bemenethez lásd a teszteket
pEither :: Parser a -> Parser b -> Parser (Either a b)
pEither a b = Left <$> (string' "Left" *> a) <|> Right <$> (string' "Right" *> b)

-- Megjegyzés: Az eseteket amikor hiányzik a szóköz (Pl "Left5") figyelmen kívül lehet hagyni.

testp1 :: Int -> Bool
testp1 0 = evalParser (pEither (integer') (string' "baba")) "Left 5" == Just (Left 5)
testp1 1 = evalParser (pEither (integer') (string' "baba")) "Right baba" == Just (Right ())
testp1 2 = evalParser (pEither (integer') (string' "baba")) "Right 5" == Nothing
testp1 3 = evalParser (pEither (integer') (string' "baba")) "Left baba" == Nothing
testp1 4 = evalParser (pEither (integer') (string' "baba")) "5" == Nothing
testp1 5 = evalParser (pEither (integer') (string' "baba")) "baba" == Nothing
testp1 _ = undefined

testp1all :: Bool
testp1all = all testp1 [0 .. 5]

-- 2. Feladat
--------------------------------------------------------------------------------

data RoseTree a = N a [RoseTree a] deriving (Eq, Show)

-- Írj Parser-t ami értelmez tetszőleges RoseTree elemeket
-- Példa bemenethez lásd a teszteket
pRoseTree :: Parser a -> Parser (RoseTree a)
pRoseTree a = char 'N' *> (N <$> a <*> pList (pRoseTree a))

testp2 :: Int -> Bool
testp2 0 =
  evalParser (pRoseTree (integer')) "N 5 []"
    == Just (N 5 [])
testp2 1 =
  evalParser (pRoseTree (integer')) "N 0 [N 1 [N 2 []]]"
    == Just (N 0 [N 1 [N 2 []]])
testp2 2 =
  evalParser (pRoseTree (integer')) "N 2 [N 3 [],N 5 [],N 7 []]"
    == Just (N 2 [N 3 [], N 5 [], N 7 []])
testp2 3 =
  evalParser (pRoseTree (integer')) "N 2 [N 3 [ ] , N 5 [ N 11 [ ] ] , N 7 [ ] ] "
    == Just (N 2 [N 3 [], N 5 [N 11 []], N 7 []])
testp2 4 = evalParser (pRoseTree (integer')) "N 2 [N 3 [ ] , N 5 [ N 1 1 [ ] ] , N 7 [ ] ] " == Nothing
testp2 5 = evalParser (pRoseTree (integer')) "" == Nothing
testp2 _ = undefined

testp2all = all testp2 [0 .. 5]