{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-tabs -Wno-noncanonical-monad-instances #-}

import Control.Applicative hiding (choice, many, optional, some)
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

instance Alternative Parser where
  empty :: Parser a
  empty = Parser (const empty)

  (<|>) :: Parser a -> Parser a -> Parser a
  (<|>) (Parser a) (Parser b) = Parser (\s -> a s <|> b s)

optional :: Alternative f => f a -> f (Maybe a)
optional v = Just <$> v <|> pure Nothing

many :: Alternative f => f a -> f [a]
many v = some v <|> pure []

some :: Alternative f => f a -> f [a]
some v = (:) <$> v <*> many v

instance MonadFail Parser where
  fail :: String -> Parser a
  fail = const empty

instance MonadPlus Parser where
  mzero :: Parser a
  mzero = empty

  mplus :: Parser a -> Parser a -> Parser a
  mplus = (<|>)

take1 :: (Foldable f, Alternative g) => f a -> g a
take1 f = foldr (const . pure) empty f

evalParser :: Parser p -> String -> Maybe p
evalParser p s = fst <$> (take1 $ runParser p s)

-- 1. Feladat
--------------------------------------------------------------------------------

-- Írj egy Parser-t ami értelmezi a következő regexet:
-- b?(a|(k*)e)+(ba){3,}$
p1 :: Parser ()
p1 = do
  optional (char 'b')
  some (char 'a' <|> (many (char 'k') *> char 'e'))
  string "bababa"
  many (string "ba")
  eof
  return ()

{-- Bővebben kifejtve:

b?
Opcionálisan
 	Egy 'b' karakter

(a|(k*)e)+
Egyszer vagy többször
  Alábbiak közül az egyik
		Egy 'a' karakter
		Nullaszor vagy többször 'k' karakter, majd egy 'e' karakter

(ba){3,}
A szöveg "ba" háromszor vagy többször

$
A bemenet vége (eof)

--}

-- Tesztek
testp1 :: Int -> Bool
testp1 0 = evalParser p1 "babababa" == Just ()
testp1 1 = evalParser p1 "bakebababa" == Just ()
testp1 2 = evalParser p1 "keke" == Nothing
testp1 3 = evalParser p1 "abababa" == Just ()
testp1 4 = evalParser p1 "kkkkkkkebababababa" == Just ()
testp1 5 = evalParser p1 "kkekkekkebababababa" == Just ()
testp1 _ = undefined

testp1all :: Bool
testp1all = all testp1 [0 .. 5]

-- 2. Feladat
--------------------------------------------------------------------------------

-- Adott a readInteger függvény nem negatív egész számokra
readInteger :: Parser Integer
readInteger = read <$> some (satisfy isDigit)

-- Írj egy Parser-t ami beolvas '+' szimbólummal elválasztott természetes számokat és az összegüket adja vissza.
-- A bemenetnek legalább 1 számot tartalmaznia kell. Lásd az alábbi teszteket.
-- Példa bemenetek: "52", "10+20", "5+5+3", "1+1+1+1+1+1+1+1+1+1"
-- Regex: [0-9]+(\+[0-9]+)
p2 :: Parser Integer
p2 = do
  a <- readInteger
  optional (char '+')
  others <- many p2
  return (sum others + a)

-- Tesztek
testp2 :: Int -> Bool
testp2 0 = evalParser p2 "52" == Just 52
testp2 1 = evalParser p2 "10+20" == Just 30
testp2 2 = evalParser p2 "5+5+3" == Just 13
testp2 3 = evalParser p2 "" == Nothing
testp2 4 = evalParser p2 "baba" == Nothing
testp2 5 = evalParser p2 "1+1+1+1+1+1+1+1+1+1" == Just 10
testp2 _ = undefined

testp2all :: Bool
testp2all = all testp2 [0 .. 5]