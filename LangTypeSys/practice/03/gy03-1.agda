{-# OPTIONS --prop --rewriting #-}

module gy03-1 where

open import Lib hiding (n)
open import RazorAST hiding (D)

-- mutasd meg, hogy true ≠ isZero (num 0) a szintaxisban! ehhez adj
-- meg egy modellt, amiben a true tt-re, az isZero (num 0) ff-re
-- ertekelodik!
TN : Model {lzero}
TN = record
  { Tm = 𝟚
  ; true = tt
  ; false = ff
  ; ite = λ _ _ _ → ff
  ; num = λ _ → ff
  ; isZero = λ _ → ff
  ; _+o_ = λ _ _ → ff
  }
true≠isZeronum0 : ¬ (I.true ≡ I.isZero (I.num 0))
-- Felhasznaljuk a meta elmeleti tt≠ff bizonyitast a Lib-bol
-- a cong rahelyezi mind a ket oldalra a TN.⟦_⟧ fv-t, ami kiertekeli az elemeket a Modellben
true≠isZeronum0 e = tt≠ff (cong TN.⟦_⟧ e) -- ≠ \neq
  where module TN = Model TN

-- sztandard = a homomorfizmus szubjektiv

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
  n = 1
  -- Azt megadni hogy mit nem eredmenyez ez sosem -> 1 mert parosok vannak es azok vannak csak osszeadva

  -- bizonyitsd be, hogy minden szintaktikus term ertelmezese paros szam
  -- Teljes indukcio eggyel altalanosabb valtozata a strukturalis indukcio --> ezzel indukcios hipotezis les
  ps : (t : I.Tm) → Σsp ℕ λ m → NS.⟦ t ⟧ ≡ m + m
  ps I.true = 1 , refl
  ps I.false = 0 , refl
  ps (I.ite b t f) = {!  !}
  ps (I.num n) = n , refl
  ps (I.isZero t) with ps t -- indukcios hipotezis
  ... | zero , p = 1 , cong NS.isZero p
  ... | suc n , p = 0 , cong NS.isZero p
  ps (x I.+o y) with ps x | ps y
  ... | n | m = {!!}

-- FEL: add meg a legegyszerubb nemsztenderd modellt!
--
NS' : Model {lzero}
NS' = record
  { Tm = 𝟚 -- ⊥ -> ilyen nincs mert ez nulla elem es legalabb egyy kellene || Lift ⊤ ezlehetseges
  ; true = ff
  ; false = ff
  ; ite = λ _ _ _ → ff
  ; num = λ _ → ff
  ; isZero = λ _ → ff
  ; _+o_ = λ _ _ → ff
  }
module testNS' where
  module NS' = Model NS'
  b : 𝟚
  b = tt

-- Szimulaljuk a mintaillesztést
-- Megcimezzuk az elemeket I.*
  -- indukcio
  D : DepModel {lzero}
  DepModel.Tm∙ D = λ t → Lift (NS'.⟦ t ⟧ ≡ ff) -- Egyenloseg Prop-ban van, ezert oda kell rakni a Lift-et
  DepModel.true∙ D = mk refl -- mk a Lift konstruktora a Prop-bol csinal Set-et
  DepModel.false∙ D = mk refl
  DepModel.ite∙ D = λ _ _ _ → mk refl -- a parameterek az indukcios hipotezisek
  DepModel.num∙ D = λ _ → mk refl
  DepModel.isZero∙ D = λ _ → mk refl
  DepModel._+o∙_ D = λ _ _ → mk refl
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

-- Levelek szamlalasa
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

-- Csomopontok szamlalasa
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
DepModel.Tm∙ L1L2' = λ t → Lift (L1'.⟦ t ⟧ ≡ suc (L2'.⟦ t ⟧)) -- A levelek szama eggyel kisebb mint a node-k szama
DepModel.true∙ L1L2' = mk refl
DepModel.false∙ L1L2' = mk refl
DepModel.ite∙ L1L2' = {!   !}
DepModel.num∙ L1L2' = λ _ → mk refl
DepModel.isZero∙ L1L2' = λ x → x -- Pont azt adja indukcios hipoteziskent ami kell
--DepModel._+o∙_ L1L2' = λ where {u} (mk p1) {v} (mk p2) → mk ({!   !} ≡⟨ {!   !} ⟩ {!   !})
DepModel._+o∙_ L1L2' = λ {(mk p1) (mk p2) → mk ({!   !} ≡⟨ {!   !} ⟩ {!   !} ∎)} -- Minta illesztes mk-ra
-- Tobb lepeses bizonyits
-- ∎ - \qed
-- ⟨ - \<
-- ⟩ - \>
module L1L2' = DepModel L1L2'

twolengths : ∀ t → L1'.⟦ t ⟧ ≡ suc L2'.⟦ t ⟧
twolengths t = {!!}
