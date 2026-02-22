{-# OPTIONS --prop --rewriting #-}

module zh11-1 where

open import Lib
open import Fin.Syntax

fst[] : ∀{Γ A B}{t : Tm Γ (A ×o B)}{Δ}{γ : Sub Δ Γ} →
  fst t [ γ ] ≡ fst (t [ γ ])
fst[] {Γ}{A}{B}{t}{Δ}{γ} =
  fst t [ γ ]
  ≡⟨ ×β₁ ⁻¹ ⟩
  fst (fst t [ γ ] ,o snd t [ γ ])
  ≡⟨ cong fst (,[] ⁻¹) ⟩
  fst ((fst t ,o snd t) [ γ ])
  ≡⟨ cong (λ z → fst (z [ γ ])) (×η ⁻¹) ⟩
  fst (t [ γ ]) ∎

snd[] : ∀{Γ A B}{t : Tm Γ (A ×o B)}{Δ}{γ : Sub Δ Γ} →
  snd t [ γ ] ≡ snd (t [ γ ])
snd[] {Γ}{A}{B}{t}{Δ}{γ} =
  snd t [ γ ]
  ≡⟨ ×β₂ ⁻¹ ⟩
  snd (fst t [ γ ] ,o snd t [ γ ])
  ≡⟨ cong snd (,[] ⁻¹) ⟩
  snd ((fst t ,o snd t) [ γ ])
  ≡⟨ cong (λ z → snd (z [ γ ])) (×η ⁻¹) ⟩
  snd (t [ γ ]) ∎

-- 0.2 pont:
-- Definiáld az alábbi függvényt, amely (részben) bizonyítja, hogy az ×o asszociatív.
×assoc : ∀{Γ A B C} → Tm Γ ((A ×o B) ×o C ⇒ A ×o (B ×o C))
×assoc = lam (fst (fst v0)  ,o (snd (fst v0)  ,o snd v0))

-- 0.8 pont:
-- Bizonyítsd az alábbi állítást a szintaxis elhagyása nélkül!
test-assoc : ∀{Γ} → ×assoc {Γ} $ ((trivial ,o trivial) ,o trivial) ≡  (trivial ,o (trivial ,o trivial))
test-assoc =
  lam (fst (fst (var vz)) ,o (snd (fst (var vz)) ,o snd (var vz))) $ (trivial ,o trivial ,o trivial)
  ≡⟨ ⇒β ⟩
  (fst (fst (var vz)) ,o (snd (fst (var vz)) ,o snd (var vz))) [ ⟨ trivial ,o trivial ,o trivial ⟩ ]
  ≡⟨ ,[] ⟩
  fst (fst (var vz)) [ ⟨ trivial ,o trivial ,o trivial ⟩ ] ,o (snd (fst (var vz)) ,o snd (var vz)) [ ⟨ trivial ,o trivial ,o trivial ⟩ ]
  ≡⟨ cong₂ (λ x y → x ,o y) fst[] ,[] ⟩
  fst (fst (var vz) [ ⟨ trivial ,o trivial ,o trivial ⟩ ]) ,o (snd (fst (var vz)) [ ⟨ trivial ,o trivial ,o trivial ⟩ ] ,o snd (var vz) [ ⟨ trivial ,o trivial ,o trivial ⟩ ])
  ≡⟨ cong₃ (λ x y z →  fst x ,o (y ,o z)) fst[] snd[] snd[] ⟩
  fst (fst (var vz [ ⟨ trivial ,o trivial ,o trivial ⟩ ])) ,o (snd (fst (var vz) [ ⟨ trivial ,o trivial ,o trivial ⟩ ]) ,o snd (var vz [ ⟨ trivial ,o trivial ,o trivial ⟩ ]))
  ≡⟨ cong₃ (λ x y z → fst (fst x) ,o (snd y ,o snd z)) vz[⟨⟩] fst[] vz[⟨⟩] ⟩
  fst (fst (trivial ,o trivial ,o trivial)) ,o (snd (fst (var vz [ ⟨ trivial ,o trivial ,o trivial ⟩ ])) ,o snd (trivial ,o trivial ,o trivial))
  ≡⟨ cong₃ (λ x y z → fst x ,o (snd (fst y) ,o z)) ×β₁ vz[⟨⟩] ×β₂ ⟩
  fst (trivial ,o trivial) ,o (snd (fst (trivial ,o trivial ,o trivial)) ,o trivial)
  ≡⟨ cong₂ (λ x y → x ,o (snd (y) ,o trivial)) ×β₁ ×β₁ ⟩
  trivial ,o (snd (trivial ,o trivial) ,o trivial)
  ≡⟨ cong (λ x →  trivial ,o (x ,o trivial)) ×β₂ ⟩
  trivial ,o (trivial ,o trivial) ∎