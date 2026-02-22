{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-tabs #-}

import Control.Monad

-- Bármit használhatsz a megoldáshoz, más személy vagy M.I. segítségén kívül.

-- 1. Feladat
--------------------------------------------------------------------------------

-- Adott a readInteger ami beolvas egy sort és értelmezi Integer-ként.
readInteger :: IO Integer
readInteger = read <$> getLine

-- Írj egy IO függvényt ami addig olvas be Integer értékeket tartalmazó sorokat
-- a bemenetből amíg az összegük nem haladja meg a paraméter értéket.
-- Használd a fenti readInteger függvényt az olvasásra.
-- Az eredmény legyen az összes beolvasott érték.
breakAt limit = do
  numbers <- liftM2 (:) readInteger (breakAt limit)
  if sum numbers <= limit
    then return numbers
    else return []

-- 2. Feladat
--------------------------------------------------------------------------------

-- Adott a V típus
data V a = VList [a] | VTriplet a a a | VBranch (V a) (V a) | VTag String deriving (Show)

-- Adott Functor instance
instance Functor V where
  fmap :: (a -> b) -> V a -> V b
  fmap f (VList l) = VList (fmap f l)
  fmap f (VTriplet a b c) = VTriplet (f a) (f b) (f c)
  fmap f (VBranch x y) = VBranch (fmap f x) (fmap f y)
  fmap f (VTag s) = VTag s

-- Adott Foldable instance
instance Foldable V where
  foldr :: (a -> b -> b) -> b -> V a -> b
  foldr f z (VList l) = foldr f z l
  foldr f z (VTriplet a b c) = a `f` (b `f` (c `f` z))
  foldr f z (VBranch x y) = foldr f (foldr f z y) x
  foldr f z _ = z

  foldl :: (b -> a -> b) -> b -> V a -> b
  foldl f z (VList l) = foldl f z l
  foldl f z (VTriplet a b c) = ((z `f` a) `f` b) `f` c
  foldl f z (VBranch x y) = foldl f (foldl f z x) y
  foldl f z _ = z

-- Írd meg a Traversable típusosztály sequenceA függvényét a V típusra.
-- Tilos a deriving használata!
-- Emlékeztető: Mi volt az algoritmusunk erre?
instance Traversable V where
  sequenceA :: Applicative f => V (f a) -> f (V a)
  sequenceA (VList x) = VList <$> sequenceA x
  sequenceA (VTriplet a b c) = VTriplet <$> a <*> b <*> c
  sequenceA (VBranch a b) = VBranch <$> sequenceA a <*> sequenceA b
  sequenceA (VTag s) = pure (VTag s)
