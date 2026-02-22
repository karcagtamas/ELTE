{-# OPTIONS --prop --rewriting #-}

module zh04-1masik where

open import Lib
open import RazorAST

-- Adott a következő modell:
ZH4 : Model {lzero}
ZH4 = record
  { Tm = ℕ
  ; true = 2
  ; false = 3
  ; ite = λ x y z → max 0 z
  ; num = λ n → n + 1
  ; isZero = λ z → z + 1
  ; _+o_ = λ x y → y + x
  }

module ZH4 = Model ZH4

-- Bizonyítsd be az alábbi állítást!
ZH4D : DepModel {lzero}
DepModel.Tm∙ ZH4D = λ t → Σsp ℕ (λ n → ZH4.⟦ t ⟧ ≡ n + 1)
DepModel.true∙ ZH4D = suc zero , refl
DepModel.false∙ ZH4D = suc (suc zero) , refl
DepModel.ite∙ ZH4D f u v = v
DepModel.num∙ ZH4D n = n , refl
DepModel.isZero∙ ZH4D {n} (x , ih) = x + 1 , cong (λ t → t + 1) ih
DepModel._+o∙_ ZH4D {a} (n1 , ih1) {b} (n2 , ih2) =  n2 + 1 + n1 , (cong₂ _+_ ih2 ih1 ◾ ass+ {n2 + 1} ⁻¹)