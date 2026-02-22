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

-- Parser
--------------------------------------------------------------------------------

-- Válassz nehézségi szintet:

-- Könnyű mód --
-- newtype Parser a = Parser {runParser :: String -> [(a, String)]}

-- Nagyon könnyű mód --
newtype Parser a = Parser {runParser :: String -> Maybe (a, String)}

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

-- Emlékeztető: Functor/Applicative operátorok
--   (<$)       kicserélni parser eredményét adott értékre
--   (<$>)      végrehajt egy függvényt a parser eredményén
--   (<*)       két parser-t futtat, az első értékét visszaadja
--   (*>)       két parser-t futtat, a második értékét visszaadja

-- Szintaxis segédfüggvények
--------------------------------------------------------------------------------

-- Szóköz
ws :: Parser ()
ws = void $ many (satisfy isSpace)

sepBy :: Parser a -> Parser sep -> Parser [a]
sepBy pa psep = sepBy1 pa psep <|> pure []

sepBy1 :: Parser a -> Parser sep -> Parser [a]
sepBy1 pa psep = (:) <$> pa <*> many (psep *> pa)

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
  | Mul Exp Exp -- e * e
  | Var String -- szimbólum
  | BoolLit Bool -- bool érték
  | Not Exp -- not e
  | Eq Exp Exp -- e == e
  deriving (Show)

-- Kötési erősségek:
--   - atomok: literálok, változók, zárójelezett kifejezések
--   - ! alkalmazás
--   - *     : jobbra asszociál
--   - +     : jobbra asszociál
--   - ==    : nem asszociatív

-- pExp :: Parser Exp
-- pExp-et használjuk rekurzívan néhány Parser-ben de a végén fogjuk definiálni.

-- Szimbólum (változónév)
pVar :: Parser Exp
pVar = Var <$> some (satisfy isAlpha) <* ws

-- Természetes szám literál
pNat :: Parser Exp
pNat = NatLit <$> natural'

pBool :: Parser Exp
pBool = string' "True" $> BoolLit True <|> string' "False" $> BoolLit False

-- runParser (rightAssoc (+) (natural') (char '+')) "3 + 4"

-- Zárójelekkel körbezárt kifejezés
pEnclosed :: Parser Exp
pEnclosed = char' '(' *> pExp <* char' ')'

-- Környezetfüggetlen kifejezés
atom :: Parser Exp
atom = pVar <|> pNat <|> pBool <|> pEnclosed

pNot :: Parser Exp
pNot = prefix Not atom (string' "not")

pMul :: Parser Exp
pMul = rightAssoc Mul pNot (char' '*') -- pNot a kovetkezo assoc szint ahol nem lehet *

pAdd :: Parser Exp
pAdd = rightAssoc Plus pMul (char' '+') -- pMul a kovetkezo assoc szint ahol nem lehet +

pEq :: Parser Exp
pEq = nonAssoc Eq pAdd (string' "==")

pExp :: Parser Exp
pExp = pEq -- Sorrendised Eq -> Add -> Mul -> Not -> atom ==> operator precedence

-- Írjuk meg a kifejezés kiértékelését!
-- A paraméterül kapott függvény segítségével helyettesítsük be a Var értékeket.
substExp :: (String -> Exp) -> Exp -> Exp
substExp f (Var x) = f x
substExp _ (BoolLit x) = BoolLit x
substExp _ (NatLit x) = NatLit x
substExp f (Not x) = Not (substExp f x)
substExp f (Eq e1 e2) = Eq (substExp f e1) (substExp f e2)
substExp f (Plus e1 e2) = Plus (substExp f e1) (substExp f e2)
substExp f (Mul e1 e2) = Mul (substExp f e1) (substExp f e2)

-- evalExp (\x -> undefined) (fst $ fromJust $ runParser pExp "1==2")
evalExp :: (String -> Maybe (Either Integer Bool)) -> Exp -> Maybe (Either Integer Bool)
evalExp _ (NatLit x) = Just $ Left x
evalExp _ (BoolLit x) = Just $ Right x
evalExp f (Var x) = f x
evalExp f (Not x) = do
  x <- evalExp f x
  case x of
    Left l -> Nothing
    Right r -> Just $ Right (not r)
evalExp f (Eq e1 e2) = do
  x1 <- evalExp f e1
  x2 <- evalExp f e2

  case x1 of
    Left l1 -> case x2 of
      Left l2 -> Just $ Right (l1 == l2)
      Right _ -> Nothing
    Right r1 -> case x2 of
      Left _ -> Nothing
      Right r2 -> Just $ Right (r1 == r2)
evalExp f (Plus e1 e2) = do
  x1 <- evalExp f e1
  x2 <- evalExp f e2

  case x1 of
    Left l1 -> case x2 of
      Left l2 -> Just $ Left (l1 + l2)
      Right _ -> Nothing
    Right _ -> Nothing
evalExp f (Mul e1 e2) = do
  x1 <- evalExp f e1
  x2 <- evalExp f e2

  case x1 of
    Left l1 -> case x2 of
      Left l2 -> Just $ Left (l1 * l2)
      Right _ -> Nothing
    Right _ -> Nothing

-- További gyakorlásként adjunk hozzá a kifejezésfához még több operátort.

-- '-' pre`fix és infix operátor
-- Bónusz: Mire van szükségünk hogy azonos kötése legyen mint a + operátornak?

-- '&&' és '||' logikai operátorok (&& köt erősebben)

-- Bónusz: Írjunk parser-t típusozatlan lambda kalkuluszhoz!
--------------------------------------------------------------------------------

-- példák : \f x -> f x
--          (\x -> x) (\x -> x)
--          (\f x y -> f) x (g x)

data Tm = TVar String | App Tm Tm | Lam String Tm deriving (Show)

subst :: String -> Tm -> Tm -> Tm
subst s k (TVar z) = if s == z then k else (TVar z)
subst s k (App a b) = App (subst s k a) (subst s k b)
subst s k (Lam z a) = Lam z (if s == z then a else (subst s k a))

reduce :: Tm -> Tm
reduce (App a b) = case reduce a of
  (Lam s k) -> reduce $ subst s b k
  a -> App a b
reduce s = s

pTm :: Parser Tm
pTm = undefined