{-# OPTIONS --prop --rewriting #-}

module hf02-1 where

open import Lib
open import RazorAST

I : Model
I = record { Tm = I.Tm ; true = I.true ; false = I.false ; ite = I.ite ; num = I.num ; isZero = I.isZero ; _+o_ = I._+o_ }

-- FELADAT:
-- Számold meg egy kifejezésben a levelek és csomópontok számát.
M1 : Model {lzero}
M1 = record
  { Tm = ℕ
  ; true = 1
  ; false = 1
  ; ite = λ f a b → 1 + f + a + b
  ; num = λ _ → 1
  ; isZero = λ n → 1 + n
  ; _+o_ = λ a b → 1 + a + b
  }
module M1 = Model M1
testM1 : M1.⟦ I.true I.+o I.false ⟧ ≡ 3
testM1 = refl
testM1' : M1.⟦ I.num 100 ⟧ ≡ 1
testM1' = refl
testM1'' : M1.⟦ I.isZero (I.ite I.false I.false (I.num 1 I.+o I.num 2)) ⟧ ≡ 7
testM1'' = refl
testM1''' : M1.⟦ I.isZero (I.isZero (I.isZero (I.false))) ⟧ ≡ 4
testM1''' = refl

-- FELADAT: Bool stílusú interpreter
-- Értékelj ki egy kifejezést Bool-jellege alapján.
-- Bool esetén az értelemszerű módon
-- Nat esetén a 0 false-ként legyen értelmezve, minden más pedig true-ként.
-- Az összeadás szintén értelemszerűen menjen. Ez alapján egy logikai műveletnek megfeleltethető.
-- isZero szintén megfeleltethető egy logikai műveletnek
-- ite az if-then-else-nek megfelelően működjön. -- if_then_else_

Bool' : Model {lzero}
Model.Tm Bool' = 𝟚
Model.true Bool' = tt
Model.false Bool' = ff
Model.ite Bool' tt a _ = a -- if_then_else_
Model.ite Bool' _ _ b = b
Model.num Bool' 0 = ff
Model.num Bool' _ = tt
Model.isZero Bool' ff = tt -- not
Model.isZero Bool' _ = ff
Model._+o_ Bool' ff ff = ff -- _v_
Model._+o_ Bool' _ _ = tt

module Bool' = Model Bool'

testBool'-1 : Bool'.⟦ I.true I.+o I.false ⟧ ≡ tt
testBool'-1 = refl
testBool'-2 : Bool'.⟦ I.num 0 ⟧ ≡ ff
testBool'-2 = refl
testBool'-3 : Bool'.⟦ I.isZero (I.num 0) ⟧ ≡ tt
testBool'-3 = refl
testBool'-4 : Bool'.⟦ I.isZero (I.isZero (I.num 0)) ⟧ ≡ ff
testBool'-4 = refl
testBool'-5 : Bool'.⟦ I.ite (I.ite I.true (I.num 10) (I.false I.+o I.false)) (I.num 0) (I.num 3 I.+o I.num 5) ⟧ ≡ ff
testBool'-5 = refl
testBool'-6 : Bool'.⟦ I.isZero (I.ite (I.num 0 I.+o I.num 2) I.false (I.num 5)) ⟧ ≡ tt
testBool'-6 = refl

-- FELADAT: error modell: az M modellt használjuk, de lehet, hogy error van, akkor meghagyjuk az errort;
-- több error esetén az első errort adjuk vissza.
Error : ∀{i j} → Model {i} → Set j → Model {i ⊔ j}
Error M E = record
  { Tm = M.Tm ⊎ E -- összeg típus (Haskellben Either): egy eleme vagy egy M.Tm, vagy egy E
  ; true = ι₁ M.true
  ; false = ι₁ M.false
  ; ite = λ { (ι₁ f) (ι₁ a) (ι₁ b) → ι₁ (M.ite f a b)
            ; (ι₂ f) _ _ → ι₂ f
            ; _ (ι₂ a) _ → ι₂ a
            ; _ _ (ι₂ b) → ι₂ b }
  ; num = λ n → ι₁ (M.num n)
  ; isZero = λ { (ι₁ x) → ι₁ (M.isZero x)
               ; (ι₂ x) → ι₂ x}
  ; _+o_ = λ { (ι₁ x) (ι₁ y) → ι₁ (M._+o_ x y)
               ; (ι₂ x) _ → ι₂ x
               ; _ (ι₂ y) → ι₂ y}
  }
  where
    module M = Model M

module E = Model (Error I (Lift ⊥))

testError : E.⟦ I.true ⟧ ≡ ι₁ I.true
testError = refl
testError' : E.⟦ I.num 1 I.+o I.num 2 ⟧ ≡ ι₁ (I.num 1 I.+o I.num 2)
testError' = refl
testError'' : E.⟦ I.ite (I.false) (I.num 2) (I.isZero (I.num 1 I.+o I.false)) ⟧ ≡ ι₁ (I.ite (I.false) (I.num 2) (I.isZero (I.num 1 I.+o I.false)))
testError'' = refl

-- FELADAT: "típus" modell: ebben a modellben kiértékelve megkapjuk a term
-- típusát, amely vagy Bool vagy Nat, vagy nem típusozható (pl. isZero true)
data Ty : Set where
  Bool  : Ty
  Nat   : Ty

-- A hibát egyszerűen kell elképzelni, ne tartalmazzon semmi információt,
-- csak a hiba tényét.

M2 : Model {lzero}
Model.Tm M2 = Ty ⊎ (Lift ⊤)
Model.true M2 = ι₁ Bool
Model.false M2 = ι₁ Bool
Model.ite M2 (ι₁ Bool) (ι₁ Nat) (ι₁ Nat) = ι₁ Nat
Model.ite M2 (ι₁ Bool) (ι₁ Bool) (ι₁ Bool) = ι₁ Bool
Model.ite M2 (ι₂ e) _ _ = ι₂ e
Model.ite M2 _ (ι₂ e) _ = ι₂ e
Model.ite M2 _ _ (ι₂ e) = ι₂ e
Model.ite M2 _ _ _ = ι₂ (mk triv)
Model.num M2 n = ι₁ Nat
Model.isZero M2 (ι₁ Nat) = ι₁ Bool
Model.isZero M2 (ι₁ Bool) = ι₂ (mk triv)
Model.isZero M2 e = e
Model._+o_ M2 (ι₁ Nat) (ι₁ Nat) = ι₁ Nat
Model._+o_ M2 (ι₂ e) _ = ι₂ e
Model._+o_ M2 _ (ι₂ e) = ι₂ e
Model._+o_ M2 (ι₁ Bool) _ = ι₂ (mk triv)
Model._+o_ M2 _ (ι₁ Bool) = ι₂ (mk triv)


module M2 = Model M2
testM2-1 : M2.⟦ I.true ⟧ ≡ ι₁ Bool
testM2-1 = refl
testM2-2 : M2.⟦ I.false ⟧ ≡ ι₁ Bool
testM2-2 = refl
testM2-3 : M2.⟦ I.num 1 I.+o I.num 2 ⟧ ≡ ι₁ Nat
testM2-3 = refl
testM2-4 : M2.⟦ I.isZero (I.num 1 I.+o I.num 2) ⟧ ≡ ι₁ Bool
testM2-4 = refl
testM2-5 : M2.⟦ I.isZero (I.num 1 I.+o I.true) ⟧ ≡ ι₂ (mk triv)
testM2-5 = refl
testM2-6 : M2.⟦ I.false I.+o I.true ⟧ ≡ ι₂ (mk triv)
testM2-6 = refl
testM2-7 : M2.⟦ I.ite I.true I.true I.false ⟧ ≡ ι₁ Bool
testM2-7 = refl
testM2-8 : M2.⟦ I.ite I.true (I.num 1) (I.num 2) ⟧ ≡ ι₁ Nat
testM2-8 = refl
testM2-9 : M2.⟦ I.ite I.true (I.num 1) (I.false) ⟧ ≡ ι₂ (mk triv)
testM2-9 = refl
testM2-10 : M2.⟦ I.isZero (I.false) ⟧ ≡ ι₂ (mk triv)
testM2-10 = refl
testM2-11 : M2.⟦ I.num 42 ⟧ ≡ ι₁ Nat
testM2-11 = refl
testM2-12 : M2.⟦ I.ite (I.num 42) (I.isZero (I.num 0)) I.false ⟧ ≡ ι₂ (mk triv)
testM2-12 = refl