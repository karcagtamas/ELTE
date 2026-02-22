{-# OPTIONS --prop --rewriting #-}

module zh08-1 where

open import Lib
open import Def
open import Def.Syntax

var-eq-13 : def true (def (ite v0 (num 1) (num 0)) (isZero v0)) ≡ v0 [ ⟨ false {◇} ⟩ ]
var-eq-13 =
  isZero (var vz) [ ⟨ ite (var vz) (num 1) (num zero) ⟩ ] [ ⟨ true ⟩ ]
  ≡⟨ cong (λ x → x [ ⟨ true ⟩ ]) isZero[] ⟩
  isZero (var vz [ ⟨ ite (var vz) (num 1) (num zero) ⟩ ]) [ ⟨ true ⟩ ]
  ≡⟨ cong (λ x → isZero x [ ⟨ true ⟩ ]) vz[⟨⟩] ⟩
  isZero (ite (var vz) (num 1) (num zero)) [ ⟨ true ⟩ ]
  ≡⟨ isZero[] ⟩
  isZero (ite (var vz) (num 1) (num zero) [ ⟨ true ⟩ ])
  ≡⟨ cong (λ x → isZero x) ite[] ⟩
  isZero (ite (var vz [ ⟨ true ⟩ ]) (num 1 [ ⟨ true ⟩ ]) (num zero [ ⟨ true ⟩ ]))
  ≡⟨ cong₃ (λ x y z →  isZero (ite x y z)) vz[⟨⟩] num[] num[] ⟩
  isZero (ite true (num 1) (num zero))
  ≡⟨ cong (λ x → isZero x) iteβ₁ ⟩
  isZero (num 1)
  ≡⟨ isZeroβ₂ ⟩
  false
  ≡⟨ vz[⟨⟩] ⁻¹ ⟩
  var vz [ ⟨ false ⟩ ] ∎