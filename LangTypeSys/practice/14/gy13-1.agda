{-# OPTIONS --prop --rewriting #-}

module gy13-1 where

-- Kukucska Ákos
-- Pivoda Tomás

open import Lib
open import Coind.Syntax
-- Coind tipusokat a destruktorok hatarozzak meg (Induktiv "ellentetje")
-- head (elso elem), tail (a maradek)
-- ehhez nem konstruktor van hanem generator
-- megadjuk a mostani elemet (kezdo), es a kovetkezo generator elemet

num : ∀{Γ} → ℕ → Tm Γ Nat
num zero = zeroo
num (suc n) = suco (num n)

[0⇒∞] : ∀{Γ} → Tm Γ (Stream Nat)
[0⇒∞] = genStream v0 (suco v0) zeroo

test-1 : head (tail [0⇒∞]) ≡ num {◇} 1
test-1 = cong head Streamβ₂ ◾  Streamβ₁ ◾ vz[⟨⟩]  ◾ suc[] ◾ cong suco vz[⟨⟩]

repeat : ∀{Γ A} → Tm Γ (A ⇒ Stream A)
repeat = lam (genStream v0 v0 v0)

test-2 : head (tail (tail (repeat $ true))) ≡ true {◇}
test-2 =
    head (tail (tail (lam (genStream (var vz) (var vz) (var vz)) $ true)))
    ≡⟨ cong (λ x → head (tail (tail x))) ⇒β ⟩
    head (tail (tail (genStream (var vz) (var vz) (var vz) [ ⟨ true ⟩ ])))
    ≡⟨ cong (λ x → head (tail (tail x))) genStream[] ⟩
    head (tail (tail  (genStream (var vz [ ⟨ true ⟩ ⁺ ]) (var vz [ ⟨ true ⟩ ⁺ ])   (var vz [ ⟨ true ⟩ ]))))
    ≡⟨ cong₃ (λ x y z → head (tail (tail (genStream x y z)))) vz[⁺] vz[⁺] vz[⟨⟩] ⟩
    head (tail (tail (genStream (var vz) (var vz) true)))
    ≡⟨ cong (λ x → head (tail x)) Streamβ₂ ⟩
    head (tail (genStream (var vz) (var vz) (var vz [ ⟨ true ⟩ ])))
    ≡⟨ cong head Streamβ₂ ⟩
    head (genStream (var vz) (var vz) (var vz [ ⟨ var vz [ ⟨ true ⟩ ] ⟩ ]))
    ≡⟨ Streamβ₁ ⟩
    var vz [ ⟨ var vz [ ⟨ var vz [ ⟨ true ⟩ ] ⟩ ] ⟩ ]
    ≡⟨ vz[⟨⟩] ⟩
    var vz [ ⟨ var vz [ ⟨ true ⟩ ] ⟩ ]
    ≡⟨ vz[⟨⟩] ⟩
    var vz [ ⟨ true ⟩ ]
    ≡⟨ vz[⟨⟩] ⟩
    true ∎ 

addOne : Tm ◇ Machine
addOne = genMachine (suco v1) zeroo v0 zeroo

test-3 : put addOne (num 0) ≡ {!   !}
test-3 = {!   !}