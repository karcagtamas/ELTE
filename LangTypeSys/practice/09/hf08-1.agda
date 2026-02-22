{-# OPTIONS --prop --rewriting #-}

module hf08-1 where

open import Lib
open import Def
open import Def.Syntax

-- var-eq-12-t ÉRDEMES megnézni, mert bár visszafelé egyenlőséget ugyan
-- nem mutattam ebben a világban, a koncepció már ismerős és Razor-ben mutattam.
-- Ugyanazt kell csinálni, csak az egyenlőségek száma több.

var-eq-6 : def (num 0) (def (isZero v0) (ite v0 false true)) ≡ false {◇}
var-eq-6 =
  def (num 0) (def (isZero v0) (ite v0 false true))
  ≡⟨ refl ⟩
  ite (var vz) false true [ ⟨ isZero (var vz) ⟩ ] [ ⟨ num zero ⟩ ]
  ≡⟨ cong (λ x → x [ ⟨ num zero ⟩ ]) ite[] ⟩
  ite (var vz [ ⟨ isZero (var vz) ⟩ ]) (false [ ⟨ isZero (var vz) ⟩ ]) (true [ ⟨ isZero (var vz) ⟩ ]) [ ⟨ num zero ⟩ ]
  ≡⟨ cong₃ (λ x y z → (ite x y z) [ ⟨ num zero ⟩ ]) vz[⟨⟩] false[] true[] ⟩
  ite (isZero (var vz)) false true [ ⟨ num zero ⟩ ]
  ≡⟨ ite[] ⟩
  ite (isZero (var vz) [ ⟨ num zero ⟩ ]) (false [ ⟨ num zero ⟩ ]) (true [ ⟨ num zero ⟩ ])
  ≡⟨ cong₃ (λ x y z → ite x y z) isZero[] false[] true[] ⟩
  ite (isZero (var vz [ ⟨ num zero ⟩ ])) false true
  ≡⟨ cong (λ x → ite (isZero x) false true) vz[⟨⟩] ⟩
  ite (isZero (num zero)) false true
  ≡⟨ cong (λ x → ite x false true) isZeroβ₁ ⟩
  ite true false true
  ≡⟨ iteβ₁ ⟩
  false ∎

var-eq-7 : def (num 1) ((v0 +o num 1) +o def v0 (ite (isZero v0) (num 1) (num 0))) ≡ num {◇} 2
var-eq-7 =
  def (num 1) ((v0 +o num 1) +o def v0 (ite (isZero v0) (num 1) (num 0)))
  ≡⟨ refl ⟩
  var vz +o num 1 +o (ite (isZero (var vz)) (num 1) (num zero) [ ⟨ var vz ⟩ ]) [ ⟨ num 1 ⟩ ]
  ≡⟨ +[] ⟩
  (var vz +o num 1 [ ⟨ num 1 ⟩ ]) +o (ite (isZero (var vz)) (num 1) (num zero) [ ⟨ var vz ⟩ ] [ ⟨ num 1 ⟩ ])
  ≡⟨ cong₂ (λ x y → x +o (y [ ⟨ num 1 ⟩ ])) +[] ite[] ⟩
  (var vz [ ⟨ num 1 ⟩ ]) +o (num 1 [ ⟨ num 1 ⟩ ]) +o (ite (isZero (var vz) [ ⟨ var vz ⟩ ]) (num 1 [ ⟨ var vz ⟩ ]) (num zero [ ⟨ var vz ⟩ ]) [ ⟨ num 1 ⟩ ])
  ≡⟨ cong₂ (λ x y → (x +o y) +o (ite (isZero (var vz) [ ⟨ var vz ⟩ ]) (num 1 [ ⟨ var vz ⟩ ]) (num zero [ ⟨ var vz ⟩ ]) [ ⟨ num 1 ⟩ ])) vz[⟨⟩] num[] ⟩
  num 1 +o num 1 +o (ite (isZero (var vz) [ ⟨ var vz ⟩ ]) (num 1 [ ⟨ var vz ⟩ ]) (num zero [ ⟨ var vz ⟩ ]) [ ⟨ num 1 ⟩ ])
  ≡⟨ cong₃ (λ x y z → num 1 +o num 1 +o ((ite x y z) [ ⟨ num 1 ⟩ ])) isZero[] num[] num[] ⟩
  num 1 +o num 1 +o (ite (isZero (var vz [ ⟨ var vz ⟩ ])) (num 1) (num zero) [ ⟨ num 1 ⟩ ])
  ≡⟨ cong (λ x → num 1 +o num 1 +o (ite (isZero x) (num 1) (num zero) [ ⟨ num 1 ⟩ ])) vz[⟨⟩] ⟩
  num 1 +o num 1 +o (ite (isZero (var vz)) (num 1) (num zero) [ ⟨ num 1 ⟩ ])
  ≡⟨ cong₂ (λ x y → x +o y) +β ite[] ⟩
  num 2 +o ite (isZero (var vz) [ ⟨ num 1 ⟩ ]) (num 1 [ ⟨ num 1 ⟩ ]) (num 0 [ ⟨ num 1 ⟩ ])
  ≡⟨ cong₃ (λ x y z → num 2 +o ite x y z) isZero[] num[] num[] ⟩
  num 2 +o ite (isZero (var vz [ ⟨ num 1 ⟩ ])) (num 1) (num zero)
  ≡⟨ cong (λ x → num 2 +o ite (isZero x) (num 1) (num 0)) vz[⟨⟩] ⟩
  num 2 +o ite (isZero (num 1)) (num 1) (num zero)
  ≡⟨ cong (λ x → num 2 +o ite x (num 1) (num 0)) isZeroβ₂ ⟩
  num 2 +o ite false (num 1) (num zero)
  ≡⟨ cong (λ x → num 2 +o x) iteβ₂ ⟩
  num 2 +o num zero
  ≡⟨ +β ⟩
  num 2 ∎

var-eq-8 : def false (def (num 0) (def (ite v1 v0 (v0 +o (num 1))) (isZero v0))) ≡ false {◇}
var-eq-8 =
  def false (def (num 0) (def (ite v1 v0 (v0 +o (num 1))) (isZero v0)))
  ≡⟨ refl ⟩
  isZero (var vz) [ ⟨ ite (var (vs vz)) (var vz) (var vz +o num 1) ⟩ ] [ ⟨ num zero ⟩ ] [ ⟨ false ⟩ ]
  ≡⟨ cong (λ x → x [ ⟨ num zero ⟩ ] [ ⟨ false ⟩ ])  isZero[] ⟩
  isZero (var vz [ ⟨ ite (var (vs vz)) (var vz) (var vz +o num 1) ⟩ ]) [ ⟨ num zero ⟩ ] [ ⟨ false ⟩ ]
  ≡⟨ cong (λ x → (isZero x) [ ⟨ num zero ⟩ ] [ ⟨ false ⟩ ]) vz[⟨⟩] ⟩
  isZero (ite (var (vs vz)) (var vz) (var vz +o num 1)) [ ⟨ num zero ⟩ ] [ ⟨ false ⟩ ]
  ≡⟨ cong (λ x → x [ ⟨ false ⟩ ]) isZero[] ⟩
  isZero (ite (var (vs vz)) (var vz) (var vz +o num 1) [ ⟨ num zero ⟩ ]) [ ⟨ false ⟩ ]
  ≡⟨ cong (λ x → (isZero x) [ ⟨ false ⟩ ]) ite[] ⟩
  isZero (ite (var (vs vz) [ ⟨ num zero ⟩ ]) (var vz [ ⟨ num zero ⟩ ]) (var vz +o num 1 [ ⟨ num zero ⟩ ])) [ ⟨ false ⟩ ]
  ≡⟨ cong₃ (λ x y z → isZero (ite x y z) [ ⟨ false ⟩ ]) vs[⟨⟩] vz[⟨⟩] +[] ⟩
  isZero (ite (var vz) (num zero) ((var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]))) [ ⟨ false ⟩ ]
  ≡⟨ cong₂ (λ x y → isZero (ite (var vz) (num zero) (x +o y)) [ ⟨ false ⟩ ]) vz[⟨⟩] num[] ⟩
  isZero (ite (var vz) (num zero) (num zero +o num 1)) [ ⟨ false ⟩ ]
  ≡⟨ isZero[] ⟩
  isZero (ite (var vz) (num zero) (num zero +o num 1) [ ⟨ false ⟩ ])
  ≡⟨ cong (λ x → isZero x) ite[] ⟩
  isZero (ite (var vz [ ⟨ false ⟩ ]) (num zero [ ⟨ false ⟩ ]) (num zero +o num 1 [ ⟨ false ⟩ ]))
  ≡⟨ cong₃ (λ x y z → isZero (ite x y z)) vz[⟨⟩] num[] +[] ⟩
  isZero (ite false (num zero) ((num zero [ ⟨ false ⟩ ]) +o (num 1 [ ⟨ false ⟩ ])))
  ≡⟨ cong₂ (λ x y → isZero (ite false (num zero) (x +o y))) num[] num[] ⟩
  isZero (ite false (num zero) (num zero +o num 1))
  ≡⟨ cong (λ x → isZero x) iteβ₂ ⟩
  isZero (num zero +o num 1)
  ≡⟨ cong (λ x → isZero x) +β ⟩
  isZero (num 1)
  ≡⟨ isZeroβ₂ ⟩
  false ∎

var-eq-9 : def (num 0) (def (num 1 +o v0) (ite (isZero v0) v1 (v1 +o (num 1) +o v0))) ≡ num {◇} 2
var-eq-9 =
  def (num 0) (def (num 1 +o v0) (ite (isZero v0) v1 (v1 +o (num 1) +o v0)))
  ≡⟨ refl ⟩
  ite (isZero (var vz)) (var (vs vz)) (var (vs vz) +o num 1 +o var vz) [ ⟨ num 1 +o var vz ⟩ ] [ ⟨ num zero ⟩ ]
  ≡⟨ cong (λ x → x  [ ⟨ num zero ⟩ ]) ite[] ⟩
  ite (isZero (var vz) [ ⟨ num 1 +o var vz ⟩ ]) (var (vs vz) [ ⟨ num 1 +o var vz ⟩ ]) (var (vs vz) +o num 1 +o var vz [ ⟨ num 1 +o var vz ⟩ ]) [ ⟨ num zero ⟩ ]
  ≡⟨ cong₃ (λ x y z → (ite x y z) [ ⟨ num zero ⟩ ]) isZero[] vs[⟨⟩] +[] ⟩
  ite (isZero (var vz [ ⟨ num 1 +o var vz ⟩ ])) (var vz) ((var (vs vz) +o num 1 [ ⟨ num 1 +o var vz ⟩ ]) +o (var vz [ ⟨ num 1 +o var vz ⟩ ])) [ ⟨ num zero ⟩ ]
  ≡⟨ cong₃ (λ x y z → (ite (isZero x) v0 (y +o z)) [ ⟨ num zero ⟩ ]) vz[⟨⟩] +[] vz[⟨⟩] ⟩
  ite (isZero (num 1 +o var vz)) (var vz) ((var (vs vz) [ ⟨ num 1 +o var vz ⟩ ]) +o (num 1 [ ⟨ num 1 +o var vz ⟩ ]) +o (num 1 +o var vz)) [ ⟨ num zero ⟩ ]
  ≡⟨ cong₂ (λ x y → ite (isZero (num 1 +o var vz)) (var vz) (x +o y +o (num 1 +o var vz)) [ ⟨ num zero ⟩ ]) vs[⟨⟩] num[] ⟩
  ite (isZero (num 1 +o var vz)) (var vz) (var vz +o num 1 +o (num 1 +o var vz)) [ ⟨ num zero ⟩ ]
  ≡⟨ ite[] ⟩
  ite (isZero (num 1 +o var vz) [ ⟨ num zero ⟩ ]) (var vz [ ⟨ num zero ⟩ ]) (var vz +o num 1 +o (num 1 +o var vz) [ ⟨ num zero ⟩ ])
  ≡⟨ cong₃ (λ x y z → ite x y z) isZero[] vz[⟨⟩] +[] ⟩
  ite (isZero (num 1 +o var vz [ ⟨ num zero ⟩ ])) (num zero) ((var vz +o num 1 [ ⟨ num zero ⟩ ]) +o (num 1 +o var vz [ ⟨ num zero ⟩ ]))
  ≡⟨ cong₃ (λ x y z →  ite (isZero x) (num zero) (y +o z)) +[] +[] +[] ⟩
  ite (isZero ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ]))) (num zero) ((var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]) +o ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ])))
  ≡⟨ cong₂ (λ x y → ite (isZero (x +o y)) (num zero) ((var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]) +o ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ])))) num[] vz[⟨⟩] ⟩
  ite (isZero (num 1 +o num zero)) (num zero) ((var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]) +o ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ])))
  ≡⟨ cong (λ x → ite (isZero x) (num zero) ((var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]) +o ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ])))) +β ⟩
  ite (isZero (num 1)) (num zero) ((var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]) +o ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ])))
  ≡⟨ cong (λ x → ite x (num zero) ((var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]) +o ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ])))) isZeroβ₂ ⟩
  ite false (num zero) ((var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]) +o ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ])))
  ≡⟨ iteβ₂ ⟩
  (var vz [ ⟨ num zero ⟩ ]) +o (num 1 [ ⟨ num zero ⟩ ]) +o ((num 1 [ ⟨ num zero ⟩ ]) +o (var vz [ ⟨ num zero ⟩ ]))
  ≡⟨ cong₃ (λ x y z →  x +o y +o (z +o (var vz [ ⟨ num zero ⟩ ]))) vz[⟨⟩] num[] num[] ⟩
  num zero +o num 1 +o (num 1 +o (var vz [ ⟨ num zero ⟩ ]))
  ≡⟨ cong₂ (λ x y → x +o (num 1 +o y)) +β vz[⟨⟩] ⟩
  num 1 +o (num 1 +o num zero)
  ≡⟨ cong (num 1 +o_) +β ⟩
  num 1 +o num 1
  ≡⟨ +β ⟩
  num 2 ∎

var-eq-10 : ite v0 v1 v2 +o ite (isZero v1) v2 (num 2) [ ⟨ true ⟩ ] [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ] ≡ num {◇} 5
var-eq-10 =
  ite (var vz) (var (vs vz)) (var (vs (vs vz))) +o ite (isZero (var (vs vz))) (var (vs (vs vz))) (num 2) [ ⟨ true ⟩ ] [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]
  ≡⟨ refl ⟩
  ite (var vz) (var (vs vz)) (var (vs (vs vz))) +o ite (isZero (var (vs vz))) (var (vs (vs vz))) (num 2) [ ⟨ true ⟩ ] [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]
  ≡⟨ cong (λ x → x [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]) +[] ⟩
  (ite (var vz) (var (vs vz)) (var (vs (vs vz))) [ ⟨ true ⟩ ]) +o (ite (isZero (var (vs vz))) (var (vs (vs vz))) (num 2) [ ⟨ true ⟩ ]) [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]
  ≡⟨ cong₂ (λ x y → (x +o y) [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]) ite[] ite[] ⟩
  ite (var vz [ ⟨ true ⟩ ]) (var (vs vz) [ ⟨ true ⟩ ]) (var (vs (vs vz)) [ ⟨ true ⟩ ]) +o ite (isZero (var (vs vz)) [ ⟨ true ⟩ ]) (var (vs (vs vz)) [ ⟨ true ⟩ ]) (num 2 [ ⟨ true ⟩ ]) [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]
  ≡⟨ cong₃ (λ x y z → ((ite x y z) +o ite (isZero (var (vs vz)) [ ⟨ true ⟩ ]) (var (vs (vs vz)) [ ⟨ true ⟩ ]) (num 2 [ ⟨ true ⟩ ])) [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]) vz[⟨⟩] vs[⟨⟩] vs[⟨⟩] ⟩
  ite true (var vz) (var (vs vz)) +o ite (isZero (var (vs vz)) [ ⟨ true ⟩ ]) (var (vs (vs vz)) [ ⟨ true ⟩ ]) (num 2 [ ⟨ true ⟩ ]) [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]
  ≡⟨ cong₃ (λ x y z → ite true (var vz) (var (vs vz)) +o ite x y z [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]) isZero[] vs[⟨⟩] num[] ⟩
  ite true (var vz) (var (vs vz)) +o ite (isZero (var (vs vz) [ ⟨ true ⟩ ])) (var (vs vz)) (num 2) [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]
  ≡⟨ cong₂ (λ x y → (x +o (ite (isZero y) (var (vs vz))) (num 2)) [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]) iteβ₁ vs[⟨⟩] ⟩
  var vz +o ite (isZero (var vz)) (var (vs vz)) (num 2) [ ⟨ num 3 ⟩ ] [ ⟨ num 10 ⟩ ]
  ≡⟨ cong (λ x → x [ ⟨ num 10 ⟩ ]) +[] ⟩
  (var vz [ ⟨ num 3 ⟩ ]) +o (ite (isZero (var vz)) (var (vs vz)) (num 2) [ ⟨ num 3 ⟩ ]) [ ⟨ num 10 ⟩ ]
  ≡⟨ cong₂ (λ x y → (x +o y) [ ⟨ num 10 ⟩ ]) vz[⟨⟩] ite[] ⟩
  num 3 +o ite (isZero (var vz) [ ⟨ num 3 ⟩ ]) (var (vs vz) [ ⟨ num 3 ⟩ ]) (num 2 [ ⟨ num 3 ⟩ ]) [ ⟨ num 10 ⟩ ]
  ≡⟨ cong₃ (λ x y z →  (num 3 +o ite x y z) [ ⟨ num 10 ⟩ ]) isZero[] vs[⟨⟩] num[] ⟩
  num 3 +o ite (isZero (var vz [ ⟨ num 3 ⟩ ])) (var vz) (num 2) [ ⟨ num 10 ⟩ ]
  ≡⟨ cong (λ x → (num 3 +o ite (isZero x) (var vz) (num 2)) [ ⟨ num 10 ⟩ ]) vz[⟨⟩] ⟩
  num 3 +o ite (isZero (num 3)) (var vz) (num 2) [ ⟨ num 10 ⟩ ]
  ≡⟨ cong (λ x → num 3 +o ite x (var vz) (num 2) [ ⟨ num 10 ⟩ ]) isZeroβ₂ ⟩
  num 3 +o ite false (var vz) (num 2) [ ⟨ num 10 ⟩ ]
  ≡⟨ cong (λ x → num 3 +o x [ ⟨ num 10 ⟩ ]) iteβ₂ ⟩
  num 3 +o num 2 [ ⟨ num 10 ⟩ ]
  ≡⟨ +[] ⟩
  (num 3 [ ⟨ num 10 ⟩ ]) +o (num 2 [ ⟨ num 10 ⟩ ])
  ≡⟨ cong₂ (λ x y → x +o y) num[] num[] ⟩
  num 3 +o num 2
  ≡⟨ +β ⟩
  num 5 ∎

var-eq-11 : ite (def (num 0) (isZero v0)) (def (v0 +o num 1) (num 3 +o v0 +o v1)) (v0 +o v1 [ ⟨ num 5 ⟩ ⁺ ]) [ ⟨ num 2 ⟩ ] ≡ num {◇} 8
var-eq-11 = 
  ite (isZero (var vz) [ ⟨ num zero ⟩ ]) (num 3 +o var vz +o var (vs vz) [ ⟨ var vz +o num 1 ⟩ ]) (var vz +o var (vs vz) [ ⟨ num 5 ⟩ ⁺ ]) [ ⟨ num 2 ⟩ ]
  ≡⟨ refl ⟩
  ite (isZero (var vz) [ ⟨ num zero ⟩ ]) (num 3 +o var vz +o var (vs vz) [ ⟨ var vz +o num 1 ⟩ ]) (var vz +o var (vs vz) [ ⟨ num 5 ⟩ ⁺ ]) [ ⟨ num 2 ⟩ ]
  ≡⟨ cong₃ (λ x y z → ite x y z [ ⟨ num 2 ⟩ ]) isZero[] +[] +[] ⟩
  ite (isZero (var vz [ ⟨ num zero ⟩ ])) ((num 3 +o var vz [ ⟨ var vz +o num 1 ⟩ ]) +o (var (vs vz) [ ⟨ var vz +o num 1 ⟩ ])) ((var vz [ ⟨ num 5 ⟩ ⁺ ]) +o (var (vs vz) [ ⟨ num 5 ⟩ ⁺ ])) [ ⟨ num 2 ⟩ ]
  ≡⟨ cong₃ (λ x y z → ite (isZero x) (y +o z) ((var vz [ ⟨ num 5 ⟩ ⁺ ]) +o (var (vs vz) [ ⟨ num 5 ⟩ ⁺ ])) [ ⟨ num 2 ⟩ ]) vz[⟨⟩] +[] vs[⟨⟩] ⟩
  ite (isZero (num zero)) ((num 3 [ ⟨ var vz +o num 1 ⟩ ]) +o (var vz [ ⟨ var vz +o num 1 ⟩ ]) +o var vz) ((var vz [ ⟨ num 5 ⟩ ⁺ ]) +o (var (vs vz) [ ⟨ num 5 ⟩ ⁺ ])) [ ⟨ num 2 ⟩ ]
  ≡⟨ cong (λ x → ite x ((num 3 [ ⟨ var vz +o num 1 ⟩ ]) +o (var vz [ ⟨ var vz +o num 1 ⟩ ]) +o var vz) ((var vz [ ⟨ num 5 ⟩ ⁺ ]) +o (var (vs vz) [ ⟨ num 5 ⟩ ⁺ ])) [ ⟨ num 2 ⟩ ]) isZeroβ₁ ⟩
  ite true ((num 3 [ ⟨ var vz +o num 1 ⟩ ]) +o (var vz [ ⟨ var vz +o num 1 ⟩ ]) +o var vz) ((var vz [ ⟨ num 5 ⟩ ⁺ ]) +o (var (vs vz) [ ⟨ num 5 ⟩ ⁺ ])) [ ⟨ num 2 ⟩ ]
  ≡⟨ cong (λ x →  x [ ⟨ num 2 ⟩ ]) iteβ₁ ⟩
  (num 3 [ ⟨ var vz +o num 1 ⟩ ]) +o (var vz [ ⟨ var vz +o num 1 ⟩ ]) +o var vz [ ⟨ num 2 ⟩ ]
  ≡⟨ cong₂ (λ x y →  x +o y +o var vz [ ⟨ num 2 ⟩ ]) num[] vz[⟨⟩] ⟩
  num 3 +o (var vz +o num 1) +o var vz [ ⟨ num 2 ⟩ ]
  ≡⟨ +[] ⟩
  (num 3 +o (var vz +o num 1) [ ⟨ num 2 ⟩ ]) +o (var vz [ ⟨ num 2 ⟩ ])
  ≡⟨ cong₂ (λ x y → x +o y) +[] vz[⟨⟩] ⟩
  (num 3 [ ⟨ num 2 ⟩ ]) +o (var vz +o num 1 [ ⟨ num 2 ⟩ ]) +o num 2
  ≡⟨ cong₂ (λ x y → x +o y +o num 2) num[] +[] ⟩
  num 3 +o ((var vz [ ⟨ num 2 ⟩ ]) +o (num 1 [ ⟨ num 2 ⟩ ])) +o num 2
  ≡⟨ cong₂ (λ x y → num 3 +o (x +o y) +o num 2) vz[⟨⟩] num[] ⟩
  num 3 +o (num 2 +o num 1) +o num 2
  ≡⟨ cong (λ x → num 3 +o x +o num 2) +β ⟩
  num 3 +o num 3 +o num 2
  ≡⟨ cong (_+o num 2) +β ⟩
  num 6 +o num 2
  ≡⟨ +β ⟩
  num 8 ∎

var-eq-12 : v0 +o num 1 [ ⟨ v0 {◇ ▹ Nat} ⟩ ] ≡ v0 [ ⟨ v0 +o num 1 ⟩ ]
var-eq-12 = 
  var vz +o num 1 [ ⟨ var vz ⟩ ]
  ≡⟨ +[] ⟩
  (var vz [ ⟨ var vz ⟩ ]) +o (num 1 [ ⟨ var vz ⟩ ])
  ≡⟨ cong₂ _+o_ vz[⟨⟩] num[] ⟩
  var vz +o num 1
  ≡⟨ vz[⟨⟩] ⁻¹ ⟩
  v0 [ ⟨ v0 +o num 1 ⟩ ] ∎