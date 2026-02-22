-- 1
data Data a = Data a (Int, Int) | Empty (Int, Int) deriving (Show, Eq)
type DataBase a = [Data a]

-- 2
getData :: (Int, Int) -> DataBase a -> Data a
getData cord db = head $ filter (\d -> getPos d == cord) (db ++ [Empty cord])
    where
        getPos (Data _ p) = p
        getPos (Empty p) = p

-- 3
sumOfData :: DataBase Int -> Int
sumOfData db = sum (map (\d -> getValue d) db)
    where
        getValue (Data d _) = d
        getValue (Empty _) = 0