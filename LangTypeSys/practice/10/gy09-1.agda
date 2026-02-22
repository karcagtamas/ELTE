{-# OPTIONS --prop --rewriting #-}

module gy09-1 where

open import Lib

module normalisation where
  open import Def
  open import Def.Syntax

  -- [+] minden valtozot eggyel eltol
  -- ne a v0, hanem az annyiadik ahany plusz van
  task0 : v1 [ ⟨ true ⟩ ] [ ⟨ num 0 ⟩ ] [ p ] ≡ num {◇ ▹ Nat} 0
  task0 = 
    (((var (vs vz) [ ⟨ true ⟩ ]) [ ⟨ num zero ⟩ ]) [ p ])
    ≡⟨ cong (λ x →  ((x [ ⟨ num zero ⟩ ]) [ p ])) vs[⟨⟩] ⟩
    ((var vz [ ⟨ num zero ⟩ ]) [ p ])
    ≡⟨ cong (λ x → x [ p ]) vz[⟨⟩] ⟩
    (num zero [ p ])
    ≡⟨ num[] ⟩
    num 0 ∎
    
  task0⁺ : v1 [ ⟨ num 0 ⟩ ⁺ ] ≡ num {◇ ▹ Nat} 0
  task0⁺ =
    (var (vs vz) [ ⟨ num zero ⟩ ⁺ ])
    ≡⟨ vs[⁺] ⟩
    ((var vz [ ⟨ num zero ⟩ ]) [ p ])
    ≡⟨ cong _[ p ] vz[⟨⟩] ⟩
    (num zero [ p ])
    ≡⟨ num[] ⟩
    num zero ∎

  task-eq' : (ite v1 (v 0 +o v 0) (v 0)) [ ⟨ false ⟩ ⁺ ] [ ⟨ num 4 ⟩ ] ≡ num {◇} 4
  task-eq' =
    ((ite (var (vs vz)) (var vz +o var vz) (var vz) [ ⟨ false ⟩ ⁺ ]) [ ⟨ num 4 ⟩ ])
    ≡⟨ cong (λ x → x [ ⟨ num 4 ⟩ ]) ite[] ⟩
    (ite (var (vs vz) [ ⟨ false ⟩ ⁺ ]) ((var vz +o var vz) [ ⟨ false ⟩ ⁺ ]) (var vz [ ⟨ false ⟩ ⁺ ]) [ ⟨ num 4 ⟩ ])
    ≡⟨ cong₂ (λ x y → ite x ((var vz +o var vz) [ ⟨ false ⟩ ⁺ ]) y [ ⟨ num 4 ⟩ ]) vs[⁺] vz[⁺] ⟩
    (ite ((var vz [ ⟨ false ⟩ ]) [ p ]) ((var vz +o var vz) [ ⟨ false ⟩ ⁺ ]) (var vz) [ ⟨ num 4 ⟩ ])
    ≡⟨ cong (λ x → (ite (x [ p ]) ((var vz +o var vz) [ ⟨ false ⟩ ⁺ ]) (var vz) [ ⟨ num 4 ⟩ ])) vz[⟨⟩] ⟩
    (ite (false [ p ]) ((var vz +o var vz) [ ⟨ false ⟩ ⁺ ]) (var vz) [ ⟨ num 4 ⟩ ])
    ≡⟨ cong (λ x → (ite x ((var vz +o var vz) [ ⟨ false ⟩ ⁺ ]) (var vz) [ ⟨ num 4 ⟩ ])) false[] ⟩
    (ite false ((var vz +o var vz) [ ⟨ false ⟩ ⁺ ]) (var vz) [ ⟨ num 4 ⟩ ])
    ≡⟨ cong (λ x → x [ ⟨ num 4 ⟩ ]) iteβ₂ ⟩
    (var vz [ ⟨ num 4 ⟩ ])
    ≡⟨ vz[⟨⟩] ⟩
    num 4 ∎
  
  task2 : (ite (isZero v2) 
               (ite v1 (v0 +o v2) (num 5 +o v0))
               (ite v1 v0 (v2 +o v0 +o num 6))) [ ⟨ num 1 ⟩ ⁺ ⁺ ] [ ⟨ true ⟩ ⁺ ] [ ⟨ num 10 ⟩ ] ≡ num {◇} 10
  task2 =
    (((ite (isZero (var (vs (vs vz)))) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz)) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6)) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x → x [ ⟨ true ⟩ ⁺ ] [ ⟨ num 10 ⟩ ]) ite[] ⟩
    ((ite (isZero (var (vs (vs vz))) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x → ((ite x (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])) isZero[] ⟩
    ((ite (isZero (var (vs (vs vz)) [ (⟨ num 1 ⟩ ⁺) ⁺ ])) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x →  ((ite (isZero x) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])) vs[⁺] ⟩
    ((ite (isZero ((var (vs vz) [ ⟨ num 1 ⟩ ⁺ ]) [ p ])) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x → ((ite (isZero (x [ p ])) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])) vs[⁺] ⟩
    ((ite (isZero (((var vz [ ⟨ num 1 ⟩ ]) [ p ]) [ p ])) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x →  ((ite (isZero ((x [ p ]) [ p ])) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])) vz[⟨⟩] ⟩
    ((ite (isZero ((num 1 [ p ]) [ p ])) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x → ((ite (isZero (x [ p ])) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])) num[] ⟩
    ((ite (isZero (num 1 [ p ])) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x → ((ite (isZero x) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])) num[] ⟩
    ((ite (isZero (num 1)) (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x → ((ite x (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])) isZeroβ₂ ⟩
    ((ite false (ite (var (vs vz)) (var vz +o var (vs (vs vz))) (num 5 +o var vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x → x [ ⟨ true ⟩ ⁺ ] [ ⟨ num 10 ⟩ ]) iteβ₂ ⟩
    (((ite (var (vs vz)) (var vz) ((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ cong (λ x → x [ ⟨ true ⟩ ⁺ ] [ ⟨ num 10 ⟩ ]) ite[] ⟩
    ((ite (var (vs vz) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (var vz [ (⟨ num 1 ⟩ ⁺) ⁺ ]) (((var (vs (vs vz)) +o var vz) +o num 6) [ (⟨ num 1 ⟩ ⁺) ⁺ ]) [ ⟨ true ⟩ ⁺ ]) [ ⟨ num 10 ⟩ ])
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !} ∎
  
  var-eq-3 : (def {◇} true (def false v1)) ≡ true
  var-eq-3 =
    def true (def false v1)
    ≡⟨ cong (λ x → x [ ⟨ true ⟩ ]) vs[⟨⟩] ⟩
    var vz [ ⟨ true ⟩ ]
    ≡⟨ vz[⟨⟩] ⟩
    true ∎
  
  {-
  Var Γ A
    vz, vs vz, ...

  Ne Γ A
    var x, isZero tne, ite tne ane bne, tne + t'ne, tne + num n, num n + tne 

  Nf Γ A
    neu t, true, false, num n
  -}

  -- check what eval, norm and ⌜norm⌝ gives for this term
  t : Tm ◇ Bool
  t = isZero (ite true (num 1) (num 0))

  evalt : Lift ⊤ → 𝟚
  evalt = St.⟦ t ⟧t

  normt : Nf ◇ Bool
  normt = norm t

  ⌜norm⌝t : Tm ◇ Bool
  ⌜norm⌝t = ⌜ norm t ⌝Nf

  complt : ⌜ norm t ⌝Nf ≡ t
  complt = compl t

  -- check what eval, norm and ⌜norm⌝ gives for this term
  t1' : Tm (◇ ▹ Nat) Bool
  t1' = isZero (ite (isZero (num 2 +o num 3)) v0 (v0 +o num 2))

  evalt1 : Lift ⊤ × ℕ → 𝟚
  evalt1 = St.⟦ t1' ⟧t

  normt1 : Nf (◇ ▹ Nat) Bool
  normt1 = norm t1'

  ⌜norm⌝t1 : Tm (◇ ▹ Nat) Bool
  ⌜norm⌝t1 = ⌜ norm t1' ⌝Nf

  complt1 : ⌜ norm t1' ⌝Nf ≡ t1'
  complt1 = compl t1'

  -- How to use completeness
  t2' t3' : Tm ◇ Bool
  t2' = def true (def false v1)
  t3' = true
  
  var-eq-3' : t2' ≡ t3'
  var-eq-3' = 
    ((var (vs vz) [ ⟨ false ⟩ ]) [ ⟨ true ⟩ ])
    ≡⟨ compl t2' ⁻¹ ⟩
    true ∎

  t4' t5' : Tm ◇ Nat
  t4' = def (false {◇}) (def (num 2) (ite v1 (num 0) (num 1 +o v0)))
  t5' = ite true (num {◇} 3) (num 0)
  
  var-eq-5 : t4' ≡ t5'
  var-eq-5 =
    def false (def (num 2) (ite v1 (num 0) (num 1 +o v0)))
    ≡⟨ (cong (_[ ⟨ false ⟩ ])) ite[] ⟩
    ite (var (vs vz) [ ⟨ num 2 ⟩ ])
        (num 0 [ ⟨ num 2 ⟩ ])
        (num 1 +o var vz [ ⟨ num 2 ⟩ ])
      [ ⟨ false ⟩ ]
    ≡⟨ cong₃ (λ x y z → ite x y z [ ⟨ false ⟩ ]) vs[⟨⟩] num[] +[] ⟩
    ite (var vz) 
        (num 0)
        ((num 1 [ ⟨ num 2 ⟩ ]) +o (var vz [ ⟨ num 2 ⟩ ]))
      [ ⟨ false ⟩ ]
    ≡⟨ ite[] ⟩
    ite (var vz [ ⟨ false ⟩ ]) 
        (num 0 [ ⟨ false ⟩ ])
        ((num 1 [ ⟨ num 2 ⟩ ]) +o (var vz [ ⟨ num 2 ⟩ ]) [ ⟨ false ⟩ ])
    ≡⟨ cong₂ (λ x y → ite x (num 0 [ ⟨ false ⟩ ]) y) vz[⟨⟩] +[] ⟩
    ite false 
        (num zero [ ⟨ false ⟩ ])
        ((num 1 [ ⟨ num 2 ⟩ ] [ ⟨ false ⟩ ]) +o (var vz [ ⟨ num 2 ⟩ ] [ ⟨ false ⟩ ]))
    ≡⟨ iteβ₂ ⟩
    (num 1 [ ⟨ num 2 ⟩ ] [ ⟨ false ⟩ ]) +o
    (var vz [ ⟨ num 2 ⟩ ] [ ⟨ false ⟩ ])
    ≡⟨ cong₂ _+o_ ((cong (_[ ⟨ false ⟩ ])) num[]) (cong _[ ⟨ false ⟩ ] vz[⟨⟩]) ⟩
    (num 1 [ ⟨ false ⟩ ]) +o (num 2 [ ⟨ false ⟩ ])
    ≡⟨ cong₂ _+o_ num[] num[] ⟩
    num 1 +o num 2
    ≡⟨ +β ⟩
    num 3
    ≡⟨ iteβ₁ ⁻¹ ⟩
    ite true (num 3) (num 0) ∎

  -- prove that two terms are equal using compl
  var-eq-5' : t4' ≡ t5'
  var-eq-5' =
    ((ite (var (vs vz)) (num zero) (num 1 +o var vz) [ ⟨ num 2 ⟩ ]) [ ⟨ false ⟩ ])
      ≡⟨ compl t4' ⁻¹ ⟩
    num 3
      ≡⟨ compl t5' ⟩
    ite true (num 3) (num zero) ∎

module function where
  open import STT
  open Model I

  infixr 50 _⊚_
  -- external definition
  _⊚_ : {Γ : Con}{A B C : Ty} → Tm Γ (B ⇒ C) → Tm Γ (A ⇒ B) → Tm Γ (A ⇒ C)
  f ⊚ g = {!   !}

  -- internal definition
  ∘o : {Γ : Con}{A B C : Ty} → Tm Γ ((B ⇒ C) ⇒ (A ⇒ B) ⇒ (A ⇒ C))
  ∘o = {!   !}

  -- Define generic internalization and externalization!

  extFun : Con → Ty → Ty → Set
  extFun Γ A B = Tm Γ A → Tm Γ B

  intFun : Con → Ty → Ty → Set
  intFun Γ A B = Tm Γ (A ⇒ B)

  internalize : {Γ : Con}{A B : Ty} → ({Δ : Con} → extFun Δ A B) → intFun Γ A B
  internalize f = {!   !}

  externalize : {Γ : Con}{A B : Ty} → ({Δ : Con} → intFun Δ A B) → extFun Γ A B
  externalize f a = {!   !}

  -- Prove the elimination rules of the internalized `isZero`!

  isZeroInternal : {Γ : Con} → Tm Γ (Nat ⇒ Bool)
  isZeroInternal = {!   !}

  isZero'β₁ : {Γ : Con} → isZeroInternal $ num 0 ≡ true {Γ}
  isZero'β₁ = 
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !} ∎

  isZero'β₂ : {Γ : Con}{n : ℕ} → isZeroInternal $ num (1 + n) ≡ false {Γ}
  isZero'β₂ {n = n} =
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !}
    ≡⟨ {!   !} ⟩
    {!   !} ∎