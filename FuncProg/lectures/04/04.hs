queens :: Int -> [[Int]]
queens 0 = [[]]
queens n = [q:b | b <- queens (n - 1), q <- [0..7], safe q b]

safe :: Int -> [Int] -> Bool
safe q b = and [not (checks q b i) | i <- [0..((length b) - 1)]]

checks :: Int -> [Int] -> Int -> Bool
checks q b i = q == b !! i || abs (q - b !! i) == i + 1

-- (length (queens 8), queens 8)