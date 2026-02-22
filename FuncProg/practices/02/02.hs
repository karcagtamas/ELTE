--pattern matching

not' :: Bool -> Bool
--not' x = not x
not' True = False
not' False = True

and' :: Bool -> Bool -> Bool
and' True True = True
and' True False = False
and' False True = False
and' False False = False

betterAnd :: Bool -> Bool -> Bool
betterAnd True True = True
betterAnd _ _ = False

or' :: Bool -> Bool -> Bool
or' False False = False
or' _ _ = True

tuple1 :: (Int, Int)
tuple1 = (5,6)
--tuple1 = (,) 5 6

tuple2 :: (Int, Char)
tuple2 = (5, 'A')

tuple3 :: (Int, Char, Bool)
tuple3 = (1, 'A', True)

funTuple :: (Int -> Int, Int -> Bool)
funTuple = ((+3),even) -- can't write out => no show func for Int->Int

isEvenTuple :: Int -> (Int, Bool)
isEvenTuple x = (x, even x)

triplicate :: k -> b -> (k, b, k) --type not defined, parametric polymorph
triplicate k b = (k,b,k)

swap :: (a, b) -> (b, a)
swap (x, y) = (y, x)

doubleTheTuple :: (a, b) -> ((a, b), (a, b))
doubleTheTuple x = (x, x)

--adhoc: megkotom valamilyen szabaly alapjan, only the defined types (Num because of the polymorph)
--parametric: polymorph, it works it different types

foo :: (Int, Int) -> ((Int, Int), (Int, Int))
foo x@(1,2) = ((1, 1), (2, 2)) --alias using
foo x = (x, x)

f :: Int -> Int -> Int
f x y = x + y

g :: Int -> Int -> Int
g x y = f z z where --lokalis definicio megadasa where segitsegevel - megmondjuk mi az a z
    z = x * y

h :: Int -> Int -> Int
h x y = k x y where
    k x y = x * y


--parcialis fuggveny - lehet beadni olyan valid parametert, amit nem tud kiertekelni
--totalis fuggveny - minden bemenetet kiertekelni