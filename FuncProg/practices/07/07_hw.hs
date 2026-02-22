import Data.Char
import Data.List

-- Kodtabla
mapping :: [(Char, Char)]
mapping = zip chars (drop 3 chars ++ take 3 chars)
    where chars = ['0'..'9'] ++ ['A'..'Z'] ++ ['a'..'z']

-- Kodolas
encodeCaesar :: [Char] -> [Char]
encodeCaesar = map (\ x -> snd (head (filter (\(a,_) -> a == x) mapping)))

-- Dekodolas
decodeCaesar :: [Char] -> [Char]
decodeCaesar = map (\ x -> fst (head (filter (\(_,b) -> b == x) mapping)))
