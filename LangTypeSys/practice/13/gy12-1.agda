{-# OPTIONS --prop --rewriting #-}

module gy12-1 where

open import Lib
open import Ind.Syntax
open import Ind.Model
open import Ind
open Standard hiding (iteList)

eval : {A : Ty} → Tm ◇ A → St.⟦ A ⟧T
eval t = St.⟦ t ⟧t (mk triv)

num : ∀{Γ} → ℕ → Tm Γ Nat
num zero = zeroo
num (suc n) = suco (num n)

-- isZero

isZero : {Γ : Con} → Tm Γ (Nat ⇒ Bool)
isZero = lam (iteNat true false v0)

isZero-test-1 : eval isZero 0 ≡ tt
isZero-test-1 = tt ∎

isZero-test-2 : eval isZero 1 ≡ ff
isZero-test-2 = ff ∎

isZero-test-3 : eval isZero 6 ≡ ff
isZero-test-3 = ff ∎

isZeroβ₁ : isZero $ num 0 ≡ true {◇}
isZeroβ₁ = ⇒β ◾ (iteNat[] ◾ (cong₃ iteNat true[] false[] vz[⟨⟩] ◾ Natβ₁))


isZeroβ₂ : ∀{n} → isZero $ num (1 + n) ≡ false {◇}
isZeroβ₂ = ⇒β ◾ (iteNat[] ◾ (cong₃ iteNat true[] false[] vz[⟨⟩] ◾ (Natβ₂ ◾ false[])))

-- plus

plus : {Γ : Con} → Tm Γ (Nat ⇒ Nat ⇒ Nat)
plus = lam (lam (iteNat v0 (suco v0) v1)) -- suc branch Γ ▹ Nat ▹ Nat ▹ Nat => 
                                         --             v1    v0    fv param

plus-test-1 : eval plus 1 1 ≡ 2
plus-test-1 = refl {A = ℕ}

plus-test-2 : eval plus 2 3 ≡ 5
plus-test-2 = refl {A = ℕ}

plus-test-3 : eval plus 0 4 ≡ 4
plus-test-3 = refl {A = ℕ}

plusβ : ∀{n m} → plus $ num n $ num m ≡ num (n + m)
plusβ = {!   !}
-- times

times : {Γ : Con} → Tm Γ (Nat ⇒ Nat ⇒ Nat)
times = lam (lam (iteNat zeroo (plus $ v1 $ v0) v1))

times-test-1 : eval times 1 5 ≡ 5
times-test-1 = refl {A = ℕ}

times-test-2 : eval times 2 3 ≡ 6
times-test-2 = refl {A = ℕ}

times-test-3 : eval times zero 4 ≡ zero
times-test-3 = refl {A = ℕ}


-- length

length : {Γ : Con}{A : Ty} → Tm Γ (Ty.List A ⇒ Nat)
length = lam (iteList zeroo (suco v0) v0)

length-test-1 : eval (length $ nil {A = Nat}) ≡ zero
length-test-1 = refl {A = ℕ}

length-test-2 : eval (length $ (cons trivial nil)) ≡ 1
length-test-2 = refl {A = ℕ}

length-test-3 : eval (length $ (cons false (cons true nil))) ≡ 2
length-test-3 = refl {A = ℕ}

length-biz : length $ (cons true (cons false nil)) ≡ num {◇} 2
length-biz =
    lam (iteList zeroo (suco (var vz)) (var vz)) $ cons true (cons false nil)
    ≡⟨ ⇒β ⟩
    iteList zeroo (suco (var vz)) (var vz) [ ⟨ cons true (cons false nil) ⟩ ]
    ≡⟨ iteList[] ⟩
    iteList (zeroo [ ⟨ cons true (cons false nil) ⟩ ]) (suco (var vz) [ (⟨ cons true (cons false nil) ⟩ ⁺) ⁺ ]) (var vz [ ⟨ cons true (cons false nil) ⟩ ])
    ≡⟨ cong₃ (λ x y z → iteList x y z) zero[] suc[] vz[⟨⟩] ⟩
    iteList zeroo (suco (var vz [ (⟨ cons true (cons false nil) ⟩ ⁺) ⁺ ])) (cons true (cons false nil))
    ≡⟨ cong (λ x → iteList zeroo (suco x) (cons true (cons false nil))) vz[⁺] ⟩
    iteList zeroo (suco (var vz)) (cons true (cons false nil))
    ≡⟨ Listβ₂ ⟩
    suco (var vz) [ ⟨ true ⟩ ⁺ ] [ ⟨ iteList zeroo (suco (var vz)) (cons false nil) ⟩ ]
    ≡⟨ cong (λ x → x [ ⟨ iteList zeroo (suco (var vz)) (cons false nil) ⟩ ]) suc[] ⟩
    suco (var vz [ ⟨ true ⟩ ⁺ ]) [ ⟨ iteList zeroo (suco (var vz)) (cons false nil) ⟩ ]
    ≡⟨ cong (λ x → suco x [ ⟨ iteList zeroo (suco (var vz)) (cons false nil) ⟩ ]) vz[⁺] ⟩
    suco (var vz) [ ⟨ iteList zeroo (suco (var vz)) (cons false nil) ⟩ ]
    ≡⟨ suc[] ⟩
    suco (var vz [ ⟨ iteList zeroo (suco (var vz)) (cons false nil) ⟩ ])
    ≡⟨ cong suco vz[⟨⟩]  ⟩
    suco (iteList zeroo (suco (var vz)) (cons false nil))
    ≡⟨ cong suco Listβ₂ ⟩
    suco (suco (var vz) [ ⟨ false ⟩ ⁺ ] [ ⟨ iteList zeroo (suco (var vz)) nil ⟩ ])
    ≡⟨ cong (λ x → suco (x [ ⟨ iteList zeroo (suco (var vz)) nil ⟩ ])) suc[] ⟩
    suco (suco (var vz [ ⟨ false ⟩ ⁺ ]) [ ⟨ iteList zeroo (suco (var vz)) nil ⟩ ])
    ≡⟨ cong (λ x → suco ( suco x [ ⟨ iteList zeroo (suco (var vz)) nil ⟩ ])) vz[⁺] ⟩
    suco (suco (var vz) [ ⟨ iteList zeroo (suco (var vz)) nil ⟩ ])
    ≡⟨ cong (λ x → suco x) suc[] ⟩
    suco (suco (var vz [ ⟨ iteList zeroo (suco (var vz)) nil ⟩ ]))
    ≡⟨ cong (λ x → suco (suco x)) vz[⟨⟩] ⟩
    suco (suco (iteList zeroo (suco (var vz)) nil))
    ≡⟨ cong (λ x → suco (suco x)) Listβ₁ ⟩
    suco (suco zeroo) ∎


-- concat

concat : {Γ : Con}{A : Ty} → Tm Γ (Ty.List A ⇒ Ty.List A ⇒ Ty.List A)
concat = lam (lam (iteList v1 (cons {!   !} {!   !}) v0))

concat-test-1 : eval (concat $ nil {A = Bool} $ nil {A = Bool}) ≡ []
concat-test-1 = refl

concat-test-2 : eval (concat $ nil $ (cons trivial nil)) ≡ mk triv ∷ []
concat-test-2 = refl

concat-test-3 : eval (concat $ (cons zeroo nil) $ (cons (suco zeroo) nil)) ≡
                zero ∷ 1 ∷ []
concat-test-3 = refl

{-
Nat≅UnitList : Nat ≅ (Ty.List Unit)
Nat≅UnitList = {!   !}
-}