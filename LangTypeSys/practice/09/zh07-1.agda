{-# OPTIONS --prop --rewriting #-}

module zh07-1 where

-- Ez csak setup a teszteléshez, a feladat lentebb található!

open import Lib
import RazorWT
import DefWT
module NB = RazorWT.I
module D = DefWT.I

NB→D : RazorWT.Model
NB→D = record
  { Ty     = D.Ty
  ; Tm     = D.Tm D.◇
  ; Nat    = D.Nat
  ; Bool   = D.Bool
  ; true   = D.true
  ; false  = D.false
  ; ite    = D.ite
  ; num    = D.num
  ; isZero = D.isZero
  ; _+o_   = D._+o_
  }

module NBTD = RazorWT.Model NB→D

data NBCon : Set where
  NB◇ : NBCon
  _NB▹_ : NBCon → NB.Ty → NBCon

{-# DISPLAY NB◇ = D.◇ #-}
{-# DISPLAY _NB▹_ = D._▹_ #-}

infixl 5 _,o_
data NBEnv : NBCon → Set where
  ε   : NBEnv NB◇
  _,o_ : {Γ : NBCon} {A : NB.Ty} → NBEnv Γ → NB.Tm A → NBEnv (Γ NB▹ A)

D→NB : DefWT.Model {k = lzero}
D→NB = record
  { Ty     = NB.Ty
  ; Nat    = NB.Nat
  ; Bool   = NB.Bool
  ; Con    = NBCon
  ; ◇      = NB◇
  ; _▹_    = _NB▹_
  ; Var    = λ Γ A → NBEnv Γ → NB.Tm A
  ; vz     = λ where (_ ,o a) → a
  ; vs     = λ where v (e ,o _) → v e
  ; Tm     = λ Γ A → NBEnv Γ → NB.Tm A
  ; var    = λ v → v
  ; def    = λ t f e → f (e ,o t e)
  ; true   = λ _ → NB.true
  ; false  = λ _ → NB.false
  ; ite    = λ co tr fa e → NB.ite (co e) (tr e) (fa e)
  ; num    = λ n _ → NB.num n
  ; isZero = λ t e → NB.isZero (t e)
  ; _+o_   = λ l r e → l e NB.+o r e
  }

module DTNB = DefWT.Model D→NB

norm : {A : D.Ty} → D.Tm D.◇ A → RazorWT.St.⟦ (DTNB.⟦ A ⟧T) ⟧T
norm t = RazorWT.St.⟦ DTNB.⟦ t ⟧t ε ⟧t

eval : {Γ : D.Con} {A : D.Ty} → D.Tm Γ A → NBEnv DTNB.⟦ Γ ⟧C → RazorWT.St.⟦ (DTNB.⟦ A ⟧T) ⟧T
eval t e = RazorWT.St.⟦ DTNB.⟦ t ⟧t e ⟧t

Env : D.Con → Set
Env Γ = NBEnv DTNB.⟦ Γ ⟧C

------------------------------------------------------------------
-- Itt kezdődik a feladat.

module tms where
  open D

  -- Írd át az alábbi kifejezést DefWT-re, add meg a term típusát és kontextusát is
  -- a lehető legáltalánosabban.
  {-
  x +o let y := num 3 in x +o let x := x +o y in ite z (x +o y) (y +o y)
  -}
  -- x v0 Nat
  -- z v1 Bool
  tm : ∀{Γ} → Tm (Γ ▹ Bool ▹ Nat) Nat
  tm = v0 
    +o 
    def -- y
      (num 3) 
      (v1 +o 
        def -- x
          (v1 +o v0) 
          (ite v3 (v0 +o v1) (v1 +o v1)))

module envs where
  open D using (◇ ; _▹_ ; Nat ; Bool)
  open NB

  -- Adj meg egy olyan környezetet amelyet az értelemszerű DefWT standard modellben kiértékelve
  -- a test-1-ben lévő eredményt kapjuk!
  env : Env (◇ ▹ Bool ▹ Nat)
  env = ε ,o true ,o num 4

module tests where
  open tms
  open envs
  open D using (◇ ; _▹_ ; Nat ; Bool)

  test-1 : eval (tm {◇}) env ≡ 18
  test-1 = refl