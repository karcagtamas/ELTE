{-# OPTIONS_GHC -Wno-tabs #-}
module X1 where
import Data.Char

test :: Bool
test = f4 "DT0QPB"

f1 :: Num a => a -> a -> a -> a
f1 a b c = a * c + b

f2 :: (Foldable t, Num a) => t a -> a -> a
f2 a b = foldr (f1 b) 0 a

f3 :: (Foldable t,Functor t,Enum a) => t a -> Integer
f3 a = f2 (fmap (toInteger . fromEnum) a) 31

co :: [Integer]
co = [8041984,88504576,3814272,94112,39655888,23222608,19342816,79866226,98838477,31967616,75782562,58508862,1]

f4 :: String -> Bool
f4 a = (f2 co $ f3 $ map toUpper a) `mod` 100000000 == 0

enc :: Enum a => [a] -> Integer
enc a = f2 (map (toInteger.fromEnum) a) 31