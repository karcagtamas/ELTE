import Data.Char

{-
    - Altalanosan leirhato rekurzio
    - Akumulalo rekurzio
-}
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' _ b [] = b
foldr' f b (x:xs) = f x (foldr' f b xs)

foldl' :: (b -> a -> b) -> b -> [a] -> b
foldl' _ b [] = b
foldl' f b (x:xs) = foldl' f (f b x) xs

sum' :: Num a => [a] -> a
sum' = foldr (+) 0

product' :: Num a => [a] -> a
product' = foldr (*) 1

and' :: [Bool] -> Bool
and' = foldr (&&) True

or' :: [Bool] -> Bool
or' = foldr (||) False

length' :: [a] -> Int
length' = foldl (\x _ -> x + 1) 0

-- foldr (\x y -> concat ["(", x, "+", y, ")"]) "0" (map show [1..10])
-- foldl (\x y -> concat ["(", x, "+", y, ")"]) "0" (map show [1..10])

-- Year
-- Tipus szinonima
type Year = Int -- Yeart egyenlove tesszuk Int-tel
y :: Year
y = 2000

-- Parametrikus tipus data
type Compressed a = [(a, Int)]

type Square = (Char, Int)
type ChessTable = [[Square]]

type PredicateOn a = (a -> Bool)

-- Uj tipus
newtype Name = N String deriving (Show, Eq, Ord)
-- N => konstruktor - String-bol Name-t csinal
-- deriving - tulajdonsagok hozzafuzese (show, equality, orderable)
-- String-bol kepez Name tipus N konstruktor segitsegevel

n :: Name
n = N "Alma"

-- newtype vs. data
-- Memoriaban hogyan tarolodnak el az a kulonbseg
-- newtype : konstruktor nelkul tarolodik, csak azt tarolja el, amibol kepeztuk
-- newtype : csak egy konstruktorom lehet emiatt
-- data : eltarolodik a konstruktor is
-- data : mivel a konstruktorok is eltarolodnak, ezert tobb lehet neki

type X = Int
type Y = Int

data Ipoint = PP (X, Y) deriving (Show, Eq, Ord)
data Ship = RS String | SS String Int deriving (Show, Eq, Ord)
data Foor a = F a deriving (Eq, Show)

-- | elvalasztjuk a konstruktorokat
-- Konstruktor nev utan jonnek a tipusok felsorolva
-- deriving - tulajdonsagok

{-
    Minta illesztes

    - x
    - (PP x)
    - (PP (x,y))
-}

mirrorO' :: Ipoint -> Ipoint
mirrorO' (PP (x, y)) = PP (-x, -y)

mirrorP' :: Ipoint -> Ipoint -> Ipoint
mirrorP' (PP (x1, y1)) (PP (x2, y2)) = PP (x2 + x2 - x1, y2 + y2 - y1)

translate :: (X, Y) -> Ipoint -> Ipoint
translate (a, b) (PP (x,y)) = PP (x + a, y + b)