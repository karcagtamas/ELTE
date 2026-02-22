{-# OPTIONS --prop --rewriting #-}

module zh04-1 where

open import Lib
open import RazorAST

min : ℕ → ℕ → ℕ
min zero y = 0
min (suc x) zero = 0
min (suc x) (suc y) = suc (min x y)

-- Adott a következő modell:
ZH : Model {lzero}
ZH = record
  { Tm = ℕ
  ; true = 1
  ; false = 0
  ; ite = λ x y z → max 0 y
  ; num = λ {0 → 0
           ; (suc _) → 1}
  ; isZero = λ x → x
  ; _+o_ = min
  }

module ZH = Model ZH

ZHD : DepModel {lzero}
DepModel.Tm∙ ZHD = λ t → Lift (ZH.⟦ t ⟧ ≡ 0) ⊎ Lift (ZH.⟦ t ⟧ ≡ 1)
DepModel.true∙ ZHD = ι₂ (mk refl)
DepModel.false∙ ZHD = ι₁ (mk refl)
DepModel.ite∙ ZHD {f} ih1 {u} ih2 {v} ih3 = ih2
DepModel.num∙ ZHD = λ { zero → ι₁ (mk refl) ; (suc _) → ι₂ (mk refl) }
DepModel.isZero∙ ZHD = λ n → n
DepModel._+o∙_ ZHD {a} (ι₁ (mk x)) {b} ih2 = ι₁ (mk (cong (λ a → min a ZH.⟦ b ⟧) x))
DepModel._+o∙_ ZHD {a} (ι₂ (mk x)) {b} (ι₁ (mk y)) = ι₁ (mk (cong₂ min x y))
DepModel._+o∙_ ZHD {a} (ι₂ (mk x)) {b} (ι₂ (mk y)) = ι₂ (mk (cong₂ min x y))