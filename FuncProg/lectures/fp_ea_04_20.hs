import Data.List (foldl')

sum' :: Num a => [a] -> a
sum' []     = 0
sum' (x:xs) = x + sum' xs

product' :: Num a => [a] -> a
product' [] = 1
product' (x:xs) = x * product' xs 

map' :: (a -> b) -> [a] -> [b]
map' f []     = []
map' f (x:xs) = f x : map' f xs 

length' :: [a] -> Int
length' [] = 0
length' (_:xs) = 1 + length' xs


length'' :: [a] -> Int
length'' l = foldr' (\_ b -> 1 + b) 0 l 

-- a -> a -> a

-- foldr
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' f e []     = e
foldr' f e (x:xs) = x `f` foldr' f e xs

-- [1,2] ++ [3,4] ++ [5,6]
concat' :: [[a]] -> [a]
concat' l = foldr' (++) [] l
--concat' [] = []
--concat' (x:xs) = x ++ concat' xs

-- [1,2] ++ [3,4]
-- 1:2:[] ++ [3,4]
-- 1:2:[] ++ [3,4]
(+:+) :: [a] -> [a] -> [a]
(+:+) ks ls = foldr' (:) ls ks
--(+:+) []     ls = ls
--(+:+) (x:xs) ls = x : (xs +:+ ls)

lengthT :: [a] -> Int
lengthT ls = foldL (\i x -> i + 1) 0 ls
{-lengthT ls = lenT ls 0
  where
    lenT :: [a] -> Int -> Int
    lenT []     i = i
    lenT (x:xs) i = lenT xs (i+1)
-}
-- length' [1,2,3]
-- 1 + (1 + (1 + 0))

-- lengthT [1,2,3]
-- (((0 + 1) + 1) + 1)

-- foldl
foldL :: (b -> a -> b) -> b -> [a] -> b
foldL f e []     = e
foldL f e (x:xs) = foldL f (e `f` x) xs 

-- and ls = foldr (&&) True ls

and' :: [Bool] -> Bool
and' []     = True
and' (x:xs) = x && and' xs
-- False && _

and'' ls = andH ls True
  where
    andH []     b = b
    andH (x:xs) b = andH xs (b && x)
-- and'' [...] (True && False)


suM' :: Num a => [a] -> a
suM' ls = foldr (+) 0 ls

suM'' ls = foldl (+) 0 ls

suM''' ls = foldl' (+) 0 ls
