{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-tabs #-}

import Data.Foldable
import Data.Functor
import Data.Monoid
import Data.Semigroup

-- Definiálj egy tetszőleges helyes Foldable függvényt az alábbi típusra, deriving használata nélkül.

-- Bármit használhatsz a megoldáshoz, más személy vagy M.I. segítségén kívül.

data Quintet a = Q a a a a a

-- Quintet Functor adott.
instance Functor Quintet where
  fmap f (Q a b c d e) = Q (f a) (f b) (f c) (f d) (f e)

-- Ezek közül definiálj legalább egyet, de ne hívj meg olyat amit nem definiálsz!

instance Foldable Quintet where
  foldMap :: (Monoid m) => (a -> m) -> Quintet a -> m
  foldMap f = fold . fmap f

  fold :: (Monoid a) => Quintet a -> a
  fold (Q a b c d e) = a <> b <> c <> d <> e

  foldr :: (a -> b -> b) -> b -> Quintet a -> b
  foldr f z (Q a b c d e) = f a (f b (f c (f d (f e z))))

  foldl :: (b -> a -> b) -> b -> Quintet a -> b
  foldl f z (Q a b c d e) = f (f (f (f (f z a) b) c) d) e
