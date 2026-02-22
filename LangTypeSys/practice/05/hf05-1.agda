{-# OPTIONS --prop --rewriting #-}

module hf05-1 where

open import Lib

module WT where
  open import RazorWT

  -- Definiáld azt a modellt, amely kiszámolja egy fa magasságát.
  -- Az {lsuc lzero} azért kell, hogy meg lehessen mondani, hogy
  -- a típusokat miként interpretálom a metanyelvben.
  -- Mivel Set-be szeretnénk, ezért a Ty : Set₁ kell, hogy teljesüljön, ez lesz az lsuc lzero
  height' : Model {lsuc lzero} {lzero}
  Model.Ty height' = Set
  Model.Tm height' = λ _ → ℕ
  Model.Nat height' = Lift ⊤
  Model.Bool height' = Lift ⊤
  Model.true height' = 0
  Model.false height' = 0
  Model.ite height' f u v = 1 + (max f (max u v))
  Model.num height' = λ n → 0
  Model.isZero height' = λ n → 1 + n
  Model._+o_ height' = λ a b → 1 + max a b

  module H = Model height'
  
  height-test0 : H.Tm H.Nat ≡ ℕ
  height-test0 = refl
  height-test0' : H.Tm H.Bool ≡ ℕ
  height-test0' = refl
  height-test1 : H.⟦ I.num 9 ⟧t ≡ 0
  height-test1 = refl
  height-test2 : H.⟦ I.ite I.true (I.num 9 I.+o I.num 10) (I.num 0) ⟧t ≡ 2
  height-test2 = refl
  height-test3 : H.⟦ I.ite (I.isZero (I.num 0)) (I.num 0 I.+o I.num 4 I.+o I.num 2) (I.num 3) 
                     I.+o
                     I.ite 
                        (I.isZero (I.num 1 I.+o I.num 3))
                        (I.num 0) 
                        (I.num 9 I.+o I.num 10 I.+o I.num 2 I.+o I.num 0) ⟧t ≡ 5
  height-test3 = refl
  height-test4 : H.⟦ I.num 9 I.+o I.num 2 I.+o I.num 3 ⟧t ≡ 2
  height-test4 = refl

  -- Definiálj egy modellt, amely segítségével bizonyítható, hogy
  -- a szintaxisban isZero (num 0) ≠ true és isZero (num 0) ≠ false
  not-true-false : Model {lsuc lzero} {lzero}
  Model.Ty not-true-false = Set
  Model.Tm not-true-false = λ t → 𝟚
  Model.Nat not-true-false = 𝟚
  Model.Bool not-true-false = 𝟚
  Model.true not-true-false = ff
  Model.false not-true-false = ff
  Model.ite not-true-false f u v = ff
  Model.num not-true-false n = tt
  Model.isZero not-true-false n = n
  Model._+o_ not-true-false a b = ff

  module NTF = Model not-true-false
  
  3bools : let x = I.isZero (I.num 0) in Lift (x ≢ I.true) × Lift (x ≢ I.false)
  3bools = mk (λ e → tt≠ff (cong (NTF.⟦_⟧t) e)) , mk λ e → tt≠ff (cong (NTF.⟦_⟧t) e)

module WT-equality where

  open import Razor
  open I

  eq-10 : ite false (num 1 +o num 1) (num 0) +o num 0 ≡ num 0
  eq-10 =
    (ite false (num 1 +o num 1) (num 0) +o num 0)
      ≡⟨ cong (λ x → x +o num 0) iteβ₂ ⟩
    (num zero +o num zero)
      ≡⟨ +β ⟩
    num 0
      ∎

  eq-11 : ite (isZero (num 0 +o num 1)) false (isZero (num 0)) ≡ true
  eq-11 =
    ite (isZero (num 0 +o num 1)) false (isZero (num 0))
      ≡⟨ cong (λ x → ite (isZero x) false (isZero (num 0))) +β ⟩
    ite (isZero (num 1)) false (isZero (num zero))
      ≡⟨ cong (λ x → ite x false (isZero (num zero))) isZeroβ₂ ⟩
    ite false false (isZero (num zero))
      ≡⟨ iteβ₂ ⟩
    isZero (num zero)
      ≡⟨ isZeroβ₁ ⟩
    true
      ∎

  eq-12 : num 3 +o num 2 ≡ ite true (num 5) (num 1)
  eq-12 =
    num 3 +o num 2
      ≡⟨ +β ⟩
    num 5
      ≡⟨ iteβ₁ ⁻¹ ⟩ -- symmerty - inverz iteβ₁ - get the other side of the eq
    ite true (num 5) (num 1)
      ∎  

  eq-15 : num 9 +o num 5 ≡ num 5 +o num 9
  eq-15 = +β ◾ +β ⁻¹

  eq-16 : isZero (num 3 +o num 4) ≡ isZero (num 1 +o num 6)
  eq-16 =
    isZero (num 3 +o num 4)
      ≡⟨ cong (λ x → isZero x) +β ⟩
    isZero (num 7)
      ≡⟨ cong (λ x → isZero x) (+β ⁻¹) ⟩
    isZero (num 1 +o num 6)
      ∎  

  eq-17 : ite true (num 1 +o num 2) (num 3) ≡ ite false (num 4) (num 1 +o num 2)
  eq-17 =
    ite true (num 1 +o num 2) (num 3)
      ≡⟨ iteβ₁ ⟩
    (num 1 +o num 2)
      ≡⟨ iteβ₂ ⁻¹ ⟩
    ite false (num 4) (num 1 +o num 2)
      ∎  

  -- Ezen három bizonyítás az implicit paraméterek nélkül sárgulni fognak.
  -- Ahol sárga ott azt jelenti, hogy agda nem tudta kitalálni az implicit paramétereket,
  -- tehát nekünk kell explicit átadni. Ahogy fel vannak véve a paraméterek a sirály zárójelek
  -- között, ugyanúgy kell implicit paramétereket is explicit átadni.

  -- a számok metanyelvből vannak, kell a metanyelvbeli bizonyítás hozzá
  idr+o : ∀{n} → num n +o num 0 ≡ num n
  idr+o {n} = +β ◾ cong num idr+

  -- szintén
  +o-comm : ∀{m n} → num m +o num n ≡ num n +o num m
  +o-comm {m} {n} = +β ◾ (cong num (+comm {m})) ◾ +β ⁻¹

  -- szintén
  ass+o : ∀{m n k} → num m +o num n +o num k ≡ num m +o (num n +o num k)
  ass+o {m} {n} {k} = (cong (λ x → x +o num k) +β) ◾ +β ◾ cong num (ass+ {m}) ◾ +β ⁻¹ ◾ cong (λ x → num m +o x) (+β ⁻¹)

  eq-18 : (num 5 +o num 6) +o num 7 ≡ num 5 +o (num 6 +o num 7)
  eq-18 = ass+o

  eq-19 : ite 
            (ite (isZero (num 10)) false (isZero (num 1 +o num 0)))
            (num 3 +o num 7)
            (num 5 +o (num 9 +o num 6))
          ≡
          ite
            (isZero (num 0))
            (num 14)
            (num 1 +o num 2)
          +o
          ite
            (isZero (num 1))
            (num 7)
            (num 3 +o num 3)
  eq-19 = 
    ite (ite (isZero (num 10)) false (isZero (num 1 +o num zero))) (num 3 +o num 7) (num 5 +o (num 9 +o num 6))
      ≡⟨ cong (λ x → ite (ite x false (isZero (num 1 +o num 0))) (num 3 +o num 7) (num 5 +o (num 9 +o num 6))) isZeroβ₂ ⟩
    ite (ite false false (isZero (num 1 +o num zero))) (num 3 +o num 7) (num 5 +o (num 9 +o num 6))
      ≡⟨ cong (λ x → ite x (num 3 +o num 7) (num 5 +o (num 9 +o num 6))) iteβ₂ ⟩
    ite (isZero (num 1 +o num zero)) (num 3 +o num 7) (num 5 +o (num 9 +o num 6))
      ≡⟨ cong (λ x → ite (isZero x) (num 3 +o num 7) (num 5 +o (num 9 +o num 6))) +β ⟩
    ite (isZero (num 1)) (num 3 +o num 7) (num 5 +o (num 9 +o num 6))
      ≡⟨ cong (λ x → ite x (num 3 +o num 7) (num 5 +o (num 9 +o num 6))) isZeroβ₂ ⟩
    ite false (num 3 +o num 7) (num 5 +o (num 9 +o num 6))
      ≡⟨ iteβ₂ ⟩
    (num 5 +o (num 9 +o num 6))
      ≡⟨ cong (λ x → num 5 +o x) +β ⟩
    (num 5 +o num 15)
      ≡⟨ +β ⟩
    num 20
      ≡⟨ +β ⁻¹ ⟩
    (num 14 +o num 6)
      ≡⟨ cong (λ x → num 14 +o x) +β ⁻¹ ⟩
    (num 14 +o (num 3 +o num 3))
      ≡⟨ cong (λ x → num 14 +o x) iteβ₂ ⁻¹ ⟩
    (num 14 +o ite false (num 7) (num 3 +o num 3))
      ≡⟨ cong (λ x → num 14 +o ite x (num 7) (num 3 +o num 3)) isZeroβ₂ ⁻¹ ⟩
    (num 14 +o ite (isZero (num 1)) (num 7) (num 3 +o num 3))
      ≡⟨ cong (λ x → x +o ite (isZero (num 1)) (num 7) (num 3 +o num 3)) iteβ₁ ⁻¹ ⟩
    (ite true (num 14) (num 1 +o num 2) +o ite (isZero (num 1)) (num 7) (num 3 +o num 3))
      ≡⟨ cong (λ x → ite x (num 14) (num 1 +o num 2) +o ite (isZero (num 1)) (num 7) (num 3 +o num 3)) isZeroβ₁ ⁻¹ ⟩
    (ite (isZero (num zero)) (num 14) (num 1 +o num 2) +o ite (isZero (num 1)) (num 7) (num 3 +o num 3))
      ∎  

  eq-20 : ite 
            (isZero (num 1 +o num 2))
            (ite false (isZero (num 0)) (isZero (num 0 +o num 1)))
            (ite (isZero (num 0)) true (isZero (num 1 +o num 9))) 
          ≡ 
          isZero (ite 
            (isZero (num 0 +o num 0 +o num 0))
            (ite true (num 0 +o num 0) (num 10))
            (ite (isZero (num 231)) (num 1 +o num 8) (num 1 +o num 9)))
  eq-20 =     
    ite (isZero (num 1 +o num 2)) (ite false (isZero (num zero)) (isZero (num zero +o num 1))) (ite (isZero (num zero)) true (isZero (num 1 +o num 9)))
      ≡⟨ cong (λ x → ite (isZero x) (ite false (isZero (num zero)) (isZero (num zero +o num 1))) (ite (isZero (num zero)) true (isZero (num 1 +o num 9)))) +β ⟩
    ite (isZero (num 3)) (ite false (isZero (num zero)) (isZero (num zero +o num 1))) (ite (isZero (num zero)) true (isZero (num 1 +o num 9)))
      ≡⟨ cong (λ x → ite x (ite false (isZero (num zero)) (isZero (num zero +o num 1))) (ite (isZero (num zero)) true (isZero (num 1 +o num 9)))) isZeroβ₂ ⟩
    ite false (ite false (isZero (num zero)) (isZero (num zero +o num 1))) (ite (isZero (num zero)) true (isZero (num 1 +o num 9)))
      ≡⟨ iteβ₂ ⟩
    ite (isZero (num zero)) true (isZero (num 1 +o num 9))
      ≡⟨ cong (λ x → ite x true (isZero (num 1 +o num 9))) isZeroβ₁ ⟩
    ite true true (isZero (num 1 +o num 9))
      ≡⟨ iteβ₁ ⟩
    true
      ≡⟨ isZeroβ₁ ⁻¹ ⟩
    isZero (num zero)
      ≡⟨ cong isZero (iteβ₁ ⁻¹) ⟩
    isZero (ite true (num 0) (ite (isZero (num 231)) (num 1 +o num 8) (num 1 +o num 9)))
      ≡⟨ cong₂ (λ x y → isZero (ite x y (ite (isZero (num 231)) (num 1 +o num 8) (num 1 +o num 9)))) (isZeroβ₁ ⁻¹) (iteβ₁ ⁻¹) ⟩
    isZero
      (ite (isZero (num 0))
      (ite true (num 0) (num 10))
      (ite (isZero (num 231)) (num 1 +o num 8) (num 1 +o num 9)))
      ≡⟨ cong₂ (λ x y → isZero
            (ite (isZero x)
            (ite true y (num 10))
            (ite (isZero (num 231)) (num 1 +o num 8) (num 1 +o num 9)))) (+β ⁻¹ ◾ cong (_+o num 0) (+β ⁻¹)) (+β ⁻¹) ⟩
    isZero
      (ite (isZero ((num 0 +o num 0) +o num 0))
      (ite true (num 0 +o num 0) (num 10))
      (ite (isZero (num 231)) (num 1 +o num 8) (num 1 +o num 9)))
      ∎ 