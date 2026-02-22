{-# OPTIONS --prop --rewriting #-}

module gy08-1 where

open import Lib
open import Def
open import Def.Syntax

-- Single Subsitution - egyszeres behelyettesites

-- p - eldob egy elemet, kornyezet eltolasa
-- ⟨_⟩ - hozzaad egy elemet, ami meg van adva
-- _⁺ - masik elem kivalasztasa

{-
  helyettesitest a nyelv resze

-}

module ex1 where
  t : Tm (◇ ▹ Bool) Nat
  t = ite (v 0) (num 1) (num 0)

  γ : Sub ◇ (◇ ▹ Bool)
  γ = ⟨ true ⟩ 

  t[γ] : t [ γ ] ≡ num 1
  t[γ] =
    (t [ γ ])
    ≡⟨ refl ⟩
    ite v0 (num 1) (num 0) [ ⟨ true ⟩ ]
    ≡⟨ ite[] ⟩
    ite (v0 [ ⟨ true ⟩ ]) (num 1 [ ⟨ true ⟩ ]) (num 0 [ ⟨ true ⟩ ])
    ≡⟨ cong (λ x → ite x (num 1 [ ⟨ true ⟩ ]) (num 0 [ ⟨ true ⟩ ])) vz[⟨⟩] ⟩
    ite true (num 1 [ ⟨ true ⟩ ]) (num 0 [ ⟨ true ⟩ ])
    ≡⟨ iteβ₁ ⟩
    num 1 [ ⟨ true ⟩ ]
    ≡⟨ num[] ⟩
    num 1 ∎
  
  δ' : Sub (◇ ▹ Bool) (◇ ▹ Bool ▹ Nat) 
  δ' = ⟨ ite (v 0) (num 1) (num 2) ⟩

  δ : Sub (◇ ▹ Bool ▹ Nat) (◇ ▹ Bool ▹ Nat ▹ Nat)
  δ = ⟨ num 2 ⟩

  u : Tm (◇ ▹ Bool ▹ Nat ▹ Nat) Nat
  u = v 0 +o v 1

  u[δ][δ'] : u [ δ ] [ δ' ] ≡ num 2 +o ite (v 0) (num 1) (num 2)
  u[δ][δ'] =
    (u [ δ ] [ δ' ])
    ≡⟨ refl ⟩
    ((v0 +o v1) [ ⟨ num 2 ⟩ ]) [ ⟨ ite v0 (num 1) (num 2) ⟩ ]
    ≡⟨ cong (λ x → x [ ⟨ ite v0 (num 1) (num 2) ⟩ ]) +[] ⟩ -- egyszeres helyettesites, a sorrend adott
    (v0 [ ⟨ num 2 ⟩ ]) +o (v1 [ ⟨ num 2 ⟩ ]) [ ⟨ ite v0 (num 1) (num 2) ⟩ ]
    ≡⟨ +[] ⟩
    (v0 [ ⟨ num 2 ⟩ ] [ ⟨ ite v0 (num 1) (num 2) ⟩ ]) +o (v1 [ ⟨ num 2 ⟩ ] [ ⟨ ite v0 (num 1) (num 2) ⟩ ])
    ≡⟨ cong₂ (λ x y → (x [ ⟨ ite v0 (num 1) (num 2) ⟩ ]) +o (y [ ⟨ ite v0 (num 1) (num 2) ⟩ ])) vz[⟨⟩] vs[⟨⟩] ⟩
    (num 2 [ ⟨ ite v0 (num 1) (num 2) ⟩ ]) +o (v0 [ ⟨ ite v0 (num 1) (num 2) ⟩ ])
    ≡⟨ cong₂ (λ x y → x +o y) num[] vz[⟨⟩] ⟩
    num 2 +o ite (v 0) (num 1) (num 2) ∎

module ex2 where
  var-test-1 : (def {◇} true v0) ≡ true
  var-test-1 =
    def true v0
    ≡⟨ vz[⟨⟩] ⟩
    true ∎
  
  var-test-2 : (def {◇} true (def false v0)) ≡ false
  var-test-2 =
    def true (def false v0)
    ≡⟨ refl ⟩
    var vz [ ⟨ false ⟩ ] [ ⟨ true ⟩ ]
    ≡⟨ cong (λ x → x [ ⟨ true ⟩ ]) vz[⟨⟩] ⟩
    false [ ⟨ true ⟩ ]
    ≡⟨ false[] ⟩
    false ∎
  
  var-test-3 : (def {◇} true (def false v1)) ≡ true
  var-test-3 =
    def true (def false v1)
    ≡⟨ refl ⟩
    var (vs vz) [ ⟨ false ⟩ ] [ ⟨ true ⟩ ]
    ≡⟨ cong (λ x → x [ ⟨ true ⟩ ]) vs[⟨⟩] ⟩
    var vz [ ⟨ true ⟩ ]
    ≡⟨ vz[⟨⟩] ⟩
    true ∎

  task-eq : (ite v1 (v0 +o v0) v0) [ ⟨ num 2 ⟩ ] [ ⟨ true ⟩ ] ≡ num {◇} 4
  task-eq =
    (ite v1 (v0 +o v0) v0) [ ⟨ num 2 ⟩ ] [ ⟨ true ⟩ ]
    ≡⟨ cong (λ x → x [ ⟨ true ⟩ ]) ite[] ⟩
    ite (var (vs vz) [ ⟨ num 2 ⟩ ]) (var vz +o var vz [ ⟨ num 2 ⟩ ]) (var vz [ ⟨ num 2 ⟩ ]) [ ⟨ true ⟩ ]
    ≡⟨ cong₃ (λ x y z → (ite x y z) [ ⟨ true ⟩ ]) vs[⟨⟩] +[] vz[⟨⟩] ⟩
    ite (var vz) ((var vz [ ⟨ num 2 ⟩ ]) +o (var vz [ ⟨ num 2 ⟩ ])) (num 2) [ ⟨ true ⟩ ]
    ≡⟨ cong₂ (λ x y → ite (var vz) (x +o y) (num 2) [ ⟨ true ⟩ ]) vz[⟨⟩] vz[⟨⟩] ⟩
    ite (var vz) (num 2 +o num 2) (num 2) [ ⟨ true ⟩ ]
    ≡⟨ ite[] ⟩
    ite (var vz [ ⟨ true ⟩ ]) (num 2 +o num 2 [ ⟨ true ⟩ ]) (num 2 [ ⟨ true ⟩ ])
    ≡⟨ cong₃ (λ x y z → ite x y z) vz[⟨⟩] +[] num[] ⟩
    ite true ((num 2 [ ⟨ true ⟩ ]) +o (num 2 [ ⟨ true ⟩ ])) (num 2)
    ≡⟨ iteβ₁ ⟩
    (num 2 [ ⟨ true ⟩ ]) +o (num 2 [ ⟨ true ⟩ ])
    ≡⟨ cong₂ (λ x y → x +o y) num[] num[] ⟩
    num 2 +o num 2
    ≡⟨ +β ⟩
    num 4 ∎
  
  var-eq-4 : def (num 1) (v0 +o v0) ≡ num {◇} 2
  var-eq-4 =
    def (num 1) (v0 +o v0)
    ≡⟨ refl ⟩
    var vz +o var vz [ ⟨ num 1 ⟩ ]
    ≡⟨ +[] ⟩
    (var vz [ ⟨ num 1 ⟩ ]) +o (var vz [ ⟨ num 1 ⟩ ])
    ≡⟨ cong₂ (λ x y → x +o y) vz[⟨⟩] vz[⟨⟩] ⟩
    num 1 +o num 1
    ≡⟨ +β ⟩
    num 2 ∎
  
  var-eq-5 : def false (def (num 2) (ite v1 (num 0) (num 1 +o v0))) ≡ num {◇} 3
  var-eq-5 =
    def false (def (num 2) (ite v1 (num 0) (num 1 +o v0)))
    ≡⟨ refl ⟩
    ite (var (vs vz)) (num zero) (num 1 +o var vz) [ ⟨ num 2 ⟩ ] [ ⟨ false ⟩ ]
    ≡⟨ cong (λ x → x [ ⟨ false ⟩ ]) ite[] ⟩
    ite (var (vs vz) [ ⟨ num 2 ⟩ ]) (num zero [ ⟨ num 2 ⟩ ]) (num 1 +o var vz [ ⟨ num 2 ⟩ ]) [ ⟨ false ⟩ ]
    ≡⟨ cong₃ (λ x y z → (ite x y z) [ ⟨ false ⟩ ]) vs[⟨⟩] num[] +[] ⟩
    ite (var vz) (num zero) ((num 1 [ ⟨ num 2 ⟩ ]) +o (var vz [ ⟨ num 2 ⟩ ])) [ ⟨ false ⟩ ]
    ≡⟨ cong₂ (λ x y → ite (var vz) (num zero) (x +o y) [ ⟨ false ⟩ ]) num[] vz[⟨⟩] ⟩
    ite (var vz) (num zero) (num 1 +o num 2) [ ⟨ false ⟩ ]
    ≡⟨ ite[] ⟩
    ite (var vz [ ⟨ false ⟩ ]) (num zero [ ⟨ false ⟩ ]) (num 1 +o num 2 [ ⟨ false ⟩ ])
    ≡⟨ cong₂ (λ x y → ite x (num zero [ ⟨ false ⟩ ]) y) vz[⟨⟩] +[] ⟩
    ite false (num zero [ ⟨ false ⟩ ]) ((num 1 [ ⟨ false ⟩ ]) +o (num 2 [ ⟨ false ⟩ ]))
    ≡⟨ iteβ₂ ⟩
    (num 1 [ ⟨ false ⟩ ]) +o (num 2 [ ⟨ false ⟩ ])
    ≡⟨ cong₂ _+o_ num[] num[] ⟩
    num 1 +o num 2
    ≡⟨ +β ⟩
    num 3 ∎
  
  var-eq-6 : def (num 0) (def (isZero v0) (ite v0 false true)) ≡ false {◇}
  var-eq-6 =
    def (num 0) (def (isZero v0) (ite v0 false true))
    ≡⟨ refl ⟩
    ite (var vz) false true [ ⟨ isZero (var vz) ⟩ ] [ ⟨ num zero ⟩ ]
    ≡⟨ cong (λ x → x [ ⟨ num zero ⟩ ]) ite[] ⟩
    ite (var vz [ ⟨ isZero (var vz) ⟩ ]) (false [ ⟨ isZero (var vz) ⟩ ]) (true [ ⟨ isZero (var vz) ⟩ ]) [ ⟨ num zero ⟩ ]
    ≡⟨ cong₃ (λ x y z → (ite x y z) [ ⟨ num zero ⟩ ]) vz[⟨⟩] false[] true[] ⟩
    ite (isZero (var vz)) false true [ ⟨ num zero ⟩ ]
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    false ∎
  
  var-eq-7 : def (num 1) ((v0 +o num 1) +o def v0 (ite (isZero v0) (num 1) (num 0))) ≡ num {◇} 2
  var-eq-7 =
    def (num 1) ((v0 +o num 1) +o def v0 (ite (isZero v0) (num 1) (num 0)))
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    num 2 ∎
  
  var-eq-8 : def false (def (num 0) (def (ite v1 v0 (v0 +o (num 1))) (isZero v0))) ≡ false {◇}
  var-eq-8 =
    def false (def (num 0) (def (ite v1 v0 (v0 +o (num 1))) (isZero v0)))
    ≡⟨ {!    !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    false ∎
  
  var-eq-9 : def (num 0) (def (num 1 +o v0) (ite (isZero v0) v1 (v1 +o (num 1) +o v0))) ≡ num {◇} 2
  var-eq-9 =
    def (num 0) (def (num 1 +o v0) (ite (isZero v0) v1 (v1 +o (num 1) +o v0)))
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    {!!}
    ≡⟨ {!   !} ⟩
    num 2 ∎