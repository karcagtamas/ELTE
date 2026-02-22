{-# OPTIONS --prop --rewriting #-}

module hf09-1 where

open import Lib
open import Def
open import Def.Syntax

var-eq-14 : v1 [ ⟨ num 2 ⟩ ⁺ ] ≡ num {◇ ▹ Bool} 2
var-eq-14 =
  var (vs vz) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ vs[⁺] ⟩
  var vz [ ⟨ num 2 ⟩ ] [ p ]
  ≡⟨ cong (λ x → x [ p ]) vz[⟨⟩] ⟩
  num 2 [ p ]
  ≡⟨ num[] ⟩
  num 2 ∎

var-eq-15 : v2 [ ⟨ num 10 ⟩ ⁺ ⁺ ] ≡ num {◇ ▹ Bool ▹ Nat} 10
var-eq-15 =
  var (vs (vs vz)) [ (⟨ num 10 ⟩ ⁺) ⁺ ]
  ≡⟨ vs[⁺] ⟩
  var (vs vz) [ ⟨ num 10 ⟩ ⁺ ] [ p ]
  ≡⟨ cong (λ x → x [ p ]) vs[⁺] ⟩
  var vz [ ⟨ num 10 ⟩ ] [ p ] [ p ]
  ≡⟨ cong (λ x → x [ p ] [ p ]) vz[⟨⟩] ⟩
  num 10 [ p ] [ p ]
  ≡⟨ cong (λ x → x [ p ]) num[] ⟩
  num 10 [ p ]
  ≡⟨ num[] ⟩
  num 10 ∎

var-eq-16 : isZero {◇ ▹ Nat ▹ Nat ▹ Bool} (v1 +o v2) [ ⟨ num 0 ⟩ ⁺ ] [ ⟨ num 2 ⟩ ⁺ ] ≡ ite v1 false true [ ⟨ true ⟩ ⁺ ]
var-eq-16 =
  isZero (var (vs vz) +o var (vs (vs vz))) [ ⟨ num zero ⟩ ⁺ ] [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong (λ x → x [ ⟨ num 2 ⟩ ⁺ ]) isZero[] ⟩
  isZero (var (vs vz) +o var (vs (vs vz)) [ ⟨ num zero ⟩ ⁺ ]) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong (λ x → (isZero x) [ ⟨ num 2 ⟩ ⁺ ]) +[] ⟩
  isZero ((var (vs vz) [ ⟨ num zero ⟩ ⁺ ]) +o (var (vs (vs vz)) [ ⟨ num zero ⟩ ⁺ ])) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong₂ (λ x y → (isZero (x +o y)) [ ⟨ num 2 ⟩ ⁺ ]) vs[⁺] vs[⁺] ⟩
  isZero ((var vz [ ⟨ num zero ⟩ ] [ p ]) +o (var (vs vz) [ ⟨ num zero ⟩ ] [ p ])) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong₂ (λ x y → (isZero ((x [ p ]) +o (y [ p ]))) [ ⟨ num 2 ⟩ ⁺ ]) vz[⟨⟩] vs[⟨⟩] ⟩
  isZero ((num zero [ p ]) +o (var vz [ p ])) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong₂ (λ x y → (isZero (x +o y)) [ ⟨ num 2 ⟩ ⁺ ]) num[] [p] ⟩
  isZero (num zero +o var (vs vz)) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ isZero[] ⟩
  isZero (num zero +o var (vs vz) [ ⟨ num 2 ⟩ ⁺ ])
  ≡⟨ cong (λ x → isZero x) +[] ⟩
  isZero ((num zero [ ⟨ num 2 ⟩ ⁺ ]) +o (var (vs vz) [ ⟨ num 2 ⟩ ⁺ ]))
  ≡⟨ cong₂ (λ x y → isZero (x +o y)) num[] vs[⁺] ⟩
  isZero (num zero +o (var vz [ ⟨ num 2 ⟩ ] [ p ]))
  ≡⟨ cong (λ x → isZero (num zero +o (x [ p ]))) vz[⟨⟩] ⟩
  isZero (num zero +o (num 2 [ p ]))
  ≡⟨ cong (λ x → isZero (num zero +o x)) num[] ⟩
  isZero (num zero +o num 2)
  ≡⟨ cong (λ x → isZero x) +β ⟩
  isZero (num 2)
  ≡⟨ isZeroβ₂ ⟩
  false
  ≡⟨ iteβ₁ ⁻¹ ⟩
  ite true false true
  ≡⟨ cong₃ (λ x y z → ite x y z) (true[] ⁻¹) (false[] ⁻¹) (true[] ⁻¹) ⟩
  ite (true [ p ]) (false [ ⟨ true ⟩ ⁺ ]) (true [ ⟨ true ⟩ ⁺ ])
  ≡⟨ cong (λ x → ite (x [ p ]) (false [ ⟨ true ⟩ ⁺ ]) (true [ ⟨ true ⟩ ⁺ ])) (vz[⟨⟩] ⁻¹) ⟩
  ite (v0 [ ⟨ true ⟩ ] [ p ]) (false [ ⟨ true ⟩ ⁺ ]) (true [ ⟨ true ⟩ ⁺ ])
  ≡⟨ cong (λ x → ite x (false [ ⟨ true ⟩ ⁺ ]) (true [ ⟨ true ⟩ ⁺ ])) (vs[⁺] ⁻¹) ⟩
  ite (var (vs vz) [ ⟨ true ⟩ ⁺ ]) (false [ ⟨ true ⟩ ⁺ ]) (true [ ⟨ true ⟩ ⁺ ])
  ≡⟨ ite[] ⁻¹ ⟩
  ite (var (vs vz)) false true [ ⟨ true ⟩ ⁺ ] ∎

var-eq-17 : isZero {◇ ▹ Nat ▹ Nat ▹ Nat} v1 [ ⟨ v0 +o num 0 ⟩ ⁺ ] [ ⟨ num 2 ⟩ ⁺ ]
          ≡ isZero v0 [ ⟨ num 1 +o v1 ⟩ ] [ ⟨ num 0 ⟩ ⁺ ]
var-eq-17 =
  isZero (var (vs vz)) [ ⟨ var vz +o num zero ⟩ ⁺ ] [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong (λ x → x [ ⟨ num 2 ⟩ ⁺ ]) isZero[] ⟩
  isZero (var (vs vz) [ ⟨ var vz +o num zero ⟩ ⁺ ]) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong (λ x → isZero x [ ⟨ num 2 ⟩ ⁺ ]) vs[⁺] ⟩
  isZero (var vz [ ⟨ var vz +o num zero ⟩ ] [ p ]) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong (λ x → (isZero (x [ p ])) [ ⟨ num 2 ⟩ ⁺ ]) vz[⟨⟩] ⟩
  isZero (var vz +o num zero [ p ]) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong ((λ x → isZero x [ ⟨ num 2 ⟩ ⁺ ])) +[] ⟩
  isZero ((var vz [ p ]) +o (num zero [ p ])) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ cong₂ (λ x y → isZero (x +o y) [ ⟨ num 2 ⟩ ⁺ ]) [p] num[] ⟩
  isZero (var (vs vz) +o num zero) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ isZero[] ⟩
  isZero (var (vs vz) +o num zero [ ⟨ num 2 ⟩ ⁺ ])
  ≡⟨ cong (λ x → isZero x) +[] ⟩
  isZero ((var (vs vz) [ ⟨ num 2 ⟩ ⁺ ]) +o (num zero [ ⟨ num 2 ⟩ ⁺ ]))
  ≡⟨ cong₂ (λ x y →  isZero (x +o y)) vs[⁺] num[] ⟩
  isZero ((var vz [ ⟨ num 2 ⟩ ] [ p ]) +o num zero)
  ≡⟨ cong (λ x → isZero ((x [ p ]) +o num zero)) vz[⟨⟩] ⟩
  isZero ((num 2 [ p ]) +o num zero)
  ≡⟨ cong (λ x → isZero (x +o num zero)) num[] ⟩
  isZero (num 2 +o num zero)
  ≡⟨ cong isZero +β ⟩
  isZero (num 2)
  ≡⟨ isZeroβ₂ ⟩
  false
  ≡⟨ isZeroβ₂ ⁻¹ ⟩
  isZero (num 1)
  ≡⟨ cong isZero (+β ⁻¹) ⟩
  isZero (num 1 +o num zero)
  ≡⟨ cong₂ (λ x y → isZero (x +o y)) (num[] ⁻¹) (num[] ⁻¹) ⟩
  isZero ((num 1 [ ⟨ num 0 ⟩ ⁺ ]) +o (num zero [ p ]))
  ≡⟨ cong (λ x → isZero ((num 1 [ ⟨ num 0 ⟩ ⁺ ]) +o (x [ p ]))) (vz[⟨⟩] ⁻¹) ⟩
  isZero ((num 1 [ ⟨ num zero ⟩ ⁺ ]) +o (var vz [ ⟨ num zero ⟩ ] [ p ]))
  ≡⟨ cong (λ x → isZero ((num 1 [ ⟨ num zero ⟩ ⁺ ]) +o x)) (vs[⁺] ⁻¹) ⟩
  isZero ((num 1 [ ⟨ num zero ⟩ ⁺ ]) +o (var (vs vz) [ ⟨ num zero ⟩ ⁺ ]))
  ≡⟨ cong isZero (+[] ⁻¹) ⟩
  isZero (num 1 +o var (vs vz) [ ⟨ num zero ⟩ ⁺ ])
  ≡⟨ isZero[] ⁻¹ ⟩
  isZero (num 1 +o var (vs vz)) [ ⟨ num zero ⟩ ⁺ ]
  ≡⟨ cong (λ x → (isZero x) [ ⟨ num zero ⟩ ⁺ ]) (vz[⟨⟩] ⁻¹) ⟩
  isZero (var vz [ ⟨ num 1 +o var (vs vz) ⟩ ]) [ ⟨ num zero ⟩ ⁺ ]
  ≡⟨ cong (λ x → x [ ⟨ num zero ⟩ ⁺ ]) (isZero[] ⁻¹) ⟩
  isZero (var vz) [ ⟨ num 1 +o var (vs vz) ⟩ ] [ ⟨ num zero ⟩ ⁺ ] ∎