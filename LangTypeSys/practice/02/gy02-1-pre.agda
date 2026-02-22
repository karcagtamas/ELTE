{-# OPTIONS --prop --rewriting #-}

module gy02-1 where

open import Lib

-- NatBool nyelv AST szinten

open import RazorAST

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
tm1 : I.Tm
tm1 = ?
  where open I
  
-- more exercises from the book

t1 : I.Tm
t1 = ?

t1-test : height t1 ≡ 3
t1-test = refl

t2 : I.Tm
t2 = ?

t2-test-1 : height t2 ≡ 3
t2-test-1 = refl

t2-test-2 : ¬ (t1 ≡ t2)
t2-test-2 ()

-- ird le az alabbi nyelveket data-val!

-- T ::= op0 | op1 T | op2 T T | op3 T T T | op4 T T T T

-- A ::= a | fb B
-- B ::= fa A

-- V ::= vzero | vsuc V
-- E ::= num N | E < E | E = E | var V
-- C ::= V := E | while E S | if E then S else S
-- S ::= empty | C colon S

-- ujradefinialni height-ot modell segitsegevel

Height' : Model {lzero}
Height' = ?

-- modell: Count the number of trues in a term

Trues : Model {lzero}
Trues = ?

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

C : Model {lsuc lzero}
C = ?

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
