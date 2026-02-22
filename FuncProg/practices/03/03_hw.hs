import Data.List

-- Osszeg
getSum :: Int -> Int -> Int
getSum a b = sum [(min a b)..(max a b)]

-- Primek
primeList :: Int -> Int -> [Int]
primeList a b = [x | x <- [a..b], (length [p | p <- [1..x], (mod x p) == 0]) == 2]

-- Encode
encode :: String -> [(Char, Int)]
encode s = [(head c, length c) | c <- (group s)]

-- Decode
decode :: [(Char, Int)] -> String
decode a = concat ([replicate (snd p) (fst p) | p <- a])