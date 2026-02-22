{-# OPTIONS --prop --rewriting #-}

module hf07-1 where

open import Lib

-- A feladatok lentebb kezdődnek a "tms" modulnál.

module Substitutions where
  import RazorWT
  import DefWT
  module NB = RazorWT.I
  module D = DefWT.I
  
  NB→D : RazorWT.Model
  NB→D = record
    { Ty     = D.Ty
    ; Tm     = D.Tm D.◇
    ; Nat    = D.Nat
    ; Bool   = D.Bool
    ; true   = D.true
    ; false  = D.false
    ; ite    = D.ite
    ; num    = D.num
    ; isZero = D.isZero
    ; _+o_   = D._+o_
    }

  module NBTD = RazorWT.Model NB→D

  data NBCon : Set where
    NB◇ : NBCon
    _NB▹_ : NBCon → NB.Ty → NBCon

  {-# DISPLAY NB◇ = D.◇ #-}
  {-# DISPLAY _NB▹_ = D._▹_ #-}

  infixl 5 _,o_
  data NBEnv : NBCon → Set where
    ε   : NBEnv NB◇
    _,o_ : {Γ : NBCon} {A : NB.Ty} → NBEnv Γ → NB.Tm A → NBEnv (Γ NB▹ A)

  D→NB : DefWT.Model {k = lzero}
  D→NB = record
    { Ty     = NB.Ty
    ; Nat    = NB.Nat
    ; Bool   = NB.Bool
    ; Con    = NBCon
    ; ◇      = NB◇
    ; _▹_    = _NB▹_
    ; Var    = λ Γ A → NBEnv Γ → NB.Tm A
    ; vz     = λ where (_ ,o a) → a
    ; vs     = λ where v (e ,o _) → v e
    ; Tm     = λ Γ A → NBEnv Γ → NB.Tm A
    ; var    = λ v → v
    ; def    = λ t f e → f (e ,o t e)
    ; true   = λ _ → NB.true
    ; false  = λ _ → NB.false
    ; ite    = λ co tr fa e → NB.ite (co e) (tr e) (fa e)
    ; num    = λ n _ → NB.num n
    ; isZero = λ t e → NB.isZero (t e)
    ; _+o_   = λ l r e → l e NB.+o r e
    }

  module DTNB = DefWT.Model D→NB

  norm : {A : D.Ty} → D.Tm D.◇ A → RazorWT.St.⟦ (DTNB.⟦ A ⟧T) ⟧T
  norm t = RazorWT.St.⟦ DTNB.⟦ t ⟧t ε ⟧t

  eval : {Γ : D.Con} {A : D.Ty} → D.Tm Γ A → NBEnv DTNB.⟦ Γ ⟧C → RazorWT.St.⟦ (DTNB.⟦ A ⟧T) ⟧T
  eval t e = RazorWT.St.⟦ DTNB.⟦ t ⟧t e ⟧t

  Env : D.Con → Set
  Env Γ = NBEnv DTNB.⟦ Γ ⟧C

  module tms where
    open D

    -- Példa:
    -- let y := x +o num 10 in 
    --     ite (isZero y) 
    --         (let z := isZero a in a +o y +o b)
    --         ((let c := y in c +o y +o a) +o b)
    -- Lehető legáltalánosabb típusú!
    tm-8 : ∀{Γ A} → Tm (Γ ▹ Nat ▹ A ▹ Nat ▹ Nat) Nat
    tm-8 = def 
          (v1 +o num 10) 
          (ite 
            (isZero v0) 
            (def 
              (isZero v1) 
              (v2 +o v1 +o v 5)) 
              -- lett egy általános v függvény, ezért így is használható.
              -- credits to Török Bálint Bence, BSc hallgató.
            (def 
              v0 
              (v0 +o v1 +o v2)
            +o v4))
    
    -- ite a b (let x := ite a (num 0) (num 1) in b +o x)
    tm-9 : ∀{Γ} → Tm (Γ ▹ Bool ▹ Nat) Nat
    tm-9 = ite v1 v0 (def (ite v1 (num 0) (num 1)) (v1 +o v0))

    -- Shadowing a let-in-es világban létezik.
    -- A De-Bruijn indexelés ezt a problémát megoldja, nincs shadowing,
    -- csak jól is kell kezelni.
    -- (let x := x +o y in x +o y) +o (let y := x +o y in x +o y)
    tm-10 : ∀{Γ} → Tm (Γ ▹ Nat ▹ Nat) Nat
    tm-10 = def (v1 +o v0) (v0 +o v1) +o def (v1 +o v0) (v2 +o v0)

    -- isZero (x +o let x := (let x := x in x +o x) in x +o x)
    tm-11 : ∀{Γ} → Tm (Γ ▹ Nat) Bool
    tm-11 = isZero (v0 +o def (def v0 (v0 +o v0)) (v0 +o v0))

    -- isZero (y +o let x := (let x := y in x +o y) in x +o y)
    tm-12 : ∀{Γ} → Tm (Γ ▹ Nat ▹ Nat) Bool
    tm-12 = isZero (v1 +o def (def v1 (v0 +o v2)) (v0 +o v2))

    {-
    x - v0
    b - v1
    let a := num 2 +o x in
      ite (let b := a +o x in isZero (b +o x))
          (let b := (let b := a in b +o x) in b +o a)
          (let c := num 10 +o x in let d := x +o c in a +o b +o c +o d)
    -}
    tm-13 : ∀{Γ} → Tm (Γ ▹ Nat ▹ Nat) Nat
    tm-13 = def 
      (num 2 +o v0) 
      (ite 
        (def (v0 +o v1) (isZero (v0 +o v2))) 
        (def (def v0 (v0 +o v2)) (v0 +o v1)) 
        (def (num 10 +o v1) (def (v2 +o v0) (v2 +o v4 +o v1 +o v0))))

    {-
    x - v0 Bool
    y - v1 Nat
    a - v2 Nat
    b - v3 Nat

    ite
      x
      (let a := y +o num 1 in ite (isZero a) (num 5) a)
      (let a := y +o y in a +o y)
    +o 
    ite 
      (isZero y)
      (let a := (let b := a +o num 1 in b +o a) in a +o b)
      (let a := a +o num 1 in let b := a +o b in a +o b)
    -}
    tm-14 : ∀{Γ} → Tm (Γ ▹ Nat ▹ Nat ▹ Nat ▹ Bool) Nat
    tm-14 = ite 
        v0 
        (def (v1 +o num 1) (ite (isZero v0) (num 5) v0)) 
        (def (v1 +o v1) (v0 +o v2)) 
      +o ite 
        (isZero v1) 
        (def (def (v2 +o (num 1)) (v0 +o v3)) (v0 +o v4)) 
        (def (v2 +o (num 1)) (def (v0 +o v4) (v1 +o v0)))

    {-
    x - v0 Nat
    e - v1 A
    c - v2 A
    d - v3 A
    let a := true in let b := isZero x in
    ite b (ite a c d) e
    -}
    tm-15 : ∀{Γ A} → Tm (Γ ▹ A ▹ A ▹ A ▹ Nat) A
    tm-15 = def true (def (isZero v1) (ite v0 (ite v1 v4 (v 5)) v3))

    {-
    x - v0 Nat
    d - v1 A
    e - v2 A
    f - v3 A
    y - v4 A

    let a := false in let b := isZero x in
    ite
      a
      (let c := ite b a true in ite c d e)
      (let c := ite b a true in ite c f y)
    -}
    tm-16 : ∀{Γ A} → Tm (Γ ▹ A ▹ A ▹ A ▹ A ▹ Nat) A
    tm-16 = 
      def 
        false 
        (def 
          (isZero v1) 
          (ite 
            v1 
            (def (ite v0 v1 true) (ite v0 v4 (v 5))) 
            (def (ite v0 v1 true) (ite v0 (v 6) (v 7)))))

  module envs where
    open D using (◇ ; _▹_ ; Nat ; Bool)
    open NB

    -- Példa tm-8-hoz úgy, hogy a lentebbi tests részben a hozzátartozó egyenlőség
    -- teljesüljön.

    -- \Ge = \epsilon = ε
    {-         Nincs használva, szabadon választott,
                      lehetne Nat is.
                               |
                    kötelező   |     köt.  köt.
                        ---   ----   ---   ---                   -}
    env-tm-8 : Env (◇ ▹ Nat ▹ Bool ▹ Nat ▹ Nat)
    --              -
    --          Ide mindig az üres környezetet kell írni, azzal kell kezdeni;
    --          mivel még nincsenek rendes behelyettesítéseink,
    --          ennél jobb nincs.
    env-tm-8 = ε ,o num 0 ,o true ,o num 2 ,o num 6
    --         ------------------------------------
    --         Szabadon megválogatott értékek úgy, hogy
    --         a lenti test-tm-8 kijöjjön.
    --         Itt nagyon sok jó megoldás lehetséges.

    env-tm-9 : Env (◇ ▹ Bool ▹ Nat)
    env-tm-9 = ε ,o true ,o num 5
    
    env-tm-10 : Env (◇ ▹ Nat ▹ Nat)
    env-tm-10 = ε ,o num 5 ,o num 4

    -- Ugyanazon tm-11-hez két különböző környezet kell,
    -- hogy két különböző eredményt kapjunk.
    env-tm-11 : Env (◇ ▹ Nat)
    env-tm-11 = ε ,o num 0
    
    env-tm-11' : Env (◇ ▹ Nat)
    env-tm-11' = ε ,o num 1
    
    env-tm-12 : Env (◇ ▹ Nat ▹ Nat)
    env-tm-12 = ε ,o num 1 ,o num 1

    env-tm-13 : Env (◇ ▹ Nat ▹ Nat)
    env-tm-13 = ε ,o num 6 ,o num 1

    env-tm-14 : Env (◇ ▹ Nat ▹ Nat ▹ Nat ▹ Bool)
    env-tm-14 = ε ,o num 6 ,o num 4 ,o num 3 ,o true

    -- tm-15-höz két környezet kell, hogy különböző eredményt kapjunk.
    env-tm-15 : Env (◇ ▹ Nat ▹ Nat ▹ Nat ▹ Nat)
    env-tm-15 = ε ,o num 6 ,o num 4 ,o num 15 ,o num 1

    env-tm-15' : Env (◇ ▹ Bool ▹ Bool ▹ Bool ▹ Nat)
    env-tm-15' = ε ,o true ,o true ,o false ,o num 1

    -- tm-16-hoz két környezet kell, hogy különböző eredményt kapjunk.
    env-tm-16 : Env (◇ ▹ Nat ▹ Nat ▹ Nat ▹ Nat ▹ Nat)
    env-tm-16 = ε ,o num 10 ,o num 0 ,o num 0 ,o num 0 ,o num 0

    env-tm-16' : Env (◇ ▹ Bool ▹ Bool ▹ Bool ▹ Bool ▹ Nat)
    env-tm-16' = ε ,o true ,o true ,o true ,o true ,o num 0
    
  module tests where
    open tms
    open envs
    open D using (◇ ; _▹_ ; Nat ; Bool)
    open NB

    {-
    A +/- olyan lesz, hogy próbálok minél kevesebbet lelőni,
    hogy mi lesz a megoldás. Ebből kifolyólag a tm-n-ek esetén,
    amikor a lehető legáltalánosabban kell megadni a típusokat,
    akkor paramétereket kellhet felvenni mind a kontextusra, mind
    egy-egy típusokra, ha azok nincsenek felhasználva.
    Így a tesztek ha sárgák maradnak, akkor a tm-n-es kifejezéseknek
    szintén át kell adni paramétereket. Kontextus esetén az üres környezetet (◇),
    típus esetén tetszőleges típust, ami a nyelvben van.
    -}
    {-
                Ebben az esetben ezt át kell adni,
                tehát a tesztet ki kell egészíteni, hogy ne
                sárguljon. A lényeg, hogy ez egyezik az env-ben
                átadott tetszőlegesen választott típussal.
                                 |                          -}
    test-tm-8 : eval (tm-8 {◇} {Bool}) env-tm-8 ≡ 30
    test-tm-8 = refl

    test-tm-9 : eval (tm-9 {◇}) env-tm-9 ≡ 5
    test-tm-9 = refl

    test-tm-10 : eval (tm-10 {◇}) env-tm-10 ≡ 27
    test-tm-10 = refl

    test-tm-11 : eval (tm-11 {◇}) env-tm-11 ≡ tt
    test-tm-11 = refl

    test-tm-11' : eval (tm-11 {◇}) env-tm-11' ≡ ff
    test-tm-11' = refl

    test-tm-12 : eval (tm-12 {◇}) env-tm-12 ≡ ff
    test-tm-12 = refl

    test-tm-13 : eval (tm-13 {◇}) env-tm-13 ≡ 32
    test-tm-13 = refl

    test-tm-14 : eval (tm-14 {◇}) env-tm-14 ≡ 20
    test-tm-14 = refl

    test-tm-15 : eval (tm-15 {◇} {Nat}) env-tm-15 ≡ 15
    test-tm-15 = refl

    test-tm-15' : eval (tm-15 {◇} {Bool}) env-tm-15' ≡ ff
    test-tm-15' = refl
    
    test-tm-16 : eval (tm-16 {◇} {Nat}) env-tm-16 ≡ 10
    test-tm-16 = refl

    test-tm-16' : eval (tm-16 {◇} {Bool}) env-tm-16' ≡ tt
    test-tm-16' = refl