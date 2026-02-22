{-# OPTIONS --prop --rewriting #-}

module gy06-1 where

open import Lib

module injectivity where

  module NatBool where
    open import Razor hiding (St)

    -- standard model
    St : Model
    Model.Ty St = Set
    Model.Tm St = λ s → s
    Model.Nat St = ℕ
    Model.Bool St = 𝟚
    Model.true St = tt
    Model.false St = ff
    Model.ite St = if_then_else_
    Model.num St n = n
    Model.isZero St zero = tt
    Model.isZero St (suc n) = ff
    Model._+o_ St a b = a + b
    Model.iteβ₁ St = refl
    Model.iteβ₂ St = refl
    Model.isZeroβ₁ St = refl
    Model.isZeroβ₂ St = refl
    Model.+β St = refl

    module St = Model St

    module equations where
      open St

      -- a standard modellben az eq-0...eq-12 egyenlosegek definicio szerint teljesulnek (a metaelmeletbol kovetkeznek)
      -- pl.
      eq-4 : isZero (num 3 +o num 1) ≡ false
      eq-4 = refl

      eq-6 : ite true (isZero (num 0)) false ≡ true
      eq-6 = refl

      eq-7 : (num 3 +o num 0) +o num 1 ≡ num 4
      eq-7 = refl

      eq-8 : ite (isZero (num 0)) (num 1 +o num 1) (num 0) ≡ num 2
      eq-8 = refl
      
      eq-9 : num 3 +o ite (isZero (num 2)) (num 1) (num 0) ≡ num 3
      eq-9 = refl

    open I

    -- bizonyitsd be, hogy Razor.I.num injektiv!
    numInj : ∀{m n} → num m ≡ num n → m ≡ n
    numInj e = cong St.⟦_⟧t e -- hasznald az St-be valo kiertekelest!

    1≢2 : 1 ≢ 2 -- ¬ (1 ≡ 2) | \==n : ≢
    1≢2 ()

    42≠69 : 42 ≢ 69
    42≠69 ()

    -- bizonyitsd be, hogy Razor.I.isZero nem injektiv!
    notInj : ¬ ((t t' : Tm Nat) → isZero t ≡ isZero t' → t ≡ t')
    notInj e = 42≠69 (numInj  (e (num 42) (num 69) (isZeroβ₂ ◾ isZeroβ₂ ⁻¹))) -- hasznald a num injektivitasat ill. az isZeroβ₂-t!

    -- Mndunk ket szamot amire ff-t add vissza az isZero
    -- isZeroβ₂ num-ra alakitunk
    -- numInj segitsegevel kivesszuk ℕ szamokat
    -- definialunk egy 42≠69 bizonyitast, ami a metaelmelet szerint nem egyenlo

module normalisation where

  -- ⌜norm t⌝ = t
  -- norm ⌜nf⌝ = nf

  open import Razor
  open I

  eq-4 : isZero (num 3 +o num 1) ≡ false
  eq-4 = comp ⁻¹

  eq-6 : ite true (isZero (num 0)) false ≡ true
  eq-6 = comp ⁻¹

  eq-7 : (num 3 +o num 0) +o num 1 ≡ num 4
  eq-7 = comp ⁻¹

  eq-8 : ite (isZero (num 0)) (num 1 +o num 1) (num 0) ≡ num 2
  eq-8 = comp ⁻¹
      
  eq-9 : num 3 +o ite (isZero (num 2)) (num 1) (num 0) ≡ num 3
  eq-9 = comp ⁻¹

  -- A nyelv teljes - mindent letudok normalizalni es vissza jutok
  -- comp kierteleki a standard modelt a syntaxbol majd visszater a syntax-ban

module integers where

  open import Int hiding (N; SucNf; PredNf; ⌜_⌝; norm; testnorm; stab; ⌜Suc⌝; ⌜Pred⌝; Comp; comp)
  open I
  {-
  data ℤ : Set where
    Zero : ℤ
    Suc : ℤ → ℤ
    Pred : ℤ → ℤ
  SucPred : (z : ℤ) → Suc (Pred z) ≡ z
  PredSuc : (z : ℤ) → Pred (Suc z) ≡ z
  -}
  one one' : Z
  one  = Suc I.Zero
  one' = Suc (Pred (Suc I.Zero))

  one= : one ≡ one'
  one= = cong Suc (PredSuc I.Zero ⁻¹)
  
  one=' : one ≡ one'
  one=' = SucPred (Suc I.Zero) ⁻¹
  
  -2' -2'' : Z
  -2'  = Pred (Pred I.Zero)
  -2'' = Pred (Suc (Pred (Suc (Pred (Suc (Pred (Pred I.Zero)))))))

  -2= : -2' ≡ -2''
  -2= = 
    Pred (Pred I.Zero)
    ≡⟨ PredSuc (Pred (Pred I.Zero)) ⁻¹ ⟩ 
    Pred (Suc (Pred (Pred I.Zero)))
    ≡⟨ PredSuc (Pred (Suc (Pred (Pred I.Zero)))) ⁻¹ ⟩ 
    Pred (Suc (Pred (Suc (Pred (Pred I.Zero)))))
    ≡⟨ PredSuc (Pred (Suc (Pred (Suc (Pred (Pred I.Zero)))))) ⁻¹ ⟩ 
    Pred (Suc (Pred (Suc (Pred (Suc (Pred (Pred I.Zero))))))) ∎

  -- nezd meg, mi az, hogy Model:
  Model' = Model

  -- nezd meg, mik a normal formak:
  Nf' = Nf
  
  {-
  data ℤNf : Set where
    Zero : ℤNf
    +Suc : ℕ → ℤNf
    -Suc : ℕ → ℤNf

  -1 = -Suc 0
  1 = +Suc 0
  -}
  ⌜_⌝ : Nf → I.Z -- \cul : ⌜ | \cur : ⌝
  ⌜ -Suc zero     ⌝ = I.Pred I.Zero
  ⌜ -Suc (suc n)  ⌝ = I.Pred ⌜ -Suc n ⌝
  ⌜ Zero          ⌝ = I.Zero
  ⌜ +Suc zero     ⌝ = I.Suc I.Zero
  ⌜ +Suc (suc n)  ⌝ = I.Suc ⌜ +Suc n ⌝

  SucNf : Nf → Nf
  SucNf (-Suc 0) = Nf.Zero
  SucNf (-Suc (suc x)) = -Suc x
  SucNf Nf.Zero = +Suc 0
  SucNf (+Suc x) = +Suc (suc x)

  PredNf : Nf → Nf
  PredNf (-Suc x) = -Suc (suc x)
  PredNf Nf.Zero = -Suc 0
  PredNf (+Suc 0) = Nf.Zero
  PredNf (+Suc (suc x)) = +Suc x

  -- egy normal formakbol allo modell
  N : Model
  N = record
    { Z       = Nf
    ; Zero    = Nf.Zero
    ; Suc     = SucNf
    ; Pred    = PredNf
    ; SucPred = λ {(-Suc x) → refl
                 ; Nf.Zero → refl
                 ; (+Suc zero) → refl
                 ; (+Suc (suc x)) → refl}
    ; PredSuc = λ {(-Suc zero) → refl
                 ; (-Suc (suc x)) → refl
                 ; Nf.Zero → refl
                 ; (+Suc x) → refl}
    }
  module N = Model N

  norm : I.Z → Nf
  norm = N.⟦_⟧

  testnorm1 : norm one ≡ norm one'
  testnorm1 = refl
  testnorm2 : norm -2' ≡ norm -2''
  testnorm2 = refl
  testnorm3 :  ⌜ norm (I.Pred (I.Pred (I.Suc (I.Pred (I.Pred (I.Pred (I.Suc I.Zero))))))) ⌝ ≡
              I.Pred (I.Pred (I.Pred I.Zero))
  testnorm3 = refl

  stab : (v : Nf) → norm ⌜ v ⌝ ≡ v
  stab (-Suc zero) = refl
  stab (-Suc (suc x)) = 
    PredNf (norm ⌜ -Suc x ⌝) 
    ≡⟨ cong PredNf (stab (-Suc x)) ⟩
    -Suc (suc x) ∎
  stab Nf.Zero = refl
  stab (+Suc zero) = refl
  stab (+Suc (suc x)) = cong SucNf (stab (+Suc x))

  ⌜Suc⌝ : (v : Nf) → ⌜ SucNf v ⌝ ≡ I.Suc ⌜ v ⌝
  ⌜Suc⌝ (-Suc zero) = SucPred I.Zero ⁻¹
  ⌜Suc⌝ (-Suc (suc x)) = SucPred ⌜ -Suc x ⌝ ⁻¹
  ⌜Suc⌝ Nf.Zero = refl
  ⌜Suc⌝ (+Suc _) = refl

  ⌜Pred⌝ : (v : Nf) → ⌜ PredNf v ⌝ ≡ I.Pred ⌜ v ⌝
  ⌜Pred⌝ (-Suc x) = refl
  ⌜Pred⌝ Nf.Zero = refl
  ⌜Pred⌝ (+Suc zero) = PredSuc _ ⁻¹
  ⌜Pred⌝ (+Suc (suc x)) = PredSuc _ ⁻¹

  Comp : DepModel
  Comp = record
    { Z∙       = λ i → Lift (⌜ norm i ⌝ ≡ i)
    ; Zero∙    = mk refl
    ; Suc∙     = λ where {i} (mk x) → mk (⌜Suc⌝ N.⟦ i ⟧ ◾ cong Suc x)
    ; Pred∙    = λ where {i} (mk x) → mk (⌜Pred⌝ N.⟦ i ⟧ ◾ cong Pred x)
    ; SucPred∙ = {!   !}
    ; PredSuc∙ = {!   !}
    }
  module Comp = DepModel Comp

  comp : (i : I.Z) → ⌜ norm i ⌝ ≡ i
  comp i = un (Comp.⟦ i ⟧)

module ABT where
  open import DefABT
  open I

  {- Rewrite the following expressions with De Bruijn notation -}
  -- Valtozok
  -- def (num 1) v0 = num 1
  -- def (num 1) (def (num 2) (v0 +o v1)) // v0 to num 2, v1 to num 1
  -- Az indexek folyamatosan felfele csusznak -- a legkozelebbi amihez visszatudok menni az lesz az elso, majd
  -- def (num 1) (def (num 2) (def v0 (v0+v1+v2))) // v0 to v0, v1 to num 2, v2 to num 1

  {-
     let
     / \
  num 1 +o
        / \
    num 2  x
  -}
  
  -- De Bruijn index
  -- let x:=num 1 in let y:=num 2 in x +o y
  -- let (num 1) in let (num 2) in v1 +o v0
  
  -- let x:=num 1 in num 2 +o x
  -- def (num 1) (num 2 +o v0)

  -- let x:=num 1 +o ite (isZero (num 2)) (num 3) (num 4) in x +o x
  -- ?

  -- (let x:=num 2 in let y:=num 1 in x +o y)
  -- def (num 2) (def (num 1) (v1 + v0))

  -- +/- atiras

  private
    v' : (n : ℕ) → ∀{m} → Var (suc n + m)
    v' zero = vz
    v' (suc n) = vs (v' n)
  
  v : (n : ℕ) → ∀{m} → Tm (suc n + m)
  v n = var (v' n)
  
  -- (let x:=num 1 in x +o x)
  -- 
  tm-0 : Tm {!   !}
  tm-0 = {!   !}

  -- let x:=num 1 in 
  --  x +o let y:=x +o num 1 in
  --    y +o let z:=x +o y in
  --      (x +o z) +o (y +o x)
  tm-1 : Tm {!   !}
  tm-1 = {!   !}

  -- (let x:=num 1 in x) +o let y:=num 1 in 
  --   y +o let z:=x +o y in 
  --     (x +o z) +o (y +o x)
  tm-2 : Tm {!   !}
  tm-2 = {!   !}

  -- (let x:=num 1 in 
  --      x +o let y:=x +o num 1 in x) +o 
  --    let z:=num 1 in z +o z
  tm-3 : Tm {!   !}
  tm-3 = {!   !}

  -- ((let x:=num 1 in x) +o (let y:=num 1 in y)) +o let z:=num 1 in z +o z
  tm-4 : Tm {!   !}
  tm-4 = {!   !}

  -- let x:=(isZero true) in (ite x 0 x)
  tm-5 : Tm {!   !}
  tm-5 = {!   !}


  {- Rewrite the following expressions with variable names -}

  -- let x:=      1+2 in        (x+x)   + let    y:=3+4      in   y  + y
  t-1 : Tm {!   !}
  t-1 = {!   !}

  -- let x:=1+2 in (x+x) + let y:=3+4 in x + y
  t-1' : Tm {!   !}
  t-1' = {!   !}

  --    let x:=true in x   + let y:=x in y+x
  t-2 : Tm {!   !}
  t-2 = {!   !}

  --   let x:=true in let y:=false in ite y y x
  t-3 : Tm {!   !}
  t-3 = {!   !}

  --   true + let x:= true in false + let y:=x in x+y
  t-4 : Tm {!   !}
  t-4 = {!   !}

  --  let x:=true in let y:=false in let z:=true in let w:=false in (w +o z) +o (y +o x)
  t-5 : Tm {!   !}
  t-5 = {!   !}

  -- exercise 2.6

  zipWith : ∀{n}{A B C : Set} → (A → B → C) → Vec A n → Vec B n → Vec C n
  zipWith _ [] [] = []
  zipWith f (m :: ms) (n :: ns) = f m n :: zipWith f ms ns

  zip+ : ∀{n} → Vec ℕ n → Vec ℕ n → Vec ℕ n
  zip+ = zipWith _+_

  tail : ∀{n}{A : Set} → Vec A (suc n) → Vec A n
  tail (_ :: ms) = ms

  countVars' : ∀{n} → Tm n → Vec ℕ n -- var esetén tudni kell, hogy hova kell számolni.
  countVars' = {!   !}

  ttt : Tm 3
  --  ttt = v0
  ttt = (v0 +o v0) +o def v0 (v1 +o v2)

  alma = {!countVars' ttt!}