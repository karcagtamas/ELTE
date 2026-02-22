--Tuple heterogen adatszerkezet: tobb tipust kepes magaba foglalni
--List homogen adatszerkezet: egy fajta tipus tudunk benne eltarolni
-- HINT: ZH - Heterogen es Homogen adatszerkezet

--Lista generatorok (list kifejezesek)
-- [1..5]
-- ['a'..'z']
-- ['A'..'z']
-- [10,9..1] Visszafele, a masodik elem definialja a lepeskozt, ami -1 es lefele fog menni (alapertelmezetten 1)
-- ['z','y'..'a']
-- [a | a <- [1..5]]
-- [a * a | a <- [1..5]]
-- [a (a erteke lepesenkent a forrasbol) | a <- [1..5] (a forrasa), a /= 5 (lepesenkenti feltetel)]
-- [a * a | a <- [1..10], a /= 5]
-- [(a, b) | a <- [1..10], b <- [10,9..1]]

sumDivides :: Int -> Int
sumDivides a = sum [x | x <- [1..a], a `mod` x == 0]

isPrime :: Int -> Bool
isPrime a = length [x | x <- [1..a], a `mod` x == 0] == 2

sumSquaresTo :: Integer -> Integer
sumSquaresTo a = sum [ x*x | x <- [1..a]]

replaceNewline :: Char -> Char
replaceNewline '\n' = ' '
replaceNewline s = s

replaceNewlines :: String -> String
replaceNewlines s = [replaceNewline c | c <- s]

{-
    head - kezdo ertek,
    tail - utolso ertek,
    length - hossza,
    sum - summa,
    last - utolso elemek, 
    init - kezdeti elemek,
    minimum - minimum ertek,
    maximum - maximum ertek,
    concat - ket lista osszefuzese - concat [[1,2,3], [4,5,6]], 
    ++ - osszefuzese (merge) az elso vegere a masodik csatolasa - [1,2,3] ++ [4,5],
    zip - tuple lista keszitese ket lista elemeinek parositasavala `mod` 2 == 0 - a kisebb alapjan - zip [1,2,3] [3,2,1],
    (:) - elemfuzese a lista elejere - 3 : [1,2,3],
    take - kivesz egy elemszamot a listabol - take 10 [1..]
-}

-- [1..] - vegetelenig
-- zip [1..] [1..999]

pairity :: [(Int, Bool)]
pairity = [(a, even a) | a <- [1..]]

pythagoreanTriple :: Int -> [(Int, Int, Int)]
pythagoreanTriple n = [(a, b, c) | a <- [1..n], b <- [1..n], c <- [1..n], a * a + b * b == c * c]
