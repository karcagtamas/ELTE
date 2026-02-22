zh = (zipWith (:) [1..]) $ map (\x -> filter (not . odd) [x]) [1..6]

mapToSmaller :: Ord a => (a -> a) -> [a] -> [a]
mapToSmaller _ [] = []
mapToSmaller f (x:xs)   
    | b < x = b : mapToSmaller f xs
    | otherwise = x : mapToSmaller f xs
    where b = f x

c :: ((a, b) -> Int -> c) -> a -> Int -> b -> c
c f a n b = f (a, b) n

d :: (a -> b -> c) -> (b -> a -> c)
d f = (\x y -> f y x)

d' :: (a -> b -> c) -> b -> a -> c
d' f b a = f a b
-- Function parantheses to right
-- (a -> b -> c) -> (b -> a -> c) == (a -> b -> c) -> b -> a -> c

applyNTimes :: Int -> (a -> a) -> [a] -> [a]
--applyNTimes _ _ [] = []
--applyNTimes n f (x:xs) = last (take (n + 1) (iterate f x)) : applyNTimes n f xs
applyNTimes 0 _ l = []
applyNTimes n f l = map f (applyNTimes (n - 1) f l)

functionsComposition :: [(a -> a)] -> (a -> a)
--functionsComposition :: [(a -> a)] -> a -> a
functionsComposition [] = id -- Identity function
functionsComposition (x:xs) = (functionsComposition xs) . x
-- (.) function composition

weightedSum :: Num a => [(a, a)] -> a
weightedSum [] = 0
weightedSum ((a,b):xs) = a * b + weightedSum xs

until' :: (a -> Bool) -> (a -> a) -> a -> a
until' p f a
    | not (p a) = until' p f (f a)
    | otherwise = a

-- Hajtogatas
-- Reduce - mas nyelveken
foldr' :: (a -> b -> b) -> b -> [a] -> b
foldr' _ b [] = b
foldr' f b (x:xs) = f x (foldr' f b xs)

-- foldr' (+) 0 [1,2,3,4,5]
-- foldr' (*) 1 [1,2,3,4,5]
-- foldr' (\x y -> y + 1) 0 [1,2,3,4,5]
