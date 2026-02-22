{-# OPTIONS --prop --rewriting #-}

module gy02-1 where

open import Lib

-- NatBool nyelv AST szinten

open import RazorAST

-- Szintaxis: Az elemek es azok egymashoz kapcsolodasa
-- Szemantika: A szintaxis ertelmezese
  {-
          ite
        /  |  \
       /   |   \
     true  +o   isZero
          /\        |
         /  \       |
    num 1  num 3  isZero
                    |
                    |
                  false
  -}
-- Linearis notacio
tm1 : I.Tm
-- tm1 = ite true (_+o_ (num 1) (num 3)) (isZero (isZero false))
tm1 = ite true (num 1 +o num 3) (isZero (isZero false))
  where open I
  
-- more exercises from the book

t1 : I.Tm
t1 = I.num 1 I.+o (I.num 2 I.+o I.isZero (I.num 0))

t1-test : height t1 ≡ 3
t1-test = refl

t2 : I.Tm
t2 = I.ite I.true (I.num 1 I.+o I.num 3) (I.isZero (I.isZero I.false))

t2-test-1 : height t2 ≡ 3
t2-test-1 = refl

t2-test-2 : ¬ (t1 ≡ t2)
t2-test-2 ()

-- ujradefinialni height-ot modell segitsegevel
-- interpretacio - tenyleges jelentes adasa a metanyelvnek => Model
-- C-c C-r : refine
-- ℕ : \bN
-- C-c C-, : context
-- λ : \Gl
-- → : \r, \->
Height' : Model {lzero}
Height' = record
  { Tm = ℕ
  ; true = 0
  ; false = 0
  ; ite = λ x y z → max (max x y) z + 1 -- suc (max (max x y) z)
  ; num = λ _ → 0
  ; isZero = λ x → x + 1 -- suc x
  ; _+o_ = λ a b → max a b + 1 -- suc (max a b)
  }

-- Model using
module TreeHeight = Model Height'
-- C-c C-n: Normalize expression
-- ⟦ : \[[
-- ⟧ : \]]
-- TreeHeight.⟦ tm1 ⟧

-- modell: Count the number of trues in a term

Trues : Model {lzero}
-- C-c C-c without param - like pattern matching
Model.Tm Trues = ℕ
Model.true Trues = 1
Model.false Trues = 0
Model.ite Trues a b c = a + b + c
Model.num Trues _ = 0
Model.isZero Trues n = n
Model._+o_ Trues a b = a + b

module Trues = Model Trues

-- Next ZH: AST defining

module testTrues where
  module M = Model Trues

  -- kulonbseg modell-beli es szintaktikus termek kozott
  t : M.Tm
  t = M.true

  t' : M.Tm
  t' = 10

  test1 : M.⟦ I.false I.+o (I.num 1) ⟧ ≡ 0
  test1 = refl
  test2 : M.⟦ tm1 ⟧ ≡ 1
  test2 = refl
  test3 : M.⟦ I.ite I.true I.true I.true ⟧ ≡ 3
  test3 = refl


-- C stilusu interpreter

C : Model {lzero}
Model.Tm C = ℕ
Model.true C = 1
Model.false C = 0
Model.ite C zero b c = c
Model.ite C (suc a) b c = b
Model.num C x = x
Model.isZero C = λ where 
  zero → 1
  (suc _) → 0   
Model._+o_ C a b = a + b

module testC where
  module M = Model C
  open I

  test1 : M.⟦ false ⟧ ≡ 0
  test1 = refl
  test2 : M.⟦ true ⟧ ≡ 1
  test2 = refl
  test3 : M.⟦ ite (num 100) (num 3) (num 2) ⟧ ≡ 3
  test3 = refl
  test4 : M.⟦ ite (num 0) (num 3) (num 2) +o num 3 ⟧ ≡ 5
  test4 = refl

-- ird le az alabbi nyelveket data-val!

-- T ::= op0 | op1 T | op2 T T | op3 T T T | op4 T T T T

data T' : Set where
  op0 : T'
  op1 : T' → T'
  op2 : T' → T' → T'
  op3 : T' → T' → T' → T'
  op4 : T' → T' → T' → T' → T'

-- A ::= a | fb B
-- B ::= fa A

-- V ::= vzero | vsuc V
-- E ::= num N | E < E | E = E | var V
-- C ::= V := E | while E S | if E then S else S
-- S ::= empty | C colon S