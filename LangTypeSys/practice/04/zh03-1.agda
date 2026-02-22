{-# OPTIONS --prop --rewriting #-}

module zh03-1 where

open import Lib
open import RazorAST

-- Adott a következő modell:
P : Model {lzero}
P = record
  { Tm = ℕ
  ; true = 3
  ; false = 2
  ; ite = λ x y z → x
  ; num = λ x → suc (suc x)
  ; isZero = λ x → x
  ; _+o_ = λ x y → 2 + y
  }

module P = Model P

-- Bizonyítsuk be, hogy a fenti modell minden eleme legalább 2-re értékelődik ki.
-- Tehát minden termhez LÉTEZIK egy szám, amihez ha 2-t adok, akkor a term kiértékelését kapom eredményül.
Pr : DepModel {lzero}
Pr = record
  { Tm∙ = λ t → Σsp ℕ (λ n → P.⟦ t ⟧ ≡ suc (suc n))
  ; true∙ = suc zero , refl
  ; false∙ = zero , refl
  ; ite∙ = λ f u v → f
  ; num∙ = λ n → n , refl
  ; isZero∙ = λ n → n
  ; _+o∙_ = λ {_ (n , e) → suc (suc n), cong (λ x → suc (suc x)) e}
  }