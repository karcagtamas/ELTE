import Data.List

-- Filters
filters :: (a -> Bool) -> [[a]] -> [a]
filters f a = filter f (concat a)

-- MapMap
mapMap :: (a -> b) -> [[a]] -> [[b]]
mapMap f = map (\x -> map f x)

-- Szokozelhagyas
dropSpaces :: String -> String
dropSpaces = dropWhile (\x -> x == ' ')

-- Egyediek
uniq :: (Eq a) => [a] -> [a]
uniq [] = []
uniq (x:xs) = x : uniq (filter (\e -> not (e == x)) xs)