pairsWithPred :: (a -> a -> Bool) -> [a] -> [(a,a)]
pairsWithPred pred a = concat (map (\x -> filter (\(p1,p2) -> pred p1 p2) [(x, y) | y <- a]) a)

appLeftOrRight :: [a -> b] -> [a -> b] -> (a -> Bool) -> [a] -> [b]
appLeftOrRight _ _ _ [] = []
appLeftOrRight [] _ _ _ = []
appLeftOrRight _ [] _ _ = []
appLeftOrRight (lf:lfs) (rf:rfs) pred (x:xs)
    | pred x = lf x : appLeftOrRight lfs rfs pred xs
    | otherwise = rf x : appLeftOrRight lfs rfs pred xs

deletions :: [a] -> [[a]]
deletions a = concatMap (\(i, _) -> [take (i-1) a ++ drop i a]) (zip [1..] a)

secondParam :: Integral a => [a -> a -> Bool] -> (a,a) -> a -> [a]
secondParam fs (s,e) x = map (\(a,_) -> a) (filter (\(_,p) -> p) (map (\a -> (a, and (map (\f -> f x a) fs))) [s..e]))

fixPoint :: Eq a => (a -> a) -> a -> a
fixPoint f x
    | curr == x = x
    | otherwise = fixPoint f curr
    where curr = f x