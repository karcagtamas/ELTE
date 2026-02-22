module Homework5 where

-- Eldobas
drop' :: Int -> [a] -> [a]
drop' _ [] = []
drop' n (x:xs)
    | n <= 0 = x:xs
    | otherwise = drop' (n - 1) xs

-- Hatrafele
reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

-- Hanyszor?
howMany :: Char -> String -> Int
howMany _ [] = 0
howMany c (x:xs)
    | x == c = howMany c xs + 1
    | otherwise = howMany c xs

-- Kettevagas
splitAt' :: Int -> [a] -> ([a], [a])
splitAt' _ [] = ([], [])
splitAt' n (x:xs)
    | n <= 0 = ([], x:xs)
    | otherwise = (x : fst tmp, snd tmp)
        where tmp = splitAt' (n - 1) xs

-- Elem beszurasa
insertAt :: Int -> a -> [a] -> [a]
insertAt _ a [] = [a]
insertAt n a (x:xs) 
    | n <= 0 = a : x : xs
    | otherwise = x : insertAt (n - 1) a xs 

-- Onnantol eddig
fromTo :: Int -> Int -> [a] -> [a]
fromTo _ _ [] = []
fromTo from to (x:xs)
    | from > 0 = fromTo (from - 1) (to - 1) xs
    | to > 0 = x : fromTo from (to - 1) xs
    | otherwise = []

{-
    ([]:[]) - 1 elemu listara illeszkedik, aminek az elso eleme egy ures lista. Pelda: [[]]

    ([x,_]) - Ez egy 2 elemu listara illeszkedik. Pelda: [1,2]

    [(x,_)] - Ez egy 1 elemu listara illeszkedik, aminek az elemei Tuple-k (2 elemu). Pelda: [(1,2)]

    ((x:y):xs) - Ez egy legalabb 1 elemu listara illeszkedik, aminek az elso eleme egy legalabb 1 elemu lista. Pelda: [[1]]

    (xs:ys:zs) - Ez egy legalabb 2 elemu listara illeszkedik. Pelda: [1,2,3]

    [(,) x y,z] - Ez egy 2 elemu listara illeszkedik, aminek az elemi Tuple-k (2 elemu). Pelda: [(1,2), (1,2)]
    
    ([d]:[ds]) - Ez egy legalabb 2 elemu listara illeszkedik, aminek az elemi szinten listak es az elsonek 1 eleme van. Pelda: [[1], []]

    ((:) x y:ys) - Ez egy legalabb 1 elemu listara illeszkedik, aminek elemei listak es az elso eleme egy legalabb 1 elem hosszu lista. Pelda: [[1]]

    ((a:b):(c:d:e)) - Ez egy legalabb 3 elemu listara illeszkedik, aminek elemi listak es az elsonek legalabb 1 eleme van. Pelda: [[1], [], []]

    ((,) x y:ys : _) - Ez egy legalabb 2 elemu listara illeszkedik, aminek elemei Tuple-k (2 elemu). Pelda: [(1,1), (1,1)]
    
    [(x,xs):[y,ys]] - Ez egy 1 elemu lista, aminek 1 eleme egy 3 elemu lista, aminek elemei Tuple-k (2 elemu). Pelda: [[(1,1), (1,1), (1,1)]]

    ([_]:[(x,[xs])]:[y,ys]:[]) - Ez egy 3 elemu listara illeszkedik, aminek elemi listak, amik Tuple-k (2 elemu) tartalmaznak, amiknek a masodik eleme egy lista. Az elso gyermek listanak 1 eleme van. A masodik listanak 1 eleme van, amiben a Tuple-n beluli lista 1 elemet tartalmaz. A 3 listanak pedig 2 eleme van. Pelda: [[(1, [])], [(1, [1])], [(1,[]), (1,[])]]

    ([(x,y:_:[])]:[])
-}