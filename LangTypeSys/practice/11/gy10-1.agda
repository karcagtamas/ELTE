{-# OPTIONS --prop --rewriting #-}

module gy10-1 where

open import Lib
open import STT.Syntax
open import STT

t' : Tm ◇ ((Nat ⇒ Nat) ⇒ Nat ⇒ Nat)
t' = lam v0

-- \=> = ⇒ 
add2' : Tm ◇ (Nat ⇒ Nat)
add2' = lam (v0 +o num 2) -- λx.x+2

and'' : ∀{Γ} → Tm Γ (Bool ⇒ Bool ⇒ Bool)
and'' = lam (ite v0 (lam v0) (lam false)) -- λx y.if x then y else false

and-test1 : and'' $ true $ true ≡ true {◇}
and-test1 = cong ((λ x → x $ true)) ⇒β 
  ◾ cong (λ x → x $ true) ite[] 
  ◾ cong₂ (λ x y → ite x y (lam false [ ⟨ true ⟩ ]) $ true) vz[⟨⟩] lam[] 
  ◾ cong (λ x → x $ true) iteβ₁ 
  ◾ ⇒β 
  ◾ cong (λ x → x [ ⟨ true ⟩ ]) vz[⁺] 
  ◾ vz[⟨⟩]
  
and-test2 : and'' $ false $ true ≡ false {◇}
and-test2 = 
  lam (ite v0 (lam v0) (lam false)) $ false $ true
  ≡⟨ cong (_$ true) ⇒β ⟩
  ((ite v0 (lam v0) (lam false)) [ ⟨ false ⟩ ]) $ true
  ≡⟨ cong (_$ true) ite[] ⟩
  ite (v0 [ ⟨ false ⟩ ]) (lam v0 [ ⟨ false ⟩ ]) (lam false [ ⟨ false ⟩ ]) $ true
  ≡⟨ cong (λ x → ite x (lam v0 [ ⟨ false ⟩ ]) (lam false [ ⟨ false ⟩ ]) $ true) vz[⟨⟩] ⟩
  ite false (lam v0 [ ⟨ false ⟩ ]) (lam false [ ⟨ false ⟩ ]) $ true
  ≡⟨ cong (_$ true) iteβ₂ ⟩
  (lam false [ ⟨ false ⟩ ]) $ true
  ≡⟨ cong (_$ true) lam[] ⟩
  (lam (false [ ⟨ false ⟩ ⁺ ])) $ true
  ≡⟨ ⇒β ⟩
  (false [ ⟨ false ⟩ ⁺ ]) [ ⟨ true ⟩ ]
  ≡⟨ cong _[ ⟨ true ⟩ ] false[] ⟩
  false [ ⟨ true ⟩ ]
  ≡⟨ false[] ⟩
  false ∎



-- External and
and' : Tm ◇ Bool → Tm ◇ Bool → Tm ◇ Bool
and' = λ x y → ite x y false
-- internally: lam (lam (ite v1 v0 false))

and'-test1 : and' true true ≡ true
and'-test1 = 
  ite true true false
  ≡⟨ iteβ₁ ⟩
  true ∎

and'-test2 : and' false true ≡ false
and'-test2 = iteβ₂

neg' : Tm ◇ (Bool ⇒ Bool)
neg' = lam (ite v0 false true)

neg-test1 : neg' $ true ≡ false
neg-test1 = ⇒β ◾ ite[] ◾ cong₂ (λ x y → ite x y (true [ ⟨ true ⟩ ])) vz[⟨⟩] false[] ◾ iteβ₁

neg-test2 : neg' $ false ≡ true
neg-test2 = ⇒β ◾ ite[] ◾ cong₂ (λ x y → ite x (false [ ⟨ false ⟩ ]) y) vz[⟨⟩] true[] ◾ iteβ₂

infixr 50 _⊚_
-- external definition
_⊚_ : {Γ : Con}{A B C : Ty} → Tm Γ (B ⇒ C) → Tm Γ (A ⇒ B) → Tm Γ (A ⇒ C)
f ⊚ g = lam (f [ p ] $ (g [ p ] $ v0))
-- (f ∘ g)(x) = f (g x)

-- internal definition
∘o : {Γ : Con}{A B C : Ty} → Tm Γ ((B ⇒ C) ⇒ (A ⇒ B) ⇒ (A ⇒ C))
∘o = lam (lam (lam (v2 $ (v1 $ v0))))

-- Define generic internalization and externalization!

extFun : Con → Ty → Ty → Set
extFun Γ A B = Tm Γ A → Tm Γ B

intFun : Con → Ty → Ty → Set
intFun Γ A B = Tm Γ (A ⇒ B)

internalize : {Γ : Con}{A B : Ty} → ({Δ : Con} → extFun Δ A B) → intFun Γ A B
internalize f = {!   !}

externalize : {Γ : Con}{A B : Ty} → ({Δ : Con} → intFun Δ A B) → extFun Γ A B
externalize f a = {!   !}

-- Prove the elimination rules of the internalized `isZero`!

isZeroInternal : {Γ : Con} → Tm Γ (Nat ⇒ Bool)
isZeroInternal = lam (isZero v0)

isZero'β₁ : {Γ : Con} → isZeroInternal $ num 0 ≡ true {Γ}
isZero'β₁ = ⇒β ◾ (isZero[] ◾ (cong isZero vz[⟨⟩] ◾ isZeroβ₁))

isZero'β₂ : {Γ : Con}{n : ℕ} → isZeroInternal $ num (1 + n) ≡ false {Γ}
isZero'β₂ = ⇒β ◾ (isZero[] ◾ cong isZero vz[⟨⟩] ◾ isZeroβ₂)