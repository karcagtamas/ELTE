{-# OPTIONS_GHC -Wno-tabs #-}

import Control.Monad

-- Definiáld az alábbi függvényeket végtelen ciklus és kivételdobás nélkül.
-- Bármit használhatsz a megoldáshoz, más személy vagy M.I. segítségén kívül.

-- Adott a fun függvény
fun :: Integer -> Integer
fun x = (x * 2 - 5) * 3 + 1

-- Feladatok
--------------------------------------------------------------------------------

-- Írd meg a divide függvényt ami elosztja az első paramétert a másodikkal ha
-- a második paraméter nem 0, és nincs osztás maradék.
-- Emlékeztető 1: div, mod beépített függvények
-- Emlékeztető 2: guard függvény
divide :: Integer -> Integer -> Maybe Integer
divide a b
  | b == 0 = Nothing
  | a `mod` b /= 0 = Nothing
  | otherwise = Just (a `div` b)

-- Írd meg a fenti fun függvény inverzét egész számokra
-- Ha létezik inverz, adja vissza Just-ban, különben Nothing-ot adjon vissza
inv :: Integer -> Maybe Integer
inv a = do
  x <- divide (a - 1) 3
  divide (x + 5) 2

-- Tesztek
--------------------------------------------------------------------------------

-- Ha létezik inverz, megadja
testi :: Integer -> Bool
testi k = inv (fun k) == Just k

-- Ha ad értéket, az tényleg inverz
testf :: Integer -> Bool
testf k = all ((== k) . fun) (inv k)

testBoth :: Bool
testBoth = all testi [-100 .. 100] && all testf [-100 .. 100]
