--Module
module Homework1 where

--Kifejezesek
intExpr1 :: Int
intExpr1 = 1 + 1 --2

intExpr2 :: Int
intExpr2 = 2 * 3 --6

intExpr3 :: Int
intExpr3 = (12 `mod` 4)  * 3 --0

charExpr1 :: Char
charExpr1 = 'A'

charExpr2 :: Char
charExpr2 = '1'

charExpr3 :: Char
charExpr3 = 'Z'

boolExpr1 :: Bool
boolExpr1 = True --True

boolExpr2 :: Bool
boolExpr2 = not boolExpr1 --False

boolExpr3 :: Bool
boolExpr3 = boolExpr1 || boolExpr2 --True

--Viragultetes
canPlantAll :: Bool
canPlantAll = mod 183 13 == 0

remainingSeeds :: Int
remainingSeeds = mod 183 13

--Het
inc :: Int -> Int
inc x = x + 1

double :: Int -> Int
double x = x * 2

seven1 :: Int
seven1 = inc (inc (inc (inc (inc (inc (inc 0))))))

seven2 :: Int
seven2 = inc (inc (inc (double (double (inc 0)))))

seven3 :: Int
seven3 = inc (double(inc (inc (inc 0))))

--Osztasi maradek
cmpRem5Rem7 :: Int -> Bool
cmpRem5Rem7 x = (x `mod` 5) > (x `mod` 7)

--Tipusszignatura
foo :: Int -> Bool -> Bool
foo x y = y

bar :: Bool -> Int -> Bool
bar x y = foo y x

--Otoszto
greaterThenTwo :: Int -> Bool
greaterThenTwo x =  (x `mod` 5) > 2

--Terfogat
volume :: Integer -> Integer -> Integer -> Integer
volume a b c = a * b * c