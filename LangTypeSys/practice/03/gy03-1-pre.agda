{-# OPTIONS --prop --rewriting #-}

module gy03-1 where

open import Lib
open import RazorAST

-- mutasd meg, hogy true ≠ isZero (num 0) a szintaxisban! ehhez adj
-- meg egy modellt, amiben a true tt-re, az isZero (num 0) ff-re
-- ertekelodik!
TN : Model {lzero}
TN = record
  { Tm = 𝟚
  ; true = {!!}
  ; false = {!!}
  ; ite = {!!}
  ; num = {!!}
  ; isZero = {!!}
  ; _+o_ = {!!}
  }
true≠isZeronum0 : ¬ (I.true ≡ I.isZero (I.num 0))
true≠isZeronum0 e = ?
  where module TN = Model TN

-- nemsztenderd modell (a szintaxis ertelmezese nem rakepzes)
NS : Model {lzero}
NS = record
       { Tm = ℕ
       ; true = 2
       ; false = 0
       ; ite = λ { zero a b → b ; (suc _) a b → a }
       ; num = λ n → n + n
       ; isZero = λ { zero → 2 ; (suc _) → 0 }
       ; _+o_ = _+_
       }
module testNS where
  module NS = Model NS

  -- adj meg egy ℕ-t, amire nem kepez egyik term sem
  n : ℕ
  n = {!!}

  -- bizonyitsd be, hogy minden szintaktikus term ertelmezese paros szam
  ps : (t : I.Tm) → Σsp ℕ λ m → NS.⟦ t ⟧ ≡ m + m
  ps = {!!}

-- FEL: add meg a legegyszerubb nemsztenderd modellt!
NS' : Model {lzero}
NS' = record
  { Tm = 𝟚
  ; true = {!!}
  ; false = {!!}
  ; ite = {!!}
  ; num = {!!}
  ; isZero = {!!}
  ; _+o_ = {!!}
  }
module testNS' where
  module NS' = Model NS'
  b : 𝟚
  b = tt

  -- indukcio
  D : DepModel {lzero}
  D = {!!}
  module D = DepModel D
  
  ∀ff : (t : I.Tm) → NS'.⟦ t ⟧ ≡ ff
  ∀ff t = un D.⟦ t ⟧
  
  ns : (Σsp I.Tm λ t → NS'.⟦ t ⟧ ≡ tt) → ⊥
  ns e = tt≠ff (π₂ e ⁻¹ ◾ ∀ff (π₁ e))

-- FEL: product models
Prod : ∀{i j} → Model {i} → Model {j} → Model {i ⊔ j}
Prod M N = record
  { Tm = M.Tm × N.Tm
  ; true = {!!}
  ; false = {!!}
  ; ite = {!!}
  ; num = {!!}
  ; isZero = {!!}
  ; _+o_ = {!!}
  }
  where
    module M = Model M
    module N = Model N

L1' : Model
L1' = record
  { Tm     = ℕ
  ; true   = 1
  ; false  = 1
  ; ite    = λ t t' t'' → t + t' + t''
  ; num    = λ _ → 1
  ; isZero = λ t → t
  ; _+o_   = _+_
  }
module L1' = Model L1'
L2' : Model
L2' = record
  { Tm     = ℕ
  ; true   = 0
  ; false  = 0
  ; ite    = λ t t' t'' → 2 + t + t' + t''
  ; num    = λ _ → 0
  ; isZero = λ t → t
  ; _+o_   = λ t t' → 1 + t + t'
  }
module L2' = Model L2'

L1L2' : DepModel {lzero}
L1L2' = {!!}
module L1L2' = DepModel L1L2'

twolengths : ∀ t → L1'.⟦ t ⟧ ≡ suc L2'.⟦ t ⟧
twolengths t = {!!}
