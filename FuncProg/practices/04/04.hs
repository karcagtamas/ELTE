{-
    Parametric polymorph: Nincs meg kotve a tipus szignatura pl :: a -> a -> a
    Ad-hoc polymorph: Olyan tipus van megkotve, ami tobb tipus kepes befogadni pl :: Num a => a -> a
-}

{-
            Eq
             |
            Ord   Num
              | /    \
    Enum    Real    Fractional
     |  /    |    /      |
  Integral  RealFrac  Floating
                   \    /
                   RealFloat


    Integral = Int, Integer
    Num = Int, Integer, Rational, Float, Double
    Real = Int, Integer, Rational, Float, Double
    Fractional = Rational, Float, Double
    RealFrac = Rational, Float, Double
    Floating = Float, Double
    Floating = Float, Double


    fromIntegral :: (Integral a, Num b) => a -> b
    realToFrac :: (Real a, Fractional b) => a -> b

    5os az Num altalanos tipusi
    5 :: Int - castolva Intre
    fromIntegral (5 :: Int) -> vissza bovitve Num-ra

    Casting: '::'
-}

import Data.Char

{-
    [] - ures lista
    [x] - tartalmaz egyetlen elemet (x) - pontos egyezes (1 db)
    [a, b] - tartalmaz ket element (a, b) - pontos egyezes (2 db)
    (x:xs) - legalabb egy elemet tartalmaz - x kezdetei eleme, xs a maradek (farok eleme) => (xs:x) - ugyanazt jelenti, csak a nevek ki vannak cserelve
    kerek zarojel, legalabb
    (x:y:xs) - legalabb 2 elemet tartalmaz - x, y, xs (maradek)

    ((x, y):xs) - egy lista, aminek legalabb egy eleme van es tuple-eket tartalmaz - homogen szerkezet miatt mindegyik elem tuple lesz
    ((5, _):xs)
    ((5, _):_)
    (x:[]) - pontosan egy elemu lista
-}

head' :: [a] -> a -- Parcialis fv., nem kezel le minden lehetseges bemenetetet ([] ures tomb)
--head' [] = error "Ures lista" -- Custom exception
head' (x:_) = x

tail' :: [a] -> [a]
tail' (_:xs) = xs

-- Ord - orderable => a Num tipus es Ord (rendezheto)
-- Num nem garantalja a rendezhetoseget
min' :: (Ord a, Num a) => (a, a) -> a
--min' :: (Ord a, Num a, Num b) => (a, b) -> a
-- min' (a, b) = if a < b then a else b --NEM SZABAD HASZNALNI
-- | => Guard, logikai erteket var, es az alapjan hajt vegre
-- Mint a minta ilesztesnel, fentrol lefele halad az ellenorzes
-- otherwise fv. - minden mas esetben
min' (a, b)
    | a < b = a
    | otherwise = b

{-
    Guard sokkal leirobb, atlathatobb az if-then-else szemben
-}
comp :: (Ord a, Num a) => a -> a -> String
comp a b
    | a < b = "Kisebb"
    | a == b = "Egyenlo"
    | otherwise = "Nagyobb"
    where c = a * a


{-
    Recursive functions


    Lazy (lusta) kiertekeles
    Mindent csak akkor ertekel ki, amikor szuksege van ra
-}
fact :: Integer -> Integer
fact 0 = 1
fact n = n * fact (n - 1)
-- fact 4 = 4 * fact 3 = 4 * (3 * fact 2) = 4 * (3 * (2 * fact 1)) = 4 * (3 * (2 * fact (1 * fact 0))) = 4 * 3 * 2 * 1 * 1

fib :: Int -> Int
fib 0 = 0
fib 1 = 1
fib x = fib (x - 1) + fib (x - 2)

pow :: Int -> Int -> Int
pow _ 0 = 1
--pow x 1 = x
pow a b = a * pow a (b - 1)

length' :: [a] -> Int
length' [] = 0
length' (_:xs) = 1 + length' xs

sum' :: Num a => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

last' :: [a] -> a
last' [x] = x
last' (_:xs) = last' xs

init' :: [a] -> [a]
init' [x] = []
init' (x:xs) = x : init' xs