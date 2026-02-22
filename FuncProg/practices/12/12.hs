import Data.Char
import Data.List

-- 1. Parok parja
splitQuadruple :: (a, b, c, d) -> ((a, b), (c, d))
splitQuadruple (a,b,c,d) = ((a,b), (c,d))

-- 2. Szamok tavolsaga
dist1 :: Num a => a -> a -> a
dist1 a b = abs (a - b)

-- 3. Kroenecker-delta
kroeneckerDelta :: Eq a => a -> a -> Int
kroeneckerDelta a b
    | a == b = 1
    | otherwise = 0

-- 4. Elofordulasok
freq :: Eq a => a -> [a] -> Int
freq a xs = length $ filter (\x -> x == a) xs

-- 5. Nagybetu
hasUpperCase :: String -> Bool
hasUpperCase = any (\x -> isUpper x)

-- 6. Azonosito
identifier :: String -> Bool
identifier [] = False
identifier (x:xs)
    | not $ isAlpha x = False
    | not $ all (\x -> isAlphaNum x || x == '_') xs = False
    | otherwise = True

-- 7. Csere
replace :: Int -> a -> [a] -> [a]
replace _ a [] = [a]
replace n a (x:xs)
    | n < 0 = a : x : xs
    | n == 0 = a : xs
    | otherwise = x : replace (n - 1) a xs

-- 8. Paros-paratlan
paripos :: [Int] -> Bool
paripos [] = True
paripos [a] = even a
paripos (a:b:xs) = even a && odd b && paripos xs

-- 9. Biztonsagos osztas
safeDiv :: Int -> Int -> Maybe Int
safeDiv _ 0 = Nothing
safeDiv a b = Just (a `div` b)

-- 10. Elvalaszto jelek
parseCSV :: String -> [String]
parseCSV [] = [""]
parseCSV s = (takeWhile pred s) : next (dropWhile pred s) where
    pred x = not (x == ';')
    next [] = []
    next (';':xs) = parseCSV xs
    next xs = parseCSV xs

-- 11. C kombinator
c :: (a -> b -> c) -> b -> a -> c
c f x y = f y x

-- 12. Kiveve, ha ...
selectUnless :: (t -> Bool) -> (t -> Bool) -> [t] -> [t]
selectUnless p1 p2 = filter (\x -> p1 x && (not $ p2 x))

-- 13. W kombinator
w :: (a -> a -> a) -> a -> a
w comb x = comb x x

-- 14. Iterativ alkalmazas
ntimes :: (a -> a -> a) -> a -> Int -> a
ntimes _ x 1 = x
ntimes f x n = f x (ntimes f x (n - 1))

-- 15. Binarosik 1.
data Binary = On | Off deriving (Eq, Show)

switch :: Binary -> Binary
switch On = Off
switch _ = On

-- 16. Binarisok 2.
bxor :: [Binary] -> [Binary] -> [Binary]
bxor as bs = map mapper $ zip as bs where
    mapper (a,b)
        | a == b = On
        | otherwise = Off

-- 17. Ko-papir-ollo jatszma
data RPS = Rock | Paper | Scissors

firstBeats :: [RPS] -> [RPS] -> Int
firstBeats [] _ = 0
firstBeats _ [] = 0
firstBeats (x:xs) (y:ys)
    | isBeat x y = 1 + firstBeats xs ys
    | otherwise = firstBeats xs ys
    where
    isBeat Rock Scissors = True
    isBeat Paper Rock = True 
    isBeat Scissors Paper = True 
    isBeat _ _ = False 

-- 18. Homerseklet merese
data Temperature = Daytime Int | Night Int deriving (Eq, Show)
isDaytime :: Temperature -> Bool
isDaytime (Daytime (x)) = True
isDaytime _ = False

-- 19. Szelsoseges homerseklet
extremes :: [Temperature] -> (Int, Int)
extremes x = (maximum [n | (Daytime n) <- x], minimum [n | (Night n) <- x])

-- 20. DB data
data PersonTrait = Name | Age | Eye deriving (Eq, Show)

-- 21. DB data 2
cleanedPerson :: [PersonTrait] -> [[(PersonTrait, String)]] -> [[(PersonTrait, Maybe String)]]
cleanedPerson traits people = [[mapper $ (search y x)] | y <- people, x <- traits] where
    search traits trait = (trait, find (\(t, v) -> t == trait) traits)
    mapper (o, (Just (t, v))) = (o, Just v)
    mapper (o, Nothing) = (o, Nothing)