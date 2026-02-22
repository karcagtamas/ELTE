{-# OPTIONS --prop --rewriting #-}

module zh01-1 where

open import Lib

{-
_*_ : ℕ → ℕ → ℕ
0     * _ = 0
suc n * m = m + n * m
-}

_^_ : ℕ → ℕ → ℕ
x ^ zero = 1
x ^ suc y = x ^ y * x

-- Egy apró trükk van benne, amolyan analízis tanszék módra.
-- Vegyük észre, hogy...
nulll^ : (n : ℕ) → 0 ^ (suc n) ≡ 0
nulll^ zero = refl
-- nulll^ = zero _*_
nulll^ (suc n) = cong (_* 0) (nulll^ n)

-- cong: (f: A -> B) -> 
-- (x = y) -> f x = f y