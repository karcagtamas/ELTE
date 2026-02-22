import Data.List

isPrefixOf' :: Eq a => [a] -> [a] -> Bool
isPrefixOf' [] _ = True
isPrefixOf' _ [] = False
isPrefixOf' (x:xs) (y:ys)
    | x == y = isPrefixOf' xs ys
    | otherwise = False

--isPrefixOf' (x:xs) (y:ys) = x == y && isPrefixOf' xs ys

elem' :: Eq a => [a] -> a -> Bool
elem' [] _ = False
elem' (x:xs) y = x == y || elem' xs y

-- Vegtelen tomb
-- Vagy (OR) is lusta kiertekelest hasznal, ha talal egy igazat, akkor a tobbi nem erdekli
-- Ezert mukodik az elem' [1..] 3  => x == y

take' :: [a] -> Int -> [a]
take' _ 0 = []
take' [] _ = []
take' (x:xs) n = x : take' xs (n - 1)

{-
    Quick sort
    1. Vesszuk az elso elemet
    2. Ez alapjan vesszuk a kisebbeket es nagyobbakat (ket tomb)
    3. Rekurzivan ismetlem a fv.-t a ket sub listan
-}
qsort :: Ord a => [a] -> [a]
qsort [] = []
qsort (x:xs) = qsort [l | l <- xs, l < x] ++ (x : qsort [h | h <- xs, h > x])

tails' :: [a] -> [[a]]
tails' [] = [[]]
tails' (x:xs) = (x:xs) : tails' xs

inits' :: [a] -> [[a]]
inits' [] = [[]]
--inits' l = inits' (init l) ++ [l]
inits' (x:xs) = [] : [x:a | a <- inits' xs]

deletions :: [a] -> [[a]]
deletions [] = []
deletions (x:xs) = xs : [x:a | a <- deletions xs]

--insertions :: a -> [a] -> [[a]]

--permutations :: [a] -> [[a]]