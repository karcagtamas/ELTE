{-# OPTIONS --prop --rewriting #-}

module gy05-1 where

open import Lib

module type-inference where

  import RazorAST
  open import RazorWT
  open RazorWT.I

  -- tipuskikovetkeztetes primitiv hibauzenetekkel

  data Result (A : Set) : Set where
    Ok : (r : A) → Result A
    Err : (e : ℕ) → Result A

  {-
    Error codes:
    · 1: Non boolean condition
    · 2: Differing branch types
    · 3: Non numeric isZero parameter
    · 4: Non numeric addition parameter
  -}

  Infer : RazorAST.Model {lzero}
  Infer = record
    { Tm      = Result (Σ Ty (λ A → Tm A)) -- WT-beli Ty, WT-beli Tm
    ; true    = Ok (Bool , true)
    ; false   = Ok (Bool , false)
    ; ite     = λ where (Ok (Nat , _)) u v → Err 1
                        (Ok (Bool , f)) (Ok (Nat , u)) (Ok (Nat , v)) → Ok (Nat , ite f u v)
                        (Ok (Bool , f)) (Ok (Bool , u)) (Ok (Bool , v)) → Ok (Bool , ite f u v)
                        (Ok (Bool , f)) (Ok (Bool , _)) (Ok (Nat , _)) → Err 2
                        (Ok (Bool , f)) (Ok (Nat , _)) (Ok (Bool , _)) → Err 2
                        (Err e) _ _ → Err e
                        _ (Err e) _ → Err e
                        _ _ (Err e) → Err e
    ; num     = λ n → Ok (Nat , num n)
    ; isZero  = λ where (Ok (Nat , n)) → Ok (Bool , isZero n)
                        (Ok (Bool , b)) → Err 3
                        (Err e) → Err e
    ; _+o_    = λ where (Ok (Nat , a)) (Ok (Nat , b)) → Ok (Nat , _+o_ a b)
                        (Ok (Nat , _)) (Ok (Bool , _)) → Err 4
                        (Ok (Bool , _)) (Ok (Nat , _)) → Err 4
                        (Ok (Bool , _)) (Ok (Bool , _)) → Err 4
                        (Err e) (Ok o) → Err e
                        (Ok o) (Err e) → Err e
                        (Err e) (Err e') → Err e
    }

  module INF = RazorAST.Model Infer

  inf-test : Result (Σ Ty (λ T → Tm T))
  inf-test = INF.⟦ I'.isZero I'.false ⟧ -- itt lehet tesztelni
    where open RazorAST.I

  -- Standard model

  Standard : Model {lsuc lzero} {lzero}
  Standard = record
    { Ty      = Set
    ; Tm      = λ A → A
    ; Nat     = ℕ
    ; Bool    = 𝟚
    ; true    = tt
    ; false   = ff
    ; ite     = if_then_else_
    ; num     = λ n → n
    ; isZero  = λ where zero → tt
                        (suc n) → ff
    ; _+o_    = _+_
    }
  module STD = Model Standard

  eval : {A : Ty} → Tm A → {!   !}
  eval = {!   !}

  typeOfINF : Result (Σ Ty (λ A → Tm A)) → Set
  typeOfINF r = {!   !}

  run : (t : RazorAST.I.Tm) → {!   !}
  run t = {!   !}

-- Height definialhato WT-ben
  
module NatBool-with-equational-theory where

  open import Razor
  open I

  eq-0 : true ≡ true
  eq-0 = refl

  eq-1 : isZero (num 0) ≡ true
  eq-1 = isZeroβ₁

  eq-1' : true ≡ isZero (num 0)
  eq-1' = isZeroβ₁ ⁻¹ -- \^- \^1 -- symmetry

  eq-2 : isZero (num 3 +o num 1) ≡ isZero (num 4)
  eq-2 = cong isZero +β -- \_1 Alkalmazzuk a cong isZero-ot +β-ra

  eq-3 : isZero (num 4) ≡ false
  eq-3 = isZeroβ₂

  eq-4 : isZero (num 3 +o num 1) ≡ false
  eq-4 = eq-2 ◾ eq-3 -- \sq5

  eq-4' : isZero (num 3 +o num 1) ≡ false
  eq-4' =
    isZero (num 3 +o num 1)
      ≡⟨ eq-2 ⟩ -- \== \< \>
    isZero (num 4) -- Ctrl+c Ctrl+a, automatikus kitolti a koztes allapotot
      ≡⟨ eq-3 ⟩
    false
      ∎ -- \qed

  eq-5 : ite false (num 2) (num 5) ≡ num 5
  eq-5 = iteβ₂

  eq-6 : ite true (isZero (num 0)) false ≡ true
  eq-6 = iteβ₁ ◾ isZeroβ₁

  eq-6' : ite true (isZero (num 0)) false ≡ true
  eq-6' =
    ite true (isZero (num 0)) false
      ≡⟨ iteβ₁ ⟩
    isZero (num zero)
      ≡⟨ isZeroβ₁ ⟩
    true
      ∎

  eq-7 : (num 3 +o num 0) +o num 1 ≡ num 4
  eq-7 =
    ((num 3 +o num 0) +o num 1)
      ≡⟨ cong (_+o num 1) +β ⟩ -- cong: (_+o num 1)-et tartjuk meg es csak az elso felen hasznaljuk a +β
    (num 3 +o num 1)
      ≡⟨ +β ⟩
    num 4
      ∎

  eq-8 : ite (isZero (num 0)) (num 1 +o num 1) (num 0) ≡ num 2
  eq-8 =
    ite (isZero (num 0)) (num 1 +o num 1) (num 0)
      ≡⟨ cong (λ x → ite x (num 1 +o num 1) (num 0)) isZeroβ₁ ⟩
    ite true (num 1 +o num 1) (num zero)
      ≡⟨ iteβ₁ ◾ +β ⟩
    num 2
      ∎

  eq-9 : num 3 +o ite (isZero (num 2)) (num 1) (num 0) ≡ num 3
  eq-9 =
    (num 3 +o ite (isZero (num 2)) (num 1) (num 0))
      ≡⟨ cong (λ x → num 3 +o ite x (num 1) (num 0)) isZeroβ₂ ⟩
    (num 3 +o ite false (num 1) (num zero))
      ≡⟨ cong (num 3 +o_) iteβ₂ ⟩
    (num 3 +o num zero)
      ≡⟨ +β ⟩
    num 3
      ∎

  eq-10 : ite false (num 1 +o num 1) (num 0) +o num 0 ≡ num 0
  eq-10 =
    (ite false (num 1 +o num 1) (num 0) +o num 0)
      ≡⟨ {!   !} ⟩
    {!   !}
      ≡⟨ {!   !} ⟩
    num 0
      ∎

  eq-11 : ite (isZero (num 0 +o num 1)) false (isZero (num 0)) ≡ true
  eq-11 =
    ite (isZero (num 0 +o num 1)) false (isZero (num 0))
      ≡⟨ {!   !} ⟩
    {!   !}
      ≡⟨ {!   !} ⟩
    true
      ∎

  eq-12 : num 3 +o num 2 ≡ ite true (num 5) (num 1)
  eq-12 =
    num 3 +o num 2
      ≡⟨ {!   !} ⟩
    {!   !}
      ≡⟨ {!   !} ⟩
    ite true (num 5) (num 1)
      ∎ 