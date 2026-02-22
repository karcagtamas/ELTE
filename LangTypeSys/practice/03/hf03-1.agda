{-# OPTIONS --prop --rewriting #-}

module hf03-1 where

open import Lib
open import RazorAST

-- Definiálj egy olyan modellt, amely összeadja egy fában
-- tárolt számokat. A függőmodell egy kibővítése a sima modellnek.
-- Hogy kapjuk vissza DepModel-ből az eredeti Model viselkedését?

Tsum : DepModel {lzero}
DepModel.Tm∙ Tsum = λ t → ℕ
DepModel.true∙ Tsum = 0
DepModel.false∙ Tsum = 0
DepModel.ite∙ Tsum f a b = f + a + b
DepModel.num∙ Tsum n = n
DepModel.isZero∙ Tsum n = n
DepModel._+o∙_ Tsum a b = a + b

module Tsum = DepModel Tsum

Tsum-test1 : Tsum.⟦ I.isZero I.true ⟧ ≡ 0
Tsum-test1 = refl
Tsum-test2 : Tsum.⟦ I.num 3 I.+o I.true ⟧ ≡ 3
Tsum-test2 = refl
Tsum-test3 : Tsum.⟦ I.num 0 ⟧ ≡ 0
Tsum-test3 = refl
Tsum-test4 : Tsum.⟦ I.ite I.false I.true I.true ⟧ ≡ 0
Tsum-test4 = refl
Tsum-test5 : Tsum.⟦ I.ite (I.num 1) (I.num 2) (I.num 3) ⟧ ≡ 6
Tsum-test5 = refl
Tsum-test6 : Tsum.⟦ I.ite (I.ite I.false (I.num 2) (I.num 5 I.+o I.num 4)) (I.true I.+o I.false) (I.num 9) ⟧ ≡ 20
Tsum-test6 = refl
Tsum-test7 : Tsum.⟦ I.ite (I.num 5) (I.isZero (I.num 4)) I.false I.+o I.ite (I.num 1) (I.num 2) (I.isZero I.true) ⟧ ≡ 12
Tsum-test7 = refl
Tsum-test8 : Tsum.⟦ I.isZero (I.ite (I.num 10) (I.isZero (I.num 3)) (I.num 2) I.+o (I.num 11)) ⟧ ≡ 26
Tsum-test8 = refl

-- Definiálj egy modellt, amely átalakítja a fában található 2-nél kisebb számokat 2-re.

T2 : DepModel {lzero}
DepModel.Tm∙ T2 = λ t → I.Tm
DepModel.true∙ T2 = I.true
DepModel.false∙ T2 = I.false
DepModel.ite∙ T2 f a b = I.ite f a b
DepModel.num∙ T2 0 = I.num 2
DepModel.num∙ T2 1 = I.num 2
DepModel.num∙ T2 n = I.num n
DepModel.isZero∙ T2 n = I.isZero n
DepModel._+o∙_ T2 a b = I._+o_ a b

module T2 = DepModel T2

T2-test1 : T2.⟦ I.ite (I.num 4) (I.num 3) (I.num 2) ⟧ ≡ I.ite (I.num 4) (I.num 3) (I.num 2)
T2-test1 = refl

T2-test2 : T2.⟦ I.ite I.false (I.num 2 I.+o I.num 1) (I.num 0 I.+o I.true) ⟧ ≡ I.ite I.false (I.num 2 I.+o I.num 2) (I.num 2 I.+o I.true)
T2-test2 = refl

T2-test3 : T2.⟦ I.isZero (I.num 4 I.+o I.ite I.true (I.ite (I.num 0) (I.num 10 I.+o I.num 0) (I.isZero (I.num 0))) I.true) ⟧ ≡ I.isZero (I.num 4 I.+o I.ite I.true (I.ite (I.num 2) (I.num 10 I.+o I.num 2) (I.isZero (I.num 2))) I.true)
T2-test3 = refl

T2-test4 : T2.⟦ I.num 1 I.+o I.num 1 I.+o I.num 2 ⟧ ≡ I.num 2 I.+o I.num 2 I.+o I.num 2
T2-test4 = refl

-- Bizonyítsuk be I.num 3 ≢ I.num 1 I.+o I.num 2.
-- Ehhez definiáljunk egy modellt, aminek segítségével
-- ezt bizonyítani lehet.
A : Model {lzero}
Model.Tm A = 𝟚
Model.true A = tt
Model.false A = tt
Model.ite A _ _ _ = tt
Model.num A 3 = ff
Model.num A _ = tt
Model.isZero A _ = tt
Model._+o_ A _ _ = tt

module A = Model A

ff≠tt : ff ≢ tt
ff≠tt e = tt≠ff (e ⁻¹)

{-
A metaelméleti számok nem egyenlőségének bizonyításához elég
csak felírni, hogy pl.

2≠1 : 2 ≢ 1
2≠1 ()

Agda kitalálja, hogy azok tényleg nem lehetnek egyenlők
-}

-- Használd fel az A modellt!
num3≠num1+num2 : I.num 3 ≢ I.num 1 I.+o I.num 2
num3≠num1+num2 e = ff≠tt (cong (A.⟦_⟧) e)
  --module A = Model A

-- Még nem biztos, de jó eséllyel ilyesmi lesz a +/-, ami az alábbi feladat.
-- (Nem nehézségre kell érteni, hanem ilyen jellegű)
-- Adott a következő modell:
C : Model {lzero}
C = record
  { Tm = ℕ
  ; true = 1
  ; false = 0
  ; ite = λ b t f → if b == 0 then f else t
  ; num = λ x → x
  ; isZero = λ x → if x == 0 then 1 else 0
  ; _+o_ = _+_
  }
module C = Model C

-- Bizonyítsd be, hogy C-ben t = num 0 +o t-vel.
-- C-ben kell interpretálni mint t-t, mind pedig a num 0 +o t kifejezést
-- és ezen kettő egyenlőségét kell vizsgálni.
CDep : DepModel {lzero}
DepModel.Tm∙ CDep = λ t → Lift (C.⟦ t ⟧ ≡ C.⟦ I._+o_ (I.num 0) t ⟧)
DepModel.true∙ CDep = mk refl
DepModel.false∙ CDep = mk refl
DepModel.ite∙ CDep = λ f u v → mk refl
DepModel.num∙ CDep = λ n → mk refl
DepModel.isZero∙ CDep = λ t → mk refl
DepModel._+o∙_ CDep = λ t1 t2 → mk refl

-- Adott egy másik modell:
odd : ℕ → 𝟚
odd zero = ff
odd (suc zero) = tt
odd (suc (suc n)) = odd n

B : Model {lzero}
B = record
  { Tm = 𝟚 → 𝟚
  ; true = λ _ → tt
  ; false = λ _ → ff
  ; ite = λ f g h b → if f b then g b else h b
  ; num = λ n _ → odd n
  ; isZero = identity
  ; _+o_ = λ f g x → f (g x)
  }

module B = Model B

-- NEHÉZ FELADAT:
-- Bizonyítsd be, hogy B-ben bármilyen t term esetén ite t (num 1) (num 1) ≡ num 1
-- Mivel a B kiértékelése egy függvényt ad eredményül, ezért a pontosabb feladat az, hogy
-- B-ben az ite t (num 1) (num 1) = num 1-gyel tt helyen. (Tehát felíráskor még át kell adni tt-t paraméterül.)
BDep : DepModel {lzero}
DepModel.Tm∙ BDep = λ t → Lift ( B.⟦ I.ite t (I.num 1) (I.num 1) ⟧ ≡ B.⟦ I.num 1 ⟧ )
DepModel.true∙ BDep = mk refl
DepModel.false∙ BDep = mk refl
DepModel.ite∙ BDep = {!   !}
DepModel.num∙ BDep zero = mk refl
DepModel.num∙ BDep (suc n) = {!   !}
DepModel.isZero∙ BDep (mk un₁) = {! mk refl  !}
DepModel._+o∙_ BDep = {!   !}

---------------------------------------------------------------
-- NatAST modell, Bool-ok nincsenek, csak Nat.
record NatModel {ℓ} : Set (lsuc ℓ) where
  field
    Nat   : Set ℓ
    Zero  : Nat
    Suc   : Nat → Nat
  ⟦_⟧ : ℕ → Nat
  ⟦ zero ⟧ = Zero
  ⟦ suc n ⟧ = Suc ⟦ n ⟧

-- Az iniciális modell maguk a természetes számok.
I : NatModel
I = record { Nat = ℕ ; Zero = 0 ; Suc = suc }
module NatI = NatModel I

-- Indukció a természetes számok felett.
record DepNatModel {ℓ} : Set (lsuc ℓ) where
  field
    Nat∙   : NatI.Nat → Set ℓ
    Zero∙  : Nat∙ NatI.Zero
    Suc∙   : {n : NatI.Nat} → Nat∙ n → Nat∙ (NatI.Suc n)
  ⟦_⟧ : (n : NatI.Nat) → Nat∙ n
  ⟦ zero ⟧ = Zero∙
  ⟦ suc n ⟧ = Suc∙ ⟦ n ⟧

-- a *2+1 Nat modell
-- Definiáld azt a modellt, amely az "értelemszerűen" ábrázolt számot megszorozza 2-vel,
-- majd hozzáad 1-et.
*2+1 : NatModel {lzero}
*2+1 = record
  { Nat  = NatI.Nat
  ; Zero = NatI.Suc (NatI.Zero)
  ; Suc  = λ n → NatI.Suc (NatI.Suc n)
  }
module *2+1 = NatModel *2+1

-- néhány teszteset
testM : *2+1.⟦ 3 ⟧ ≡ 7
testM = refl
testM' : *2+1.⟦ 5 ⟧ ≡ 11
testM' = refl
testM'' : *2+1.⟦ 10 ⟧ ≡ 21
testM'' = refl

-- Bizonyítsd be, hogy az ebbe a modellbe való kiértékelés tényleg beszoroz 2-vel és hozzáad egyet.
*2+1D : DepNatModel {lzero}
*2+1D = record
  { Nat∙ = λ t → NatI.Nat
  ; Zero∙ = {!   !}
  ; Suc∙ = {!   !}
  }
module *2+1D = DepNatModel *2+1D
M=*2+1 : (n : ℕ) → *2+1.⟦ n ⟧ ≡ n * 2 + 1
M=*2+1 zero = refl
M=*2+1 (suc n) = {!   !}