{-# OPTIONS --prop --rewriting #-}

module gy07-1 where

open import Lib

module DefABT where
  open import DefABT

  open I

  v : (n : ℕ) → ∀{m} → Tm (suc n + m)
  v n = var (v' n) where
    v' : (n : ℕ) → ∀{m} → Var (suc n + m)
    v' zero = vz
    v' (suc n) = vs (v' n)


  -- (let x:=num 1 in x) +o let y:=num 1 in y +o let z:=x +o y in (x +o z) +o (y +o x)
  tm-2 : Tm 1 -- 1 szabad valtozo, de lehetne nagyobb is -> akkor tobb szabad valtozo van
  tm-2 = (def (num 1) v0) +o def (num 1) (v0 +o def (v1 +o v0) ((v2 +o v0) +o (v1 +o v2)))
  -- szabad valtozo - ami kintrol jon. Meg kell tartani a konzisztenciat. Ha valahol hivatkoztam egy tavolasagra, akkor kesobb tartani kell
  -- Ugyan ahoz a valtozohoz ugyan az az indexeles tartozzon

module DefWT where

  open import DefWT
  open I

  -- explicit kontextus: "igazabol egy lista, amiben az egyes elemek az egyes valtozok tipusa"
  -- ◇ ures context
  -- ▹ hozzafuzes

  -- ◇ \di2 \diw     ▹  \t6 \tw2
  --              v2     v1    v0
  tm-0 : Tm (◇ ▹ Bool ▹ Nat ▹ Nat) Bool
  -- Tm elso parametere a kontextus
  -- Tm masodik parametere a tipusa
  tm-0 = isZero (ite v2 (v1 +o v0) v1) -- 3 szabad valtozo, nincs egy def sem

  tm-0' : {A : Ty} → Tm (◇ ▹ Bool ▹ A ▹ Nat ▹ Nat) Bool -- A tetszoleges, nem hasznaljuk azt a valtozot
  tm-0' = isZero (ite v3 (v1 +o v0) v1)

  -- \GG 
  tm-0'' : {Γ : Con}{A : Ty} → Tm (Γ ▹ Bool ▹ A ▹ Nat ▹ Nat) Bool -- Γ barmilyen elozetes context lehet - barmennyi szabad valtozo korabrol
  tm-0'' = isZero (ite v3 (v1 +o v0) v1)

  tm-1 : {Γ : Con}{A : Ty} → Tm (Γ ▹ Nat ▹ A) Nat
  tm-1 = def (v1 +o num 5) (ite (isZero v0) v2 (num 0)) -- def v1 -re hivatkozik, aminek Nat-nak kell lennie, de v0-re nem hivatkozik semmi -> az barmi lehet (A)

  -- tm-2 : {Γ : Con} → Tm (Γ ▹ Nat ▹ Bool ▹ Nat) Bool
  -- ∀ \forall \all
  tm-2 : ∀{Γ} → Tm (Γ ▹ Nat ▹ Bool ▹ Nat) Bool
  tm-2 = ite v1 (isZero v0) (isZero v2)

  tm-3 : ∀{Γ A} → Tm (Γ ▹ Bool ▹ A ▹ Nat) A
  tm-3 = ite (ite v2 (isZero v0) v2) v1 v1 -- v1 barmi lehet - ite miatt

  tm-3' : ∀{Γ A} → Tm (Γ ▹ A ▹ Bool ▹ A ▹ Nat) A
  tm-3' = ite (ite v2 (isZero v0) v2) v1 v3

  tm-4 : ∀{Γ} → Tm (Γ ▹ Bool ▹ Bool ▹ Nat) Bool
  tm-4 = ite v1 (ite v1 v2 v2) (isZero v0)

  tm-5 : ∀{Γ A} → Tm (Γ ▹ Nat ▹ A) Nat
  tm-5 = def (v1 +o num 10) (ite (isZero v0) (v2 +o num 20) v0) -- v0 nincs hasznalva, ezert barmi lehet

  tm-5' : ∀{Γ} → Tm (Γ ▹ Nat ▹ Nat) Nat
  tm-5' = def (v1 +o num 10) (ite (isZero v0) (v1 +o num 20) v0) -- v0 meg lett kotve (v1)

  tm-6 : ∀{Γ} → Tm (Γ ▹ Nat ▹ Nat) Bool
  tm-6 = isZero (def (isZero v1) (ite v0 v1 v2))

  tm-7 : ∀{Γ} → Tm (Γ ▹ Nat ▹ Nat ▹ Nat) Nat
  tm-7 = v1 +o def (def (num 2 +o v0) (v0 +o v1 +o v2)) (v2 +o v3) +o num 10
  -- 3 szabad valtozo

  tm-8 : ∀{Γ} → Tm (Γ ▹ Nat ▹ Nat ▹ Nat) Nat
  tm-8 = def (v1 +o num 10) (ite (isZero v0) (def (isZero v1) (v2 +o v1 +o v4)) (def v0 (v0 +o v1 +o v2) +o v3))