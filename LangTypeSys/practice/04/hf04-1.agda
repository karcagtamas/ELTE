{-# OPTIONS --prop --rewriting #-}

module hf04-1 where

open import Lib
open import RazorAST

-- Bizonyítsd be, hogy a szintaxisban true +o num 1 ≠ num 1 +o true
M1 : Model {lzero}
Model.Tm M1 = 𝟚
Model.true M1 = tt
Model.false M1 = ff
Model.ite M1 f u v = ff
Model.num M1 n = ff
Model.isZero M1 n = ff
Model._+o_ M1 a b = a

module M1 = Model M1

-- Írd fel az állítás helyes típusát, majd a modellt
-- használva bizonyítsd az állítást.
-- Szokásos módon a tt≠ff függvényt szükséges használni.
m1 : I.true I.+o I.num 1 ≢  I.num 1 I.+o I.true
m1 e = tt≠ff (cong (M1.⟦_⟧) e)

-----------------------------------------
-- Bizonyítsd be, hogy a szintaxisban az ite mindhárom paraméterében injektív.
-- Ehhez egy olyan függőmodellt szükséges definiálni, amelyben nem
-- csak egy darab I.Tm-et adunk vissza, hanem hármat.
-- Rendezett párokat a sima × (\times = \x = ×) típussal lehet készíteni.
-- Konstruktora ugyanúgy a _,_.
-- A destruktorai π₁ és π₂, amelyek a rendre a rendezett pár első, illetve második komponensét adják vissza.
-- Az × egy jobbra kötő művelet, tehát A × B × C = A × (B × C)
-- A _,_ épp ezért szintén jobbra köt.

IteInj : DepModel {lzero}
DepModel.Tm∙ IteInj = λ t → I.Tm × I.Tm × I.Tm
DepModel.true∙ IteInj = I.true , I.true , I.true
DepModel.false∙ IteInj = I.false , I.false , I.false
DepModel.ite∙ IteInj {u} _ {f} _ {v} _ = u , f , v
DepModel.num∙ IteInj n = I.true , I.true , I.true
DepModel.isZero∙ IteInj n = I.true , I.true , I.true
DepModel._+o∙_ IteInj a b = I.true , I.true , I.true

module IteInj = DepModel IteInj

-- Írd fel az állítás helyes típusát úgy, hogy egyszerre lehessen bizonyítani
-- mindhárom szükséges egyenlőséget.
iteInj : ∀{f f' u u' v v'} → I.ite f u v ≡ I.ite f' u' v' → (f , u , v) ≡ (f' , u' , v')
iteInj e = cong IteInj.⟦_⟧ e

-----------------------------------------
-- Adott az alábbi modell:

M2 : Model {lzero}
M2 = record
  { Tm = ℕ
  ; true = 1
  ; false = 1
  ; ite = λ x y z → 1 + x + y + z
  ; num = λ _ → 1
  ; isZero = suc
  ; _+o_ = λ x y → 1 + x + y
  }

module M2 = Model M2

-- Bizonyítsuk be, hogy mindig LÉTEZIK olyan természetes szám, amelyhez
-- 1-et hozzáadva a term kiértékelését kapjuk.
-- Létezést a Σsp típussal lehet felírni, ez egy függő rendezett pár.
-- Első paramétere mindig a típus, hogy mi létezik.
-- A második paramétere pedig egy függvény, amely eredménye egy Prop-ba képző állítás kell legyen.
-- (Ebben a feladatban a Prop-ba képző állítás az egyenlőség lesz.)
M2D : DepModel {lzero}
DepModel.Tm∙ M2D = λ t → Σsp ℕ λ m → M2.⟦ t ⟧ ≡ suc m
DepModel.true∙ M2D = zero , refl
DepModel.false∙ M2D = zero , refl
DepModel.ite∙ M2D (f , e1) (u , e2) (v , e3) = suc f + suc u + suc v , cong₃ (M2.ite) e1 e2 e3
DepModel.num∙ M2D _ = zero , refl
DepModel.isZero∙ M2D (n , e) = suc n , cong M2.isZero e
DepModel._+o∙_ M2D (a , e) (b , f) = suc a + suc b , cong₂ (M2._+o_) e f
-----------------------------------------
-- Keresős feladat:

-- Ezúttal ugyanúgy a korábbi modellről bizonyítsd, hogy soha nem fog 0-t
-- eredményül adni.

-- A függvény, amelyet érdemes lesz használni, az a Lib-ben is megtalálható
-- zero≠suc vagy suc≠zero függvény attól függően, hogy hol mi jön ki, mit kell bizonyítani.

M2D' : DepModel {lzero}
DepModel.Tm∙ M2D' = λ t → Lift (M2.⟦ t ⟧ ≢ zero)
DepModel.true∙ M2D' = mk suc≠zero
DepModel.false∙ M2D' = mk suc≠zero
DepModel.ite∙ M2D' f u v = mk suc≠zero
DepModel.num∙ M2D' n = mk suc≠zero
DepModel.isZero∙ M2D' n = mk suc≠zero
DepModel._+o∙_ M2D' a b = mk suc≠zero

-----------------------------------------
-- Definiálj egy modellt, amely segítségével egy szintaktikus kifejezésből
-- minden I.isZero-t kivágunk a fából, minden mást meghagyunk.

M3 : DepModel {lzero}
DepModel.Tm∙ M3 = λ t → I.Tm
DepModel.true∙ M3 = I.true
DepModel.false∙ M3 = I.false
DepModel.ite∙ M3 f u v = I.ite f u v
DepModel.num∙ M3 n = I.num n
DepModel.isZero∙ M3 n = n
DepModel._+o∙_ M3 a b = I._+o_ a b

module M3 = DepModel M3

M3-test1 : M3.⟦ I.isZero I.false ⟧ ≡ I.false
M3-test1 = refl
M3-test2 : M3.⟦ I.true ⟧ ≡ I.true
M3-test2 = refl
M3-test3 : M3.⟦ I.ite (I.isZero I.true) (I.num 0 I.+o I.num 1) (I.num 1 I.+o I.isZero (I.num 1)) ⟧
         ≡ I.ite I.true (I.num 0 I.+o I.num 1) (I.num 1 I.+o I.num 1)
M3-test3 = refl
M3-test4 : M3.⟦ I.ite (I.num 10 I.+o I.num 2) (I.ite (I.num 3) I.true I.false) (I.false I.+o I.num 5) ⟧
         ≡ I.ite (I.num 10 I.+o I.num 2) (I.ite (I.num 3) I.true I.false) (I.false I.+o I.num 5)
M3-test4 = refl
M3-test5 : M3.⟦ I.isZero (I.isZero (I.num 2)) ⟧ ≡ I.num 2
M3-test5 = refl
M3-test6 : M3.⟦ I.ite (I.isZero (I.num 0)) (I.num 1) (I.num 2) I.+o (I.isZero (I.isZero (I.num 3) I.+o I.isZero (I.num 6))) ⟧ ≡ I.ite (I.num 0) (I.num 1) (I.num 2) I.+o (I.num 3 I.+o I.num 6)
M3-test6 = refl

-----------------------------------------
-- Adott az alábbi modell:

M4 : Model {lzero}
M4 = record
  { Tm = ℕ
  ; true = 2
  ; false = 0
  ; ite = λ x y z → z
  ; num = λ n → n + n
  ; isZero = λ x → x
  ; _+o_ = λ x y → 2 + x + y
  }

module M4 = Model M4

-- Bizonyítsd be, hogy minden termhez létezik egy KONKRÉT szám, amelyet a modell nem képes visszaadni.
-- (Tehát nem kell Σsp-t használni, hanem csak ≢ valami szám.)
-- A metaelméletben tudjuk, hogy suc injektív, ezt a sucinj függvény bizonyítja.

M4D : DepModel {lzero}
DepModel.Tm∙ M4D = λ t → Σsp ℕ λ n → M4.⟦ t ⟧ ≢ n
DepModel.true∙ M4D = zero , suc≠zero
DepModel.false∙ M4D = suc zero , zero≠suc
DepModel.ite∙ M4D f u v = v
DepModel.num∙ M4D zero = suc zero , zero≠suc
DepModel.num∙ M4D (suc zero) = suc zero , λ e → suc≠zero (sucinj e)
DepModel.num∙ M4D (suc (suc (n))) = suc zero , λ e → suc≠zero (sucinj e)
DepModel.isZero∙ M4D n = n
DepModel._+o∙_ M4D a b = zero , suc≠zero

-----------------------------------------
-- Adott az alábbi modell:

M5 : Model {lzero}
M5 = record
  { Tm = ℕ
  ; true = 1
  ; false = 0
  ; ite = λ x y z → suc z
  ; num = λ n → n + n
  ; isZero = 4 +_
  ; _+o_ = λ x y → 2 + x + y
  }

module M5 = Model M5

-- Bizonyítsd be, hogy minden termhez létezik egy szám, amelyet a modell nem képes visszaadni.
-- A számnak nem feltétlenül kell minden esetben azonosnak lenniük.
-- Ehhez érdemes Σsp-t használni.

M5D : DepModel {lzero}
DepModel.Tm∙ M5D = λ t → Σsp ℕ λ n → M4.⟦ t ⟧ ≢ n
DepModel.true∙ M5D = zero , suc≠zero
DepModel.false∙ M5D = suc zero , zero≠suc
DepModel.ite∙ M5D f u v = v
DepModel.num∙ M5D zero = suc zero , zero≠suc
DepModel.num∙ M5D (suc zero) = suc zero , λ e → suc≠zero (sucinj e)
DepModel.num∙ M5D (suc (suc n)) = suc zero , λ e → suc≠zero (sucinj e)
DepModel.isZero∙ M5D n = n
DepModel._+o∙_ M5D a b = zero , suc≠zero

-----------------------------------------
-- Adott az alábbi modell:

M6 : DepModel {lzero}
M6 = record
  { Tm∙ = λ _ → ℕ
  ; true∙ = 10
  ; false∙ = 5
  ; ite∙ = λ _ _ _ → 0
  ; num∙ = λ n → 5 * n
  ; isZero∙ = λ x → 5 + x
  ; _+o∙_ = λ x y → x
  }

module M6 = DepModel M6

-- Bizonyítsd be, hogy minden term kiértékelése M6-ban 5-tel osztható számot eredményez.

M6D : DepModel {lzero}
DepModel.Tm∙ M6D = λ t → Lift ( mod-helper 0 4 M6.⟦ t ⟧ 4 ≡ 0 )
DepModel.true∙ M6D = mk refl
DepModel.false∙ M6D = mk refl
DepModel.ite∙ M6D _ _ _ = mk refl
DepModel.num∙ M6D zero = mk refl
DepModel.num∙ M6D (suc n) = mk {!  suc≠zero  !}
DepModel.isZero∙ M6D n = n
DepModel._+o∙_ M6D a _ = a

M6D' : DepModel {lzero}
DepModel.Tm∙ M6D' = λ t → Σsp ℕ (λ n → M6.⟦ t ⟧ ≡ 5 * n)
DepModel.true∙ M6D' = 2 , refl
DepModel.false∙ M6D' = 1 , refl
DepModel.ite∙ M6D' f u v = zero , refl
DepModel.num∙ M6D' n = n , refl
DepModel.isZero∙ M6D' {n} (zero , ih) = 1 , {!   !}
DepModel.isZero∙ M6D' {n} (suc x , π₄) = {!   !}
DepModel._+o∙_ M6D' a b = a

-----------------------------------------
-- Adott az alábbi két modell:

M7₁ : Model {lzero}
M7₁ = record
  { Tm = 𝟚
  ; true = tt
  ; false = ff
  ; ite = if_then_else_
  ; num = λ {zero → ff
           ; (suc n) → tt}
  ; isZero = λ x → not (not (not x))
  ; _+o_ = λ x y → not x ∧ not y
  }

module M7₁ = Model M7₁

M7₂ : Model {lzero}
M7₂ = record
  { Tm = 𝟚
  ; true = tt
  ; false = ff
  ; ite = if_then_else_
  ; num = λ {zero → ff
           ; (suc n) → tt}
  ; isZero = not
  ; _+o_ = λ x y → not (x ∨ y)
  }

module M7₂ = Model M7₂

-- Bizonyítsd be, hogy a két modell valójában ugyanazt csinálja.
-- Az isZero és +o bizonyításokban érdemes segédfüggvényt definiálni
-- egy megfelelő term mintaillesztésének érdekében.
-- (Vagy lehet a nem rekordos módszert használni és akkor van with.)
M7D : DepModel {lzero}
DepModel.Tm∙ M7D = λ t → Lift (M7₁.⟦ t ⟧ ≡ M7₂.⟦ t ⟧)
DepModel.true∙ M7D = mk refl
DepModel.false∙ M7D = mk refl
DepModel.ite∙ M7D {f} ih1 {u} ih2 {v} ih3 with M7₁.⟦ f ⟧ | M7₂.⟦ f ⟧
... | tt | tt = ih2
... | ff | ff = ih3
DepModel.num∙ M7D zero = mk refl
DepModel.num∙ M7D (suc n) = mk refl
DepModel.isZero∙ M7D {n} ih = {!  !}
DepModel._+o∙_ M7D {a} ih1 {b} ih2 = mk {!   !}

M7D' : DepModel {lzero}
DepModel.Tm∙ M7D' = λ t → Lift (M7₁.⟦ t ⟧ ≡ M7₂.⟦ t ⟧)
DepModel.true∙ M7D' = mk refl
DepModel.false∙ M7D' = mk refl
DepModel.ite∙ M7D' {f} (mk ih1) {u} (mk ih2) {v} (mk ih3) = mk (cong₃ if_then_else_ ih1 ih2 ih3)
DepModel.num∙ M7D' zero = mk refl
DepModel.num∙ M7D' (suc n) = mk refl
DepModel.isZero∙ M7D' n = mk {!   !}
DepModel._+o∙_ M7D' {a} (mk ih1) {b} (mk ih2) = {! cong₂ (λ x y → ?) ih1 ih2 ◾ ?  !}

------------------------------------------
-- NAGYON HOSSZÚ FELADAT! De érdekes koncepciót mutat be. Legalább elkezdeni érdemes.
-- Előfordulhat olyan "sima" interpretáció is, amire az egyszerű modell kevés, ez egy ilyen szeretne lenni.
-- Ebben a feladatban szeretnénk minél pontosabb interpretációt adni.
-- Megközelítőleg a WT standard modelljét emulálja; a típusellenőrzés itt szemantikában van benne.
-- És borzasztó hosszú megírni szemantikában.

-- Definiáld azt a modellt, amely megpróbál kiértékelni kifejezéseket, ha azok típushelyesek.
-- Nem kell hozzá WT (de órán majd kiderül, hogy WT-ben sokkal egyszerűbb és rövidebb).
-- true és false egyértelműen 𝟚 típusúak.
-- num-ok egyértelműen ℕ típusúak.
-- ite lehet 𝟚 vagy ℕ, attól függ, hogy a paraméterekben mi van.
--   A rövidség kedvéért lehet különböző típusú érték a két ágon, illetve hibás érték lehet egy ágon, ha a másikkal kell kezdenie valamit.
-- isZero: a paramétere ℕ, az eredménye 𝟚, ellenőrzi, hogy a szám 0-e, ekkor tt az eredmény, máskor ff, de lehet, hogy korábban már hibás eredményünk volt, ekkor hibánk van továbbra is.
-- +o: A két paramétere ℕ, az eredménye szintén ℕ, összeadja a számokat, szintén lehetett hiba korábban.

M8 : DepModel {lzero}
DepModel.Tm∙ M8 = {!   !}
DepModel.true∙ M8 = tt
DepModel.false∙ M8 = ff
DepModel.ite∙ M8 = {!   !}
DepModel.num∙ M8 n = n
DepModel.isZero∙ M8 = {!   !}
DepModel._+o∙_ M8 = {!   !}

module M8 = DepModel M8

M8-test1 : M8.⟦ I.true ⟧ ≡ tt
M8-test1 = refl
M8-test2 : M8.⟦ I.num 2 ⟧ ≡ 2
M8-test2 = refl
M8-test3 : M8.⟦ I.num 2 I.+o I.true ⟧ ≡ nothing
M8-test3 = refl
M8-test4 : M8.⟦ I.ite I.true (I.num 0) (I.num 1) ⟧ ≡ just (ι₂ 0)
M8-test4 = refl
M8-test5 : M8.⟦ I.ite (I.isZero (I.num 1)) (I.num 0 I.+o I.num 2) I.false ⟧ ≡ just (ι₁ ff)
M8-test5 = refl
M8-test6 : M8.⟦ I.isZero (I.isZero (I.num 0)) ⟧ ≡ nothing
M8-test6 = refl
M8-test7 : M8.⟦ I.isZero (I.num 0) ⟧ ≡ just tt
M8-test7 = refl
M8-test8 : M8.⟦ (I.num 4 I.+o I.num 5) I.+o (I.num 2 I.+o I.num 3) ⟧ ≡ just 14
M8-test8 = refl
M8-test9 : M8.⟦ (I.ite (I.isZero I.true) (I.num 3 I.+o I.true) I.true) I.+o (I.num 2 I.+o I.false) ⟧ ≡ nothing
M8-test9 = refl
M8-test10 : M8.⟦ (I.ite (I.isZero (I.num 1)) (I.num 3 I.+o I.true) (I.num 1)) I.+o (I.num 2 I.+o I.num 3) ⟧ ≡ just 6
M8-test10 = refl
M8-test11 : M8.⟦ I.ite (I.ite (I.isZero (I.num 2 I.+o I.num 0)) (I.num 0) I.true) (I.num 2) (I.true I.+o I.false) ⟧ ≡ just (ι₂ 2)
M8-test11 = refl
M8-test12 : M8.⟦ I.num 0 I.+o (I.num 0 I.+o I.isZero (I.num 0)) ⟧ ≡ nothing
M8-test12 = refl
M8-test13 : M8.⟦ I.num 0 I.+o (I.num 0 I.+o I.num 0) ⟧ ≡ just 0
M8-test13 = refl