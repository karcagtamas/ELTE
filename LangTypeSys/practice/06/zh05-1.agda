{-# OPTIONS --prop --rewriting #-}

module zh05-1 where

open import Lib
open import Razor
open I

{-
Szabályok:
    iteβ₁     : ∀{A}{u v : Tm A} → ite true u v ≡ u
    iteβ₂     : ∀{A}{u v : Tm A} → ite false u v ≡ v
    isZeroβ₁  : isZero (num 0) ≡ true
    isZeroβ₂  : {n : ℕ} → isZero (num (1 + n)) ≡ false
    +β        : {m n : ℕ} → num m +o num n ≡ num (m + n)
-}
-- Bizonyítsuk az alábbi szintaxisbeli állítást!
eq-14 : ite (isZero (num 0)) (num 1 +o num 2 +o num 4) (num 1 +o ite (isZero (num 1)) (num 6) (num 7)) ≡ num 3 +o num 4
eq-14 = 
    ite (isZero (num zero)) (num 1 +o num 2 +o num 4) (num 1 +o ite (isZero (num 1)) (num 6) (num 7))
      ≡⟨ cong (λ x → ite x (num 1 +o num 2 +o num 4) (num 1 +o ite (isZero (num 1)) (num 6) (num 7))) isZeroβ₁ ⟩
    ite true (num 1 +o num 2 +o num 4) (num 1 +o ite (isZero (num 1)) (num 6) (num 7))
      ≡⟨ iteβ₁ ⟩
    num 1 +o num 2 +o num 4
        ≡⟨ cong (λ x → x +o num 4) +β ⟩
    num 3 +o num 4
      ∎  