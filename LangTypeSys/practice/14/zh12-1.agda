{-# OPTIONS --prop --rewriting #-}

module zh12-1 where

open import Lib
open import Ind.Syntax
open import Ind.Model
open import Ind
open Standard using (St; _∷_; []) renaming (List to StList ; Tree to StTree)

eval : {A : Ty} → Tm ◇ A → St.⟦ A ⟧T
eval t = St.⟦ t ⟧t (mk triv)

-- Szintaktikus cukorka num-ra:
num : ∀{Γ} → ℕ → Tm Γ Nat
num zero    = zeroo
num (suc n) = suco (num n)

and : ∀{Γ} → Tm Γ (Bool ⇒ Bool ⇒ Bool)
and = lam (lam (iteBool v0 false v1))

and-test-1 : eval (and $ false $ true) ≡ ff
and-test-1 = refl

or : ∀{Γ} → Tm Γ (Bool ⇒ Bool ⇒ Bool)
or = lam (lam (iteBool true v0 v1))

isZero : ∀{Γ} → Tm Γ (Nat ⇒ Bool)
isZero = lam (iteNat true false v0)

isNotZero : ∀{Γ} → Tm Γ (Nat ⇒ Bool)
isNotZero = lam (iteNat false true v0)

-- 0.2 pont
-- Definiáld azt a függvényt, amely ellenőrzi, hogy egy lista üres-e.

null : ∀{Γ A} → Tm Γ (List A ⇒ Bool)
null = lam (iteList true false v0)

null-test-1 : eval (null $ cons (num 0) (cons (num 0) (cons (num 0) nil))) ≡ ff
null-test-1 = refl

null-test-2 : eval (null $ (nil {A = Bool})) ≡ tt
null-test-2 = refl

null-test-3 : eval (null $ cons (nil {A = Nat}) (cons nil (cons nil nil))) ≡ ff
null-test-3 = refl

null-test-4 : eval (null $ cons false nil) ≡ ff
null-test-4 = refl

-- 0.8 pont
-- Bizonyítsd az alábbi állítást a szintaxisban maradva!
null-proof : ∀{Γ} → null $ cons (num 1) (cons (num 0) (cons (num 2) (cons (num 4) nil))) ≡ false {Γ}
null-proof =
  lam (iteList true false (var vz)) $ cons (suco zeroo) (cons zeroo (cons (suco (suco zeroo))  (cons (suco (suco (suco (suco zeroo)))) nil)))
  ≡⟨ ⇒β ⟩
  iteList true false (var vz) [ ⟨ cons (suco zeroo) (cons zeroo  (cons (suco (suco zeroo))  (cons (suco (suco (suco (suco zeroo)))) nil))) ⟩ ]
  ≡⟨ iteList[] ⟩
  iteList (true [  ⟨  cons (suco zeroo)  (cons zeroo   (cons (suco (suco zeroo))    (cons (suco (suco (suco (suco zeroo)))) nil)))  ⟩  ]) (false [  (⟨   cons (suco zeroo)   (cons zeroo    (cons (suco (suco zeroo))     (cons (suco (suco (suco (suco zeroo)))) nil)))   ⟩   ⁺)  ⁺  ]) (var vz [  ⟨  cons (suco zeroo)  (cons zeroo   (cons (suco (suco zeroo))    (cons (suco (suco (suco (suco zeroo)))) nil)))  ⟩  ])
  ≡⟨ cong₃ (λ x y z → iteList x y z) true[] false[] vz[⟨⟩] ⟩
  iteList true false (cons (suco zeroo) (cons zeroo  (cons (suco (suco zeroo))   (cons (suco (suco (suco (suco zeroo)))) nil))))
  ≡⟨ Listβ₂ ⟩
  false [ ⟨ suco zeroo ⟩ ⁺ ] [ ⟨ iteList true false (cons zeroo  (cons (suco (suco zeroo))   (cons (suco (suco (suco (suco zeroo)))) nil))) ⟩ ]
  ≡⟨ cong (λ x → x [ ⟨ iteList true false (cons zeroo  (cons (suco (suco zeroo))   (cons (suco (suco (suco (suco zeroo)))) nil))) ⟩ ]) false[] ⟩
  false [ ⟨ iteList true false (cons zeroo  (cons (suco (suco zeroo))   (cons (suco (suco (suco (suco zeroo)))) nil))) ⟩ ]
  ≡⟨ false[] ⟩
  false ∎