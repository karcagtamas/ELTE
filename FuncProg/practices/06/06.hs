import Data.List

-- funkcionalis
{-
    - Programozasi nyelv
    - Fv.-eket irunk es ertekelunk ki
    - Ertek szerint kezeljuk a fv-ket
    - Fv viselkedeset irjuk le (hogyant), nem a mit
-}

-- tiszta/mellekhatasmentes
{-
    - Maga a fv-t nem befolyasolja a kornyezet es os sem hat ra
    - Ugyan arra a bementre, ugyanaz a kimenet
-}

-- statikus tipus rendszer
{-
    - Ha valamit egy tipusra allitunk, az az is marad
    - Futasi idoben nem valtozhat meg a semminek a tipusa
-}

-- Hivatkozasi helyfuggetlenseg
{-
    - Mindent ertek szerint kezel
    - Mindegy hogy a kodon belul mi-hol van definialva
-}
g :: a -> a
g x = f x

f :: a -> a
f x = x

-- Minta
{-
    - Az adat illesztheto egy elore megadott semara
    - Bizonyos ertek alakbeli megkotese, vagy konkret ertekbeli hovatkozas
    - Joker karakter, mindenre illeszkedik, de nem erdekel minket az ertek (nem bindolunk nevet)
    - Nevvel is mindenre illeszkedik, de erdekel az ertek
-}
h :: Int -> String
h 1 = "A"
h 2 = "Haskell"
h _ = "Jo"

-- parcialis/totalis
{-
    - Parcialis: ertelmezesi tartomanyan vannak olyan bementek, amire nem tud erteket vissza adni
    - Totalis: Minden bementre tud kimenetet produkalni
-}

-- Lustasag
{-
    - Lusta kiertekeles
        - A muveletek csak akkor es ott ertekelodnek ki, amikor akkor es ott szukseg van ra
        - Nincs semmien folosleges kiertekeles
    - Moho kiertekeles
        - 
-}

-- Operatorok
{-
    - Fuggvenyek, amik specialis karakterekbol allnak
    - Specialis karakterek: +, -, $
    - Infix (igy van definialva), prefix hasznalat
-}

-- Parameteres polimorfizmus
{-
    - Fv-nek olyan altalanos definicoja, ami tobb tipusra is ra tud illeszkedni
-}

tail' :: [a] -> [a]
tail' (x:xs) = xs

-- Ad-hoc polimorfizmus
{-
    - Az altalanos tipusra ad egy altalanos megkotest, egy tulajdonsag megkotese
    - Ord a => [a] -> [a]
-}

-- Generator
{-
    - Szabaly rendszer alapjan lista generalasa
-}

-- Tipus szinonima

-- Magasabb rendu fv-ek
{-
    - Olyan specialis fuggvenyek, amik mas fuggvenyeket kezelnek mint parameter
-}

inc' :: Int -> Int
inc' = (+ 1) -- (+ 1) - Int -> Int
-- inc egy Int -> Int fuggvenyt kap
-- inc' = (\ x -> x + 1) -- Lambda

{-
    Curryzes
    - Parameterek elhagyasa
    - -> hozzarendeles - jobbra zarojelez
    - Minden fv egy paramateres
    - a -> a -> a -> a == a -> (a -> (a -> a))
    - A parameterek egyesevel a fuggvenyeket hivjak meg lancoltan
    - Elrejtunk parametereket (+ 5)

    -
-}

{-
    Lambda - olyan fuggvenyek, amiknek nincsen neve
    (\ x -> x + 1)
-}

($$) :: (a -> b) -> a -> b
($$) f a = f a

(...) :: (b -> c) -> (a -> b) -> a -> c
-- (...) f g x = f (g x)
(...) f g x =  f $ g x

-- Fuggveny kompozocio

map' :: (a -> b) -> [a] -> [b]
map' _ [] = []
map' mapper (x:xs) = (mapper x) : map' mapper xs

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x:xs)
    | f x = x : filtered
    | otherwise = filtered
    where filtered = filter' f xs

count' :: (a -> Bool) -> [a] -> Int
count' _ [] = 0
count' f (x:xs)
    | f x = 1 + counted
    | otherwise = counted
    where counted = count' f xs

all' :: (a -> Bool) -> [a] -> Bool
all' _ [] = True
all' f (x:xs) = f x && all' f xs

any' :: (a -> Bool) -> [a] -> Bool
any' _ [] = False
any' f (x:xs) = f x || any' f xs

takeWhile' :: (a -> Bool) -> [a] -> [a]
takeWhile' _ [] = []
takeWhile' f (x:xs)
    | f x = x : takeWhile' f xs
    | otherwise = []

dropWhile' :: (a -> Bool) -> [a] -> [a]
dropWhile' _ [] = []
dropWhile' f (x:xs)
    | f x = dropWhile' f xs
    | otherwise = x : xs