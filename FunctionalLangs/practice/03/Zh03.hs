{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wno-tabs #-}

-- Definiálj Functor instance-t az alábbi típusra, deriving nélkül.

-- Bármit használhatsz a megoldáshoz, más személy vagy M.I. segítségén kívül.

data SparseList a = Nil | Skip (SparseList a) | Cons a (SparseList a)

instance Functor SparseList where
  fmap :: (a -> b) -> SparseList a -> SparseList b
  fmap _ Nil = Nil
  fmap f (Skip a) = Skip (fmap f a)
  fmap f (Cons x a) = Cons (f x) (fmap f a)
