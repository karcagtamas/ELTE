{-# OPTIONS --prop --rewriting #-}

module zh02-1 where

open import Lib
open import RazorAST

-- Adj meg egy olyan modellt, amely megszámolja egy AST-ben,
-- hogy hány darab (num 0) és (num 1) található benne összesen.

Num01 : Model {lzero}
Model.Tm Num01 = ℕ
Model.true Num01 = 0
Model.false Num01 = 0
Model.ite Num01 a b c = a + b + c
Model.num Num01 0 = 1
Model.num Num01 1 = 1
Model.num Num01 _ = 0
Model.isZero Num01 x = x
Model._+o_ Num01 a b = a + b

module Num01 = Model Num01

test1 : Num01.⟦ I.ite (I.num 0) (I.num 1) I.false ⟧ ≡ 2
test1 = refl

test2 : Num01.⟦ I.isZero (I.ite I.true I.false (I.num 0 I.+o I.num 0)) ⟧ ≡ 2
test2 = refl

test3 : Num01.⟦ I.isZero (I.ite (I.num 2) (I.num 0) (I.isZero (I.num 0))) I.+o (I.ite I.true (I.num 0) (I.num 1)) ⟧ ≡ 4
test3 = refl

test4 : Num01.⟦ I.isZero (I.isZero (I.num 1) I.+o (I.num 1)) ⟧ ≡ 2
test4 = refl

test5 : Num01.⟦ I.ite (I.num 1) (I.num 0) (I.num 0 I.+o I.num 1 I.+o I.num 1) ⟧ ≡ 5
test5 = refl

test6 : Num01.⟦ I.ite (I.ite I.false (I.num 0) (I.num 3)) (I.num 1) (I.isZero (I.num 1 I.+o I.num 0)) ⟧ ≡ 4
test6 = refl

test7 : Num01.⟦ I.num 2 I.+o I.num 3 ⟧ ≡ 0
test7 = refl

test8 : Num01.⟦ I.num 0 I.+o I.num 1 I.+o I.num 2 I.+o I.num 3 ⟧ ≡ 2
test8 = refl

test9 : Num01.⟦ I.ite I.true I.true I.true ⟧ ≡ 0
test9 = refl

test10 : Num01.⟦ 
  I.ite (I.ite (I.num 3) (I.isZero I.true) (I.num 5 I.+o I.false)) (I.isZero (I.num 0)) (I.num 0 I.+o I.num 0)
  ⟧ ≡ 3
test10 = refl