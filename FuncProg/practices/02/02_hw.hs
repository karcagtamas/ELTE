-- Homework
module Homework2 where

isSmall :: Int -> Bool
isSmall x = x >= 5 && x <= 15

isPrime :: Int -> Bool
isPrime 1 = False
isPrime 2 = True
isPrime n 
    | (length [x | x <- [2 .. (n `div` 2)], mod n x == 0]) > 0 = False
    | otherwise = True

-- Primek
isSmallPrime :: Int -> Bool
isSmallPrime x = isSmall x && isPrime x

-- Logikai muveletek
equivalent :: Bool -> Bool -> Bool
equivalent x y = x == y

xor :: Bool -> Bool -> Bool
xor x y = not x == y

-- Koordianata-rendszer
invertY :: (Int, Int) -> (Int, Int)
invertY (x, y) = (x, negate y)

isOnNeg4X :: (Int, Int) -> Bool
isOnNeg4X (x, y) = y == (negate (4 * x))

yDistance :: (Int, Int) -> (Int, Int) -> Int
yDistance (_, y1) (_, y2) = abs (y2 - y1)

-- Racionalis szamok
add :: (Int, Int) -> (Int, Int) -> (Int, Int)
add (sz1, n1) (sz2, n2) = ((sz1 * n2) + (sz2 * n1) , n1 * n2)

multiply :: (Int, Int) -> (Int, Int) -> (Int, Int)
multiply (sz1, n1) (sz2, n2) = (sz1 * sz2, n1 * n2)

divide :: (Int, Int) -> (Int, Int) -> (Int, Int)
divide (sz1, n1) (sz2, n2) = (sz1 * n2, n1 * sz2)