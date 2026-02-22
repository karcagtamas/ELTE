module One where

--comments
one :: Int
one = 1

two :: Int
two = 2

inc :: Int -> Int
inc x = x + 1 
--infix using

inc' :: Int -> Int
inc' x = (+) x 1 
--prefix using

incTwice :: Int -> Int
incTwice x = inc (inc x)

letterE :: Char
letterE = 'E'

okay :: Bool
okay = True

{-
Multiline comment

Int: +, -, *, div, mod, negate
Bool: &&, ||, not, ==, /=
-}

isEven :: Int -> Bool
isEven x = mod x 2 == 0
--isEven x = x `mod` 2 == 0

isOdd :: Int -> Bool
isOdd x = not (isEven x)

returnFirst :: Char -> Int -> Char
returnFirst c n = c

add :: Int -> Int
add a = a + 2

area :: Int -> Int -> Int
area a b = a * b

greater :: Int -> Int -> Bool
greater a b = a > b

isDivisible :: Int -> Int -> Bool
isDivisible a b = mod a b == 0
