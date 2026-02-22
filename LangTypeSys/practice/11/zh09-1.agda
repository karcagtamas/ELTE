{-# OPTIONS --prop --rewriting #-}

module zh09-1 where

open import Lib
open import Def.Syntax

-- Bizonyítsd az alábbi állítást!
-- A bizonyítás során a szintaxis világa nem hagyható el!
-- (Magyarul nem lehet compl-t használni!)

task : v1 {◇ ▹ Bool} {Nat} {Nat} [ ⟨ num 2 ⟩ ⁺ ] ≡ v2 [ ⟨ num 2 ⟩ ⁺ ⁺ ]
task =
  var (vs vz) [ ⟨ num 2 ⟩ ⁺ ]
  ≡⟨ vs[⁺] ⟩
  var vz [ ⟨ num 2 ⟩ ] [ p ]
  ≡⟨ cong (λ x → x [ p ]) vz[⟨⟩] ⟩
  num 2 [ p ]
  ≡⟨ cong (λ x → x [ p ]) (num[] ⁻¹) ⟩
  num 2 [ p ] [ p ]
  ≡⟨ cong (λ x → x [ p ] [ p ]) (vz[⟨⟩]  ⁻¹) ⟩
  var vz [ ⟨ num 2 ⟩ ] [ p ] [ p ]
  ≡⟨ cong (λ x → x [ p ]) (vs[⁺] ⁻¹) ⟩
  var (vs vz) [ ⟨ num 2 ⟩ ⁺ ] [ p ]
  ≡⟨ vs[⁺] ⁻¹ ⟩
  var (vs (vs vz)) [ ⟨ num 2 ⟩ ⁺ ⁺ ] ∎