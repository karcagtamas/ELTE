{-# OPTIONS --prop --rewriting #-}

module hf12-1 where

open import Lib
open import Ind.Syntax
open import Ind.Model
open import Ind
open Standard using (St; _∷_; []) renaming (List to StList ; Tree to StTree)

eval : {A : Ty} → Tm ◇ A → St.⟦ A ⟧T
eval t = St.⟦ t ⟧t (mk triv)

-- Szintaktikus cukorka num-ra:
num : ∀{Γ} → ℕ → Tm Γ Nat
num zero    = zeroo
num (suc n) = suco (num n)

-- FELADAT: Bizonyítsd be, hogy a num[] szabály teljesül!
num[] : ∀{Γ Δ n}{σ : Sub Δ Γ} → num n [ σ ] ≡ num n
num[] {n = zero} = zero[]
num[] {n = suc n} = suc[] ◾ cong suco num[]

-- GYAKORLATRÓL FELADAT: isZeroβ₂
isZero : {Γ : Con} → Tm Γ (Nat ⇒ Bool)
isZero = lam (iteNat true false v0)

isZeroβ₂ : ∀{n} → isZero $ num (1 + n) ≡ false {◇}
isZeroβ₂ {n} = 
  lam (iteNat true false (var vz)) $ suco (num n)
  ≡⟨ ⇒β ⟩
  iteNat true false (var vz) [ ⟨ suco (num n) ⟩ ]
  ≡⟨ iteNat[] ⟩
  iteNat (true [ ⟨ suco (num n) ⟩ ]) (false [ ⟨ suco (num n) ⟩ ⁺ ]) (var vz [ ⟨ suco (num n) ⟩ ])
  ≡⟨ cong₃ (λ x y z → iteNat x y z) true[] false[] vz[⟨⟩] ⟩
  iteNat true false (suco (num n))
  ≡⟨ Natβ₂ ⟩
  false [ ⟨ iteNat true false (num n) ⟩ ]
  ≡⟨ false[] ⟩
  false ∎

-- GYAKORLATRÓL FELADAT: plusβ
plus : {Γ : Con} → Tm Γ (Nat ⇒ Nat ⇒ Nat)
plus = lam (lam (iteNat v0 (suco v0) v1))

-- Segítség: A bizonyításban a num-ban lévő tetszőleges szám miatt kell mintailleszteni.
plusβ : ∀{Γ n m} → plus $ num n $ num m ≡ num {Γ} (n + m)
plusβ {n = zero} {m} = 
  lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ zeroo $ num m
  ≡⟨ cong (λ x → x $ num m) ⇒β ⟩
  lam (iteNat (var vz) (suco (var vz)) (var (vs vz))) [ ⟨ zeroo ⟩ ] $ num m
  ≡⟨ cong (λ x → x $ num m) lam[] ⟩
  lam (iteNat (var vz) (suco (var vz)) (var (vs vz)) [ ⟨ zeroo ⟩ ⁺ ]) $ num m
  ≡⟨ cong (λ x → lam x $ num m) iteNat[] ⟩
  lam (iteNat (var vz [ ⟨ zeroo ⟩ ⁺ ])  (suco (var vz) [ (⟨ zeroo ⟩ ⁺) ⁺ ]) (var (vs vz) [ ⟨ zeroo ⟩ ⁺ ])) $ num m
  ≡⟨ cong₃ (λ x y z → lam (iteNat x y z) $ num m) vz[⁺] suc[] vs[⁺] ⟩
  lam (iteNat (var vz) (suco (var vz [ (⟨ zeroo ⟩ ⁺) ⁺ ]))  (var vz [ ⟨ zeroo ⟩ ] [ p ])) $ num m
  ≡⟨ cong₂ (λ x y → lam (iteNat (var vz) (suco x) (y [ p ])) $ num m) vz[⁺] vz[⟨⟩] ⟩
  lam (iteNat (var vz) (suco (var vz)) (zeroo [ p ])) $ num m
  ≡⟨ cong (λ x → lam (iteNat (var vz) (suco (var vz)) x) $ num m) zero[] ⟩
  lam (iteNat (var vz) (suco (var vz)) zeroo) $ num m
  ≡⟨ ⇒β ⟩
  iteNat (var vz) (suco (var vz)) zeroo [ ⟨ num m ⟩ ]
  ≡⟨ iteNat[] ⟩
  iteNat (var vz [ ⟨ num m ⟩ ]) (suco (var vz) [ ⟨ num m ⟩ ⁺ ]) (zeroo [ ⟨ num m ⟩ ])
  ≡⟨ cong₃ iteNat vz[⟨⟩] suc[] zero[] ⟩
  iteNat (num m) (suco (var vz [ ⟨ num m ⟩ ⁺ ])) zeroo
  ≡⟨ cong (λ x → iteNat (num m) (suco x) zeroo) vz[⁺] ⟩
  iteNat (num m) (suco (var vz)) zeroo
  ≡⟨ Natβ₁ ⟩
  num m ∎
plusβ {n = suc n} {m} = 
  lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ suco (num n) $ num m
  ≡⟨ cong (λ x → x $ num m) ⇒β ⟩
  lam (iteNat (var vz) (suco (var vz)) (var (vs vz))) [ ⟨ suco (num n) ⟩ ] $ num m
  ≡⟨ cong (λ x → x $ num m) lam[] ⟩
  lam (iteNat (var vz) (suco (var vz)) (var (vs vz)) [ ⟨ suco (num n) ⟩ ⁺ ]) $ num m
  ≡⟨ cong (λ x → lam x $ num m) iteNat[] ⟩
  lam (iteNat (var vz [ ⟨ suco (num n) ⟩ ⁺ ]) (suco (var vz) [ (⟨ suco (num n) ⟩ ⁺) ⁺ ]) (var (vs vz) [ ⟨ suco (num n) ⟩ ⁺ ])) $ num m
  ≡⟨ cong₃ (λ x y z → lam (iteNat x y z) $ num m) vz[⁺] suc[] vs[⁺] ⟩
  lam (iteNat (var vz) (suco (var vz [ (⟨ suco (num n) ⟩ ⁺) ⁺ ])) (var vz [ ⟨ suco (num n) ⟩ ] [ p ])) $ num m
  ≡⟨ cong₂ (λ x y → lam (iteNat (var vz) (suco x) (y [ p ])) $ num m) vz[⁺] vz[⟨⟩] ⟩
  lam (iteNat (var vz) (suco (var vz)) (suco (num n) [ p ])) $ num m
  ≡⟨ cong (λ x → lam (iteNat (var vz) (suco (var vz)) x) $ num m) suc[] ⟩
  lam (iteNat (var vz) (suco (var vz)) (suco (num n [ p ]))) $ num m
  ≡⟨ ⇒β ⟩
  iteNat (var vz) (suco (var vz)) (suco (num n [ p ])) [ ⟨ num m ⟩ ]
  ≡⟨ iteNat[] ⟩
  iteNat (var vz [ ⟨ num m ⟩ ]) (suco (var vz) [ ⟨ num m ⟩ ⁺ ]) (suco (num n [ p ]) [ ⟨ num m ⟩ ])
  ≡⟨ cong₃ iteNat vz[⟨⟩] suc[] suc[] ⟩
  iteNat (num m) (suco (var vz [ ⟨ num m ⟩ ⁺ ])) (suco (num n [ p ] [ ⟨ num m ⟩ ]))
  ≡⟨ cong (λ x → iteNat (num m) (suco x) (suco (num n [ p ] [ ⟨ num m ⟩ ]))) vz[⁺] ⟩
  iteNat (num m) (suco (var vz)) (suco (num n [ p ] [ ⟨ num m ⟩ ]))
  ≡⟨ Natβ₂ ⟩
  suco (var vz) [ ⟨ iteNat (num m) (suco (var vz)) (num n [ p ] [ ⟨ num m ⟩ ]) ⟩ ]
  ≡⟨ suc[] ⟩
  suco (var vz [ ⟨ iteNat (num m) (suco (var vz)) (num n [ p ] [ ⟨ num m ⟩ ]) ⟩ ])
  ≡⟨ cong suco vz[⟨⟩] ⟩
  suco (iteNat (num m) (suco (var vz)) (num n [ p ] [ ⟨ num m ⟩ ]))
  ≡⟨ cong (λ x → suco (iteNat (num m) (suco (var vz)) (x [ ⟨ num m ⟩ ]))) num[] ⟩
  suco (iteNat (num m) (suco (var vz)) (num n [ ⟨ num m ⟩ ]))
  ≡⟨ cong (λ x → suco (iteNat (num m) (suco (var vz)) x)) num[] ⟩
  suco (iteNat (num m) (suco (var vz)) (num n))
  ≡⟨ cong suco {! plusβ  !} ⟩
  {!   !}
  ≡⟨ {!   !} ⟩
  {!   !}
  ≡⟨ {!   !} ⟩
  {!   !}
  ≡⟨ {!   !} ⟩
  {!   !}
  ≡⟨ {!   !} ⟩
  {!   !} ∎
  
idl+o : ∀{Γ n} → plus $ num 0 $ num n ≡ num {Γ} n
idl+o {n = n} = plusβ {n = 0}

idr+o : ∀{Γ n} → plus $ num n $ num 0 ≡ num {Γ} n
idr+o {n = n} = plusβ {n = n} ◾ cong num idr+

-- GYAKORLATRÓL FELADAT: times, Definiáld azt a függvényt, amely két számot összeszoroz.
times : {Γ : Con} → Tm Γ (Nat ⇒ Nat ⇒ Nat)
times = lam (lam (iteNat zeroo (plus $ v0 $ v2) v0))

times-test-1 : eval times 1 5 ≡ 5
times-test-1 = refl

times-test-2 : eval times 2 3 ≡ 6
times-test-2 = refl

times-test-3 : eval times zero 4 ≡ zero
times-test-3 = refl

times-test-4 : eval times 12 43 ≡ 516
times-test-4 = refl

-- FELADAT: Definiáld a hatványozás függvényét.
pow : ∀{Γ} → Tm Γ (Nat ⇒ Nat ⇒ Nat)
pow = lam (lam (iteNat (suco zeroo) (times $ v0 $ v2) v0))

pow-test-1 : eval pow 2 5 ≡ 32
pow-test-1 = refl

pow-test-2 : eval pow 3 3 ≡ 27
pow-test-2 = refl

pow-test-3 : eval pow 0 0 ≡ 1
pow-test-3 = refl

pow-test-4 : eval pow 0 5 ≡ 0
pow-test-4 = refl

pow-test-5 : eval pow 7 4 ≡ 2401
pow-test-5 = refl

-- FELADAT: Definiáld azt a függvényt az objektumnyelvben, amely
--          egy listányi számot összead.
sumList : ∀{Γ} → Tm Γ (List Nat ⇒ Nat)
sumList = lam (iteList zeroo (plus $ v0 $ v1) v0)

sumList-test-1 : let l = eval sumList (1 ∷ 4 ∷ 3 ∷ []) in l ≡ 8
sumList-test-1 = refl

sumList-test-2 : let l = eval sumList (5 ∷ 3 ∷ 10 ∷ 9 ∷ 0 ∷ []) in l ≡ 27
sumList-test-2 = refl

sumList-test-3 : let l = eval sumList [] in l ≡ 0
sumList-test-3 = refl

sumList-test-4 : let l = eval sumList (0 ∷ []) in l ≡ 0
sumList-test-4 = refl

sumList-test-5 : let l = eval sumList (10 ∷ 90 ∷ 11 ∷ 23 ∷ 45 ∷ 120 ∷ 87 ∷ []) in l ≡ 386
sumList-test-5 = refl

-- FELADAT: Bizonyítsd be az alábbi állítást a szintaxisban!
sumList-proof : ∀{Γ} → sumList $ (cons (num 2) (cons (num 3) (cons (num 1) nil))) ≡ num {Γ} 6
sumList-proof =
  lam (iteList zeroo  (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz))  (var vz)) $ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))
  ≡⟨ ⇒β ⟩
  iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz $ var (vs vz)) (var vz) [ ⟨ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ iteList[] ⟩
  iteList (zeroo [ ⟨ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]) ((lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $  var vz  $ var (vs vz)) [ (⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺) ⁺ ]) (var vz [ ⟨ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ])
  ≡⟨ cong₃ (λ x y z → iteList x y z) zero[] $[] vz[⟨⟩] ⟩
  iteList zeroo ((lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $  var vz) [ (⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺) ⁺ ] $ var (vs vz) [ (⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺) ⁺ ]) (cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong₂ (λ x y → iteList zeroo (x $ y) (cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) $[] vs[⁺] ⟩
  iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) [ (⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺) ⁺ ] $ var vz [ (⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺) ⁺ ] $ var vz [ ⟨ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ⁺ ] [ p ])(cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong (λ x → iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) [ (⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺) ⁺ ] $ x $ var vz [ ⟨ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ⁺ ] [ p ]) (cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) vz[⁺] ⟩
  iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) [  (⟨   cons (suco (suco zeroo))   (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))   ⟩   ⁺)  ⁺  ]  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong (λ x → iteList zeroo (x $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) lam[] ⟩
  iteList zeroo (lam  (lam (iteNat (var vz) (suco (var vz)) (var (vs vz))) [   ((⟨     cons (suco (suco zeroo))     (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))     ⟩     ⁺)    ⁺)   ⁺   ])  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong (λ x → iteList zeroo (lam  (x)  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) lam[] ⟩
  iteList zeroo (lam  (lam   (iteNat (var vz) (suco (var vz)) (var (vs vz)) [    (((⟨       cons (suco (suco zeroo))       (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))       ⟩       ⁺)      ⁺)     ⁺)    ⁺    ]))  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong (λ x → iteList zeroo (lam  (lam   (x))  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) iteNat[] ⟩
  iteList zeroo (lam  (lam   (iteNat    (var vz [     (((⟨        cons (suco (suco zeroo))        (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))        ⟩        ⁺)       ⁺)      ⁺)     ⁺     ])    (suco (var vz) [     ((((⟨         cons (suco (suco zeroo))         (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))         ⟩         ⁺)        ⁺)       ⁺)      ⁺)     ⁺     ])    (var (vs vz) [     (((⟨        cons (suco (suco zeroo))        (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))        ⟩        ⁺)       ⁺)      ⁺)     ⁺     ])))  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong₃ (λ x y z → iteList zeroo (lam  (lam   (iteNat    (x)    (y)    (z)))  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) vz[⁺] suc[] vs[⁺] ⟩
  iteList zeroo (lam  (lam   (iteNat (var vz)    (suco     (var vz [      ((((⟨          cons (suco (suco zeroo))          (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))          ⟩          ⁺)         ⁺)        ⁺)       ⁺)      ⁺      ]))    (var vz [     ((⟨       cons (suco (suco zeroo))       (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))       ⟩       ⁺)      ⁺)     ⁺     ]     [ p ])))  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong (λ x → iteList zeroo (lam  (lam   (iteNat (var vz)    (suco     (x))    (var vz [     ((⟨       cons (suco (suco zeroo))       (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))       ⟩       ⁺)      ⁺)     ⁺     ]     [ p ])))  $ var vz  $  var vz [  ⟨  cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]  [ p ]) (cons (suco (suco zeroo))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) vz[⁺] ⟩
  iteList zeroo(lam (lam  (iteNat (var vz) (suco (var vz))   (var vz [    ((⟨      cons (suco (suco zeroo))      (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))      ⟩      ⁺)     ⁺)    ⁺    ]    [ p ]))) $ var vz $ var vz [ ⟨ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ⁺ ] [ p ])(cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong (λ x → iteList zeroo(lam (lam  (iteNat (var vz) (suco (var vz))   (x    [ p ]))) $ var vz $ var vz [ ⟨ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ⁺ ] [ p ])(cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) vz[⁺] ⟩
  iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var vz [ p ]))) $ var vz $ var vz [ ⟨ cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ⁺ ] [ p ])(cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong (λ x → iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var vz [ p ]))) $ var vz $ x [ p ]) (cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) vz[⁺] ⟩
  iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var vz [ p ]))) $  var vz $ var vz [ p ]) (cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ cong (λ x → iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (x))) $  var vz $ var vz [ p ]) (cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))) [p] ⟩
  iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz $ var vz [ p ]) (cons (suco (suco zeroo)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)))
  ≡⟨ Listβ₂ ⟩
  (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz $ var vz [ p ]) [ ⟨ suco (suco zeroo) ⟩ ⁺ ] [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong (λ x → x [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]) $[] ⟩
  ((lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $   var vz)  [ ⟨ suco (suco zeroo) ⟩ ⁺ ]  $ var vz [ p ] [ ⟨ suco (suco zeroo) ⟩ ⁺ ]) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong₂ (λ x y → (x  $ y [ ⟨ suco (suco zeroo) ⟩ ⁺ ]) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]) $[] [p] ⟩
  (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) [  ⟨ suco (suco zeroo) ⟩ ⁺ ]  $ var vz [ ⟨ suco (suco zeroo) ⟩ ⁺ ]  $ var (vs vz) [ ⟨ suco (suco zeroo) ⟩ ⁺ ]) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong₃ ((λ x y z → (x $ y  $ z) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ])) lam[] vz[⁺] vs[⁺] ⟩
  (lam  (lam (iteNat (var vz) (suco (var vz)) (var (vs vz))) [   (⟨ suco (suco zeroo) ⟩ ⁺) ⁺ ])  $ var vz  $ var vz [ ⟨ suco (suco zeroo) ⟩ ] [ p ]) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong₂ (λ x y → (lam  (x)  $ var vz  $ y [ p ]) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]) lam[] vz[⟨⟩] ⟩
  (lam  (lam   (iteNat (var vz) (suco (var vz)) (var (vs vz)) [    ((⟨ suco (suco zeroo) ⟩ ⁺) ⁺) ⁺ ]))  $ var vz  $ suco (suco zeroo) [ p ]) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var vz [ p ]) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong₃ (λ x y z → (lam  (lam   x)  $ var vz  $ y) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ z) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]) iteNat[] suc[] [p] ⟩
  (lam  (lam   (iteNat (var vz [ ((⟨ suco (suco zeroo) ⟩ ⁺) ⁺) ⁺ ])    (suco (var vz) [ (((⟨ suco (suco zeroo) ⟩ ⁺) ⁺) ⁺) ⁺ ])    (var (vs vz) [ ((⟨ suco (suco zeroo) ⟩ ⁺) ⁺) ⁺ ])))  $ var vz  $ suco (suco zeroo [ p ])) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong₃ (λ x y z → (lam  (lam   (iteNat x    y    z))  $ var vz  $ suco (suco zeroo [ p ])) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]) vz[⁺] suc[] vs[⁺] ⟩
  (lam  (lam   (iteNat (var vz)    (suco (var vz [ (((⟨ suco (suco zeroo) ⟩ ⁺) ⁺) ⁺) ⁺ ]))    (var vz [ (⟨ suco (suco zeroo) ⟩ ⁺) ⁺ ] [ p ])))  $ var vz  $ suco (suco zeroo [ p ])) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong₃ (λ x y z → (lam  (lam   (iteNat (var vz)    (suco (x))    (y [ p ])))  $ var vz  $ suco (z)) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]) vz[⁺] vz[⁺] suc[] ⟩
  (lam (lam (iteNat (var vz) (suco (var vz)) (var vz [ p ]))) $  var vz  $ suco (suco (zeroo [ p ]))) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong₂ (λ x y → (lam (lam (iteNat (var vz) (suco (var vz)) (x))) $  var vz  $ suco (suco (y))) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]) [p] zero[] ⟩
  (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ suco (suco zeroo)) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ $[] ⟩
  (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $  var vz) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ] $ suco (suco zeroo) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ]
  ≡⟨ cong₂ (λ x y →  x $ y) $[] suc[] ⟩
  lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ] $ var vz [ ⟨ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) ⟩ ] $ suco (suco zeroo [  ⟨  iteList zeroo  (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz   $ var (vs vz))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ])
  ≡⟨ cong₃ (λ x y z → x $ y $ suco (z)) lam[] vz[⟨⟩] suc[] ⟩
  lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz))) [  ⟨  iteList zeroo  (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz   $ var (vs vz))  (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))  ⟩  ⁺  ]) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco  (zeroo [   ⟨   iteList zeroo   (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz    $ var (vs vz))   (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))   ⟩   ]))
  ≡⟨ cong₂ ((λ x y →  lam (x) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco  (y)))) lam[] zero[] ⟩
  lam (lam  (iteNat (var vz) (suco (var vz)) (var (vs vz)) [   (⟨    iteList zeroo    (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz     $ var (vs vz))    (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))    ⟩    ⁺)   ⁺   ])) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)
  ≡⟨ cong (λ x →  lam (lam  (x)) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)) iteNat[] ⟩
  lam (lam  (iteNat   (var vz [    (⟨     iteList zeroo     (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz      $ var (vs vz))     (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))     ⟩     ⁺)    ⁺    ])   (suco (var vz) [    ((⟨      iteList zeroo      (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz       $ var (vs vz))      (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))      ⟩      ⁺)     ⁺)    ⁺    ])   (var (vs vz) [    (⟨     iteList zeroo     (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz      $ var (vs vz))     (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))     ⟩     ⁺)    ⁺    ]))) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)
  ≡⟨ cong₃ (λ x y z → lam (lam  (iteNat   (x)   (y)   (z))) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)) vz[⁺] suc[] vs[⁺] ⟩
  lam (lam  (iteNat (var vz)   (suco    (var vz [     ((⟨       iteList zeroo       (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz        $ var (vs vz))       (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))       ⟩       ⁺)      ⁺)     ⁺     ]))   (var vz [    ⟨    iteList zeroo    (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz     $ var (vs vz))    (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil))    ⟩    ⁺    ]    [ p ]))) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)
  ≡⟨ cong₂ (λ x y → lam (lam  (iteNat (var vz)   (suco    (x))   (y    [ p ]))) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)) vz[⁺] vz[⁺] ⟩
  lam (lam (iteNat (var vz) (suco (var vz)) (var vz [ p ]))) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)
  ≡⟨ cong (λ x → lam (lam (iteNat (var vz) (suco (var vz)) (x))) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)) [p] ⟩
  lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ iteList zeroo (lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ var vz  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)
  ≡⟨ cong (λ x → lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ iteList zeroo (x  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)) ⇒β ⟩
  lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ iteList zeroo (lam (iteNat (var vz) (suco (var vz)) (var (vs vz))) [ ⟨ var vz ⟩ ]  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)
  ≡⟨ cong (λ x → lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ iteList zeroo (x  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)) lam[] ⟩
  lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ iteList zeroo (lam  (iteNat (var vz) (suco (var vz)) (var (vs vz)) [ ⟨ var vz ⟩ ⁺ ])  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo)
  ≡⟨ cong {! λ x →  lam (lam (iteNat (var vz) (suco (var vz)) (var (vs vz)))) $ iteList zeroo (lam  (x)  $ var (vs vz)) (cons (suco (suco (suco zeroo))) (cons (suco zeroo) nil)) $ suco (suco zeroo) !} {!   !} ⟩
  {!   !}
  ≡⟨  ⟩
  -- {!   !}
  ≡⟨ {!   !} ⟩
  {!   !}
  ≡⟨ {!   !} ⟩
  {!   !} ∎

-- NEHÉZ FELADAT: Definiáld a listák másik iterátorát, amely bal oldalról hajtja végre a műveletet, nem jobbról, mint az iteList.
iteListL : ∀{Γ A B} → Tm Γ B → Tm (Γ ▹ B ▹ A) B → Tm Γ (List A) → Tm Γ B
iteListL = {!   !}

foldl-test-1 : eval (iteListL (num 2) (pow $ v1 $ v0) (cons (num 3) (cons (num 4) nil))) ≡ 4096
foldl-test-1 = refl

-- Bizonyítsd az iteListL elimináló szabályait.
ListLβ₁ : ∀{Γ A B}{u : Tm Γ B}{v : Tm (Γ ▹ B ▹ A) B} → iteListL u v nil ≡ u
ListLβ₁ = {!   !}

ListLβ₂ : ∀{Γ A B}{u : Tm Γ B}{v : Tm (Γ ▹ B ▹ A) B}{t₁ : Tm Γ A}{t : Tm Γ (List A)} →
               iteListL u v (cons t₁ t) ≡ iteListL (v [ ⟨ u ⟩ ⁺ ] [ ⟨ t₁ ⟩ ]) v t
ListLβ₂ = {!   !}

iteListL[]  : ∀{Γ A B}{u : Tm Γ B}{v : Tm (Γ ▹ B ▹ A) B}{t : Tm Γ (List A)}{Δ}{γ : Sub Δ Γ} →
               iteListL u v t [ γ ] ≡ iteListL (u [ γ ]) (v [ γ ⁺ ⁺  ]) (t [ γ ])
iteListL[] = {!   !}

-- GYAKORLATRÓL FELADAT: Definiáld azt a függvényt, amely két listát összefűz.
++ : {Γ : Con}{A : Ty} → Tm Γ (List A ⇒ List A ⇒ List A)
++ = {!   !}

++-test-1 : eval (++ $ nil {A = Bool} $ nil {A = Bool}) ≡ []
++-test-1 = refl

++-test-2 : eval (++ $ nil $ (cons trivial nil)) ≡ mk triv ∷ []
++-test-2 = refl

++-test-3 : eval (++ $ (cons zeroo nil) $ (cons (suco zeroo) nil)) ≡
                zero ∷ 1 ∷ []
++-test-3 = refl

-- FELADAT: Definiáld azt a függvényt, amely listák listáját összefűzi
concat : ∀{Γ A} → Tm Γ (List (List A) ⇒ List A)
concat = {!   !}

concat-test-1 : eval (concat {A = Nat}) ((1 ∷ 2 ∷ []) ∷ (3 ∷ []) ∷ [] ∷ (4 ∷ 5 ∷ 6 ∷ []) ∷ []) ≡ 1 ∷ 2 ∷ 3 ∷ 4 ∷ 5 ∷ 6 ∷ []
concat-test-1 = refl

concat-test-2 : eval (concat {A = Nat}) ((2 ∷ []) ∷ (30 ∷ []) ∷ (1 ∷ 20 ∷ []) ∷ []) ≡ 2 ∷ 30 ∷ 1 ∷ 20 ∷ []
concat-test-2 = refl

-- FELADAT: Definiáld azt a függvényt, amely egy fát a preorder bejárásnak megfelelően alakít át listává.
preorder : ∀{Γ A} → Tm Γ (Tree A ⇒ List A)
preorder = {!   !}