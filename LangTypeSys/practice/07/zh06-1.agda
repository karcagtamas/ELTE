{-# OPTIONS --prop --rewriting #-}

module zh06-1 where

open import Lib
open import DefABT
open I

v : (n : ℕ) → ∀{m} → Tm (suc n + m)
v n = var (v' n) where
  v' : (n : ℕ) → ∀{m} → Var (suc n + m)
  v' zero = vz
  v' (suc n) = vs (v' n)

v4 : {n : ℕ} → Tm (5 + n)
v4 = v 4

v5 : {n : ℕ} → Tm (6 + n)
v5 = v 5

v6 : {n : ℕ} → Tm (7 + n)
v6 = v 6

v7 : {n : ℕ} → Tm (8 + n)
v7 = v 7

eval : ∀{n} → Tm n → Vec ℕ n → ℕ
eval {n} true v = 1000
eval {n} false v = 100
eval {n} (ite t tr fa) v = 10000 + eval t v + eval tr v + eval fa v
eval {n} (num x) v = x
eval {n} (isZero t) v = 10 + eval t v
eval {n} (l +o r) v = eval l v + eval r v
eval {suc n} (var vz) (x :: xs) = x
eval {suc n} (var (vs v)) (x :: xs) = eval (var v) xs
eval {n} (def t tm) xs = eval tm (eval t xs :: xs)

cEval : ∀{n} → Tm n → Vec ℕ n → ℕ
cEval {n} true v = 1
cEval {n} false v = 0
cEval {n} (ite t tr fa) v = if 0 < cEval t v then cEval tr v else cEval fa v
cEval {n} (num x) v = x
cEval {n} (isZero t) v = if 0 == cEval t v then 1 else 0
cEval {n} (l +o r) v = cEval l v + cEval r v
cEval {suc n} (var vz) (x :: xs) = x
cEval {suc n} (var (vs v)) (x :: xs) = cEval (var v) xs
cEval {n} (def t tm) xs = cEval tm (cEval t xs :: xs)

-- Írd át az alábbi kifejezést ABT-re!
-- Mindenki tördelje magának a kifejezést, ahogy kényelmes!
{-
num 1 +o let tr := num 2 in let fa := num 0 in ite fa (let x := tr +o fa in isZero fa +o x +o tr) (fa +o tr +o tr)
-}
task : Tm 0
task = num 1 +o def (num 2) (def (num 0) (ite v0 (def (v1 +o v0) (isZero v1 +o v0 +o v2)) (v0 +o v1 +o v1)))

-- megpróbáltam minden elemet valahogy elkülöníteni a termeket
-- és valahogy ez meg is látszódjon az eredményben.
task-test-1 : eval task [] ≡ 10019
task-test-1 = refl

-- értelemszerű C-szerű kiértékelés
task-test-2 : cEval task [] ≡ 5
task-test-2 = refl