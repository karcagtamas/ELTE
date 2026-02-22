{-# OPTIONS --prop --rewriting #-}

module zh10-1 where

open import Lib
open import STT.Syntax
open import STT

-- Most már működik jól a C-c C-a

-- 0.2 pont
-- Definiáld a logikai implikáció függvényét:
{-
A | B | A ⊃ B
i | i |   i
i | h |   h
h | i |   i
h | h |   i
-}

impl : ∀{Γ} → Tm Γ (Bool ⇒ Bool ⇒ Bool)
impl = lam (ite v0 (lam (ite v0 true false)) (lam true))

-- 0.8 pont
-- Bizonyítsd be az alábbi állítást a szintaxis elhagyása nélkül!
test : ∀{Γ} → def (impl $ false) (v0 $ false) ≡ true {Γ}
test =
  (var vz $ false) [ ⟨ lam (ite (var vz) (lam (ite (var vz) true false)) (lam true)) $ false ⟩ ]
  ≡⟨ cong (λ x → x) $[] ⟩
  var vz [ ⟨ lam (ite (var vz) (lam (ite (var vz) true false)) (lam true)) $ false ⟩ ] $ false [ ⟨ lam (ite (var vz) (lam (ite (var vz) true false)) (lam true)) $ false ⟩ ]
  ≡⟨ cong₂ (λ x y → x $ y) vz[⟨⟩] false[] ⟩
  lam (ite (var vz) (lam (ite (var vz) true false)) (lam true)) $ false $ false
  ≡⟨ cong (λ x → x $ false) ⇒β ⟩
  ite (var vz) (lam (ite (var vz) true false)) (lam true) [ ⟨ false ⟩ ] $ false
  ≡⟨ cong (λ x → x $ false) ite[] ⟩
  ite (var vz [ ⟨ false ⟩ ]) (lam (ite (var vz) true false) [ ⟨ false ⟩ ]) (lam true [ ⟨ false ⟩ ]) $ false
  ≡⟨ cong₂ (λ x y → (ite x (lam (ite (var vz) true false) [ ⟨ false ⟩ ]) y) $ false) vz[⟨⟩] lam[] ⟩
  ite false (lam (ite (var vz) true false) [ ⟨ false ⟩ ]) (lam (true [ ⟨ false ⟩ ⁺ ])) $ false
  ≡⟨ cong (λ x → x $ false) iteβ₂ ⟩
  lam (true [ ⟨ false ⟩ ⁺ ]) $ false
  ≡⟨ cong (λ x → lam x $ false) true[] ⟩
  lam true $ false
  ≡⟨ ⇒β ⟩
  true [ ⟨ false ⟩ ]
  ≡⟨ true[] ⟩
  true ∎