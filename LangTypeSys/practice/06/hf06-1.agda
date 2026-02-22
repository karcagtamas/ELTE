{-# OPTIONS --prop --rewriting #-}

module hf06-1 where

open import Lib
open import DefABT

open I

-- GYAK FÁJLBAN
-- (let x:=num 1 in x +o x)
tm-0 : Tm 0
tm-0 = def (num 1) (v0 +o v0)

-- GYAK FÁJLBAN
-- let x:=num 1 in 
--  x +o let y:=x +o num 1 in
--    y +o let z:=x +o y in
--      (x +o z) +o (y +o x)
tm-1 : Tm 0
tm-1 = def (num 1) (v0 +o def (v0 +o num 1) (v0 +o def (v1 +o v0) (v2 +o v0 +o (v1 +o v2))))

-- GYAK FÁJLBAN
-- (let x:=num 1 in 
--      x +o let y:=x +o num 1 in x) +o 
--    let z:=num 1 in z +o z
tm-3 : Tm 0
tm-3 = def (num 1) (v0 +o def (v0 +o (num 1)) v1) +o def (num 1) (v0 +o v0)

-- GYAK FÁJLBAN
-- ((let x:=num 1 in x) +o (let y:=num 1 in y)) +o let z:=num 1 in z +o z
tm-4 : Tm 0
tm-4 = def (num 1) v0 +o def (num 1) v0 +o def (num 1) (v0 +o v0)

-- GYAK FÁJLBAN
-- let x:=(isZero true) in (ite x 0 x)
tm-5 : Tm 0
tm-5 = def (isZero true) (ite v0 (num 0) v0)

-- GYAK FÁJLBAN
-- let x:= 1+2 in (x+x) + let y:=3+4 in y + y
t-1 : Tm 0
t-1 = def (num 1 +o num 2) (v0 +o v0 +o def (num 3 +o num 4) (v0 +o v0))

-- GYAK FÁJLBAN
-- let x:=1+2 in (x+x) + let y:=3+4 in x + y
t-1' : Tm 0
t-1' = def (num 1 +o num 2) (v0 +o v0 +o def (num 3 +o num 4) (v1 +o v0))

-- GYAK FÁJLBAN
-- let x:=true in x + let y:=x in y+x
t-2 : Tm 0
t-2 = def true (v0 +o def v0 (v0 +o v1))

-- GYAK FÁJLBAN
-- let x:=true in let y:=false in ite y y x
t-3 : Tm 0
t-3 = def true (def false (ite v0 v0 v1))

-- GYAK FÁJLBAN
-- true + let x:= true in false + let y:=x in x+y
t-4 : Tm 0
t-4 = true +o def true (false +o def v0 (v1 +o v0))

-- GYAK FÁJLBAN
--  let x:=true in let y:=false in let z:=true in let w:=false in (w +o z) +o (y +o x)
t-5 : Tm 0
t-5 = def true (def false (def true (def false (v0 +o v1 +o (v2 +o v3)))))