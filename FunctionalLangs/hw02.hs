{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wincomplete-patterns #-}

import Control.Applicative
import Control.Monad
import Data.Char
import Data.Maybe

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

suffix :: (a -> a) -> Parser a -> Parser op -> Parser a
suffix f pa pop = ((f <$> pa) <* pop) <|> pa

anyChar :: Parser Char
anyChar = satisfy (\_ -> True)

optional_ :: Parser a -> Parser ()
optional_ p = () <$ optional p

-- A következő regexek támogatottak:
data RegEx
  = -- Atomok:
    -- - (p) : (nincs külön konstruktora,
    --         hiszen a zárójelek nem jelennek meg az absztrakt szintaxisfában)
    -- - a : Karakter literál, amely betű, szóköz vagy szám lehet
    REChar Char
  | -- - [c1-c2] : Két karakter által meghatározott (mindkét oldalról zárt) intervallum
    --             Példák: [a-z], [0-9], ...
    RERange Char Char
  | -- - . : Tetszőleges karakter
    REAny
  | -- - $ : Üres bemenet ("End of file")
    REEof
  | -- Posztfix operátorok:
    -- - p* : Nulla vagy több ismétlés
    REMany RegEx
  | -- - p+ : Egy vagy több ismétlés
    RESome RegEx
  | -- - p? : Nulla vagy egy előfordulás
    REOptional RegEx
  | -- - p{n} : N-szeres ismétlés
    RERepeat RegEx Int
  | -- Infix operátorok:
    -- - Regex-ek egymás után futtatása.
    --   Jobbra asszociáló infix művelet, a szintaxisban "láthatatlan", egyszerűen
    --   egymás után írunk több regexet.
    RESequence RegEx RegEx
  | -- - p1|p2 : Először p1 futtatása, ha az nem illeszkedik, akkor p2.
    -- - Jobbra asszociál.
    REChoice RegEx RegEx
  deriving (Eq, Show)

-- Feladat 1
{-
runParser pRegEx "abc" == Just (RESequence (REChar 'a') (RESequence (REChar 'b') (REChar 'c')),"")
runParser pRegEx "(x|y)*" == Just (REMany (REChoice (REChar 'x') (REChar 'y')),"")
runParser pRegEx "[a-z]{4}$" == Just (RESequence (RERepeat (RERange 'a' 'z') 4) REEof,"")
-}
pChar :: Parser RegEx
pChar = REChar <$> satisfy (\c -> isAlphaNum c || isSpace c)

pRange :: Parser RegEx
pRange = RERange <$> (char '[' *> satisfy isAlphaNum) <*> (char '-' *> satisfy isAlphaNum <* char ']')

pAny :: Parser RegEx
pAny = REAny <$ char '.'

pEof :: Parser RegEx
pEof = REEof <$ char '$'

pEnclosed :: Parser RegEx
pEnclosed = char '(' *> pRegEx <* char ')'

pAtom :: Parser RegEx
pAtom = pRange <|> pAny <|> pChar <|> pEof <|> pEnclosed

pMany :: Parser RegEx
pMany = suffix REMany pAtom (char '*')

pSome :: Parser RegEx
pSome = suffix RESome pMany (char '+')

pOptional :: Parser RegEx
pOptional = suffix REOptional pSome (char '?')

pRepeat :: Parser RegEx
pRepeat = (RERepeat <$> pOptional <*> (char '{' *> (read <$> some (satisfy isDigit)) <* char '}')) <|> pOptional

pSequence :: Parser RegEx
pSequence = foldr1 RESequence <$> ((:) <$> pRepeat <*> many pRepeat)

pChoice :: Parser RegEx
pChoice = rightAssoc REChoice pSequence (char '|')

pRegEx :: Parser RegEx
pRegEx = pChoice

-- Feladat 2
{-
runParser (makeParser (RESome (RERange 'a' 'f'))) "adsf" == Just ((), "sf")
runParser (makeParser (RESome (RERange 'a' 'f'))) "sfad" == Nothing
-}

makeParser :: RegEx -> Parser ()
makeParser regex = case regex of
  REChar c -> char c
  RERange a b -> do
    satisfy (\x -> x >= a && x <= b)
    return ()
  REAny -> do
    satisfy (const True)
    return ()
  REEof -> eof
  REMany e -> do
    many (makeParser e)
    return ()
  RESome e -> do
    some (makeParser e)
    return ()
  REOptional e -> do
    optional (makeParser e)
    return ()
  RERepeat e x -> do
    makeParser e
    if x > 1
      then
        ( do
            makeParser (RERepeat e (x - 1))
            return ()
        )
      else
        ( do
            return ()
        )
    return ()
  RESequence e1 e2 -> do
    makeParser e1
    makeParser e2
    return ()
  REChoice e1 e2 -> do
    makeParser e1 <|> makeParser e2
    return ()

-- Test
{-
Nothing - Helytelen minta
Just False - A minta helyes, azonban a bemenet nem illeszkedik
Just True - A minta is helyes és a bemenet is illeszkedik
-}
test :: String -> String -> Maybe Bool
test pattern input = do
  regEx <- runParser pRegEx pattern
  return (isJust (runParser (makeParser (fst regEx)) input))

test' :: String -> String -> Bool
test' regex str = fromJust $ test regex str

licensePlate = "[A-Z]{3}[0-9]{3}$"

hexColor = "0x([0-9]|[A-F]){6}$"

-- regex101.com/r/rkScYV
-- regexr.com/5rrhl
streetName = "([A-Z][a-z]* )+(utca|út) [0-9]+([A-Z])?"

tests :: [Bool]
tests =
  [ test' licensePlate "ABC123",
    test' licensePlate "IRF764",
    test' licensePlate "LGM859",
    test' licensePlate "ASD789",
    not $ test' licensePlate "ABCD1234",
    not $ test' licensePlate "ABC123asdf",
    not $ test' licensePlate "123ABC",
    not $ test' licensePlate "asdf",
    --

    test' hexColor "0x000000",
    test' hexColor "0x33FE67",
    test' hexColor "0xFA55B8",
    not $ test' hexColor "1337AB",
    not $ test' hexColor "0x1234567",
    not $ test' hexColor "0xAA1Q34",
    --

    test' streetName "Ady Endre út 47C",
    test' streetName "Karinthy Frigyes út 8",
    test' streetName "Budafoki út 3",
    test' streetName "Szilva utca 21A",
    test' streetName "Nagy Lantos Andor utca 9",
    test' streetName "T utca 1",
    not $ test' streetName "ady Endre út 47C",
    not $ test' streetName "KarinthyFrigyes út 8",
    not $ test' streetName "út 3",
    not $ test' streetName "Liget köz 21A",
    not $ test' streetName "Nagy  Lantos  Andor utca 9",
    not $ test' streetName "T utca"
  ]