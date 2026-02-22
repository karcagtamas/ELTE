module Homework4 where

import Data.Char

-- Hosszusag
isLonger :: [a] -> [b] -> Bool
isLonger [] _ = False
isLonger (_:_) [] = True
isLonger (_:xs) (_:ys) = isLonger xs ys

-- Tomorites
zipper :: [a] -> [b] -> [(a,b)]
zipper [] _ = []
zipper _ [] = []
zipper (x:xs) (y:ys) = (x, y) : zipper xs ys

-- Osszefuzes
(+++) :: [a] -> [a] -> [a]
(+++) [] b = b
(+++) (x:xs) b = x : ((+++) xs b)

-- CamelToWords
camelToWords :: String -> String
camelToWords [] = []
camelToWords (x:xs)
    | isUpper x = ' ' : ( x : (camelToWords xs))
    | otherwise = x : (camelToWords xs)