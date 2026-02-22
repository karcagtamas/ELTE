import Data.List
import Data.Char

isPrime :: Int -> Bool
isPrime n = length (filter (\x -> n `mod` x == 0) [2..(n-1)]) == 0

iterate'' :: (a -> a) -> a -> [a]
iterate'' f x = x : iterate'' f (f x)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = (f x y) : zipWith' f xs ys

zipWith'' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith'' f a b = map (\(x,y) -> f x y) (zip a b)

lucasSeries :: [Integer]
--lucasSeries = 2 : 1 : zipWith (+) lucasSeries (tail lucasSeries)
lucasSeries = map fst (iterate (\(x,y) -> (y, x + y)) (2, 1))

compress :: Eq a => [a] -> [(a, Int)]
compress a = map (\x -> (head x, length x)) (group a)

decompress :: Eq a => [(a, Int)] -> [a]
decompress a = concat (map (\(x, c) -> replicate c x) a)

apsOnLists :: [(a -> b)] -> [[a]] -> [[b]]
apsOnLists fs as = map (\(f, a) -> map f a) (zip fs as)