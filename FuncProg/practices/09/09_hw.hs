module Homework8 where

import Data.Char
import Data.List

-- Monogramm
monogramm :: String -> String
monogramm s = map (\w -> toUpper (head w)) (words s)

pointedMonogramm :: String -> String
pointedMonogramm s = concat (map (\c -> c : '.' : []) (monogramm s))

-- Lista rendezes
minByLength :: [[a]] -> [a]
minByLength [] = []
minByLength (a:as) = foldl isShorter a as
    where isShorter x y
            | length y < length x = y
            | otherwise = x

sortByLength :: Eq a => [a] -> [a]
sortByLength l = concat (map(\(xs,_) -> xs) (sortBy sorter (map (\x -> (x, length x)) (group l))))
    where sorter a b = compare (snd a) (snd b)

-- n hosszu szavak
hasLongWord :: Int -> String -> Bool
hasLongWord n w = any (\x -> length x >= n) (words w)