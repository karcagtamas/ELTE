{-# OPTIONS --prop --rewriting #-}

module gy04-1 where

---------------------------------------
-- RazorAST
---------------------------------------

open import Lib
open import RazorAST hiding (D)

{-
A szintaxisban (num 2 +o num 3) ≠ (num 3 +o num 2).
Nincs olyan modell, melyben Tm az üres halmaz.
Van olyan modell, melyben Tm-nek végtelen sok eleme van.
Van olyan modell, melyben num 2 = num 3.
Van olyan modell, melyben Tm-nek 6 eleme van.
Van olyan M modell, melyre van olyan x : M.Tm, hogy nincs t : I.Tm, melyre M.⟦ t ⟧ = x.
Van olyan modell, melyben true = false.
Van olyan modell, melyben Tm-nek egy eleme van.
-}

--nodeModelB : (M : Model {lzero}) → (Model.Tm M ≡ Lift ⊥) → ⊥
--nodeModelB M refl = un (Model.true M)

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

-- FELADAT: Bizonyítsd, hogy minden szintaxisbeli termre L1 modell ugyanazt csinálja, mint 1 + L2.
L1L2 : DepModel {lzero}
L1L2 = record
  { Tm∙ = λ t → Lift (L1'.⟦ t ⟧ ≡ suc L2'.⟦ t ⟧)
  ; true∙ = mk refl
  ; false∙ = mk refl
  ; ite∙ = λ where {t} (mk e1) {u} (mk e2) {v} (mk e3) → mk (
                    L1'.⟦ t ⟧ + L1'.⟦ u ⟧ + L1'.⟦ v ⟧
                    ≡⟨ cong₃ (λ x y z → x + y + z) e1 e2 e3 ⟩
                    suc L2'.⟦ t ⟧ + suc L2'.⟦ u ⟧ + suc L2'.⟦ v ⟧
                    ≡⟨ +suc {suc L2.⟦ t ⟧ + suc L2'.⟦ u ⟧} {L2'.⟦ v ⟧} ⟩
                    suc ((suc L2.⟦ t ⟧ + suc L2.⟦ u ⟧) + L2.⟦ v ⟧)
                    ≡⟨ cong (λ x → suc (x + L2'.⟦ v ⟧)) (+suc {suc L2'.⟦ t ⟧}) ⟩
                    suc (suc (suc L2'.⟦ t ⟧ + L2'.⟦ u ⟧ + L2'.⟦ v ⟧)) ∎)
  ; num∙ = λ _ → mk refl
  ; isZero∙ = λ x → x
  -- \== = ≡ ; \< = ⟨ ; \> = ⟩ ; \qed = ∎
  ; _+o∙_ = λ where {u} (mk e1) {v} (mk e2) → mk (
                     L1'.⟦ u ⟧ + L1'.⟦ v ⟧ 
                     ≡⟨ cong (λ x → x + L1'.⟦ v ⟧) e1  ⟩
                     suc L2'.⟦ u ⟧ + L1'.⟦ v ⟧   
                     ≡⟨ cong (λ x → suc L2'.⟦ u ⟧ + x) e2  ⟩
                     suc L2'.⟦ u ⟧ + suc L2'.⟦ v ⟧
                     ≡⟨ cong suc +suc  ⟩
                     suc (suc L2'.⟦ u ⟧ + L2'.⟦ v ⟧) ∎)
  }

module L1L2 = DepModel L1L2

twolengths : ∀ t → L1.⟦ t ⟧ ≡ 1 + L2.⟦ t ⟧
twolengths t = un L1L2.⟦ t ⟧

-- Kulonbozo dolgokhoz kulonbozo dolgot rendelunk
-- x != y -> f x != f y
module isZeroInjectivity where

  D : DepModel {lzero}
  D = record
    { Tm∙     = λ t → I.Tm
    ; true∙   = I.true
    ; false∙  = I.false
    ; ite∙    = λ x y z → x
    ; num∙    = I.num
    ; isZero∙ = λ where {t} ih → t
    ; _+o∙_   = λ x y → x
    }
  module D = DepModel D

  isZeroInj : ∀{t t'} → I.isZero t ≡ I.isZero t' → t ≡ t'
  isZeroInj e = cong D.⟦_⟧ e

module isZeroInjective where

  -- Az iniciális modellben most már tudjuk, hogy az isZero injektív. Adj meg egy másik modellt, amelyben szintén injektív!
  M : Model {lzero}
  M = record
    { Tm     = ℕ
    ; true   = {!!}
    ; false  = {!!}
    ; ite    = {!!}
    ; num    = {!!}
    ; isZero = {!!}
    ; _+o_   = {!!}
    }
  open Model M

  inj : ∀ t t' → isZero t ≡ isZero t' → t ≡ t'
  inj = {!!}

module isZeroNotInjective where

  -- Adj meg egy modellt, amelyben az isZero operátor nem injektív!
  M : Model {lzero}
  M = {!   !}
  open Model M

  notInj : ¬ (∀ t t' → isZero t ≡ isZero t' → t ≡ t')
  notInj inj = {!!}

----------------------------------------------------
-- RazorWT
----------------------------------------------------

open import RazorWT

{-

Exercise 1.33 (compulsory). Draw the derivation trees of the following terms.
isZero (num 1 + ite true (num 2) (num 3))
isZero (num 1 + (num 2 + num 3))
isZero ((num 1 + num 2) + num 3)
ite (isZero (num 0)) (num 1 + num 2) (num 3)

1.

                        OK              Ok             Ok
                    ------------   ------------   ------------
    Ok               true : Bool   num 2 : Nat    num 3 : Nat
-------------      ---------------------------------
  num 1 : Nat      ite true (num 2) (num 3) : Nat
-----------------------------------------------
     num 1 + ite true (num 2) (num 3) : Nat
-----------------------------------------------
isZero (num 1 + ite true (num 2) (num 3)) : Bool


2.


        isZero + ite true (num 2) (num 3) : Nat  => isZero az Bool nem Nat
---------------------------------------------------------
isZero (isZero + ite true (num 2) (num 3)) : Bool


3.
          Ok                    Ok           Ok
    -------------         -----------   --------------
      num 0 : Nat         num 1 : Nat     num 2 : Nat                   Ok
-------------------     -----------------------------(A - Nat)  ----------------
isZero (num 0) : Bool   (num 1 + num 2) : A                     num 3 : A - Nat
---------------------------------------------------------------------------
ite (isZero (num 0)) (num 1 + num 2) (num 3) : A


Exercise 1.35 (compulsory). Here are some lists of lexical elements (written as strings). They
are all accepted by the parser. Which ones are rejected by type inference? For the ones which are
accepted, write down the RazorWT terms which are produced.
if true then true else num 0
if true then num 0 else num 0
if num 0 then num 0 else num 0
if num 0 then num 0 else true
true + zero
true + num 1
true + isZero false
true + isZero (num 0)


Exercise 1.36 (compulsory). Here are some RazorAST terms. Which ones are rejected by type
inference? For the ones which are accepted, write down the RazorWT terms which are produced.
ite true true (num 0)
ite true (num 0) (num 0)
ite (num 0) (num 0) (num 0)
true +o zero (nem: num zero)
true +o num 1
true +o isZero (num 1)
isZero (num 1) +o num 0
-}

ex2 : RazorWT.I.Tm RazorWT.I.Nat
ex2 = RazorWT.I.ite RazorWT.I.true (RazorWT.I.num 0) (RazorWT.I.num 0)

-- experiment with type inference using infer in the code

---------------------------------------
-- Razor
---------------------------------------

-- equational consistency: I.true ≠ I.false

{-
Exercise 1.39 (compulsory). Show that if true = false in a model, then any two u, v : Tm Nat are
equal in that model. A consequence is that if a compiler compiles true and false to the same code,
then it compiles all natural numbers to the same code
-}


{-
In Razor.I, you cannot count the leaves!
-}
