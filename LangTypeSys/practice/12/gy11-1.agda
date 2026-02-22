{-# OPTIONS --prop --rewriting #-}

module gy11-1 where

open import Lib

module I where
  infixl 6 _[_]
  infixl 5 _▹_
  infixl 8 _×o_
  infixl 8 ⟨_,o_⟩
  infixl 7 _+o_
  infixr 6 _⇒_
  infixl 5 _$_

  data Ty   : Set where
    Nat     : Ty
    Bool    : Ty
    _⇒_     : Ty → Ty → Ty
    _×o_     : Ty → Ty → Ty

  data Con  : Set where
    ◇       : Con
    _▹_     : Con → Ty → Con

  data Var : Con → Ty → Set where
    vz        : ∀{Γ A} → Var (Γ ▹ A) A
    vs        : ∀{Γ A B} → Var Γ A → Var (Γ ▹ B) A

  postulate
    Tm        : Con → Ty → Set

  data Sub : Con → Con → Set where
    p         : ∀{Γ A} → Sub (Γ ▹ A) Γ
    ⟨_⟩       : ∀{Γ A} → Tm Γ A → Sub Γ (Γ ▹ A)
    _⁺        : ∀{Γ Δ A} → (σ : Sub Δ Γ) → Sub (Δ ▹ A) (Γ ▹ A)

  postulate
    var       : ∀{Γ A} → Var Γ A → Tm Γ A
    _[_]      : ∀{Γ Δ A} → Tm Γ A → Sub Δ Γ → Tm Δ A
    [p]       : ∀{Γ A B x} → var {Γ}{A} x [ p {A = B} ] ≡ var (vs x)
    vz[⟨⟩]    : ∀{Γ A t} → var (vz {Γ}{A}) [ ⟨ t ⟩ ] ≡ t
    vz[⁺]     : ∀{Γ Δ A σ} → var (vz {Γ}{A}) [ σ ⁺ ] ≡ var (vz {Δ}{A})
    vs[⟨⟩]    : ∀{Γ A B x t} → var (vs {Γ}{A}{B} x) [ ⟨ t ⟩ ] ≡ var x
    vs[⁺]     : ∀{Γ Δ A B x σ} → var (vs {Γ}{A}{B} x) [ σ ⁺ ] ≡ var x [ σ ] [ p {Δ} ]

    true      : ∀{Γ} → Tm Γ Bool
    false     : ∀{Γ} → Tm Γ Bool
    ite       : ∀{Γ A} → Tm Γ Bool → Tm Γ A → Tm Γ A → Tm Γ A
    iteβ₁     : ∀{Γ A u v} → ite {Γ}{A} true  u v ≡ u
    iteβ₂     : ∀{Γ A u v} → ite {Γ}{A} false u v ≡ v
    true[]    : ∀{Γ Δ σ} → true  {Γ} [ σ ] ≡ true  {Δ}
    false[]   : ∀{Γ Δ σ} → false {Γ} [ σ ] ≡ false {Δ}
    ite[]     : ∀{Γ Δ A t u v σ} → (ite {Γ}{A} t u v) [ σ ] ≡ ite {Δ} (t [ σ ]) (u [ σ ]) (v [ σ ])

    num       : ∀{Γ} → ℕ → Tm Γ Nat
    isZero    : ∀{Γ} → Tm Γ Nat → Tm Γ Bool
    _+o_      : ∀{Γ} → Tm Γ Nat → Tm Γ Nat → Tm Γ Nat
    isZeroβ₁  : ∀{Γ} → isZero (num 0) ≡ true {Γ = Γ}
    isZeroβ₂  : ∀{Γ n} → isZero (num (1 + n)) ≡ false {Γ = Γ}
    +β        : ∀{Γ m n} → num m +o num n ≡ num {Γ = Γ} (m + n)
    num[]     : ∀{Γ Δ σ n} → num {Γ} n [ σ ] ≡ num {Δ} n
    isZero[]  : ∀{Γ Δ t σ} → (isZero {Γ} t) [ σ ] ≡ isZero {Δ} (t [ σ ])
    +[]       : ∀{Γ Δ u v}{σ : Sub Δ Γ} → (u +o v) [ σ ] ≡ (u [ σ ]) +o (v [ σ ])

    lam    : ∀{Γ A B} → Tm (Γ ▹ A) B → Tm Γ (A ⇒ B)
    _$_    : ∀{Γ A B} → Tm Γ (A ⇒ B) → Tm Γ A → Tm Γ B
    ⇒β     : ∀{Γ A B}{t : Tm (Γ ▹ A) B}{u : Tm Γ A} → lam t $ u ≡ t [ ⟨ u ⟩ ]
    ⇒η     : ∀{Γ A B}{t : Tm Γ (A ⇒ B)} → t ≡ lam (t [ p ] $ var vz)
    lam[]  : ∀{Γ A B}{t : Tm (Γ ▹ A) B}{Δ}{σ : Sub Δ Γ} → lam t [ σ ] ≡ lam (t [ σ ⁺ ])
    $[]    : ∀{Γ A B}{t : Tm Γ (A ⇒ B)}{u : Tm Γ A}{Δ}{σ : Sub Δ Γ} →
             (t $ u) [ σ ] ≡ (t [ σ ]) $ (u [ σ ])

    -- constructor
    ⟨_,o_⟩  : ∀{Γ A B} → Tm Γ A → Tm Γ B → Tm Γ (A ×o B)
    -- destructors
    fst    : ∀{Γ A B} → Tm Γ (A ×o B) → Tm Γ A
    snd    : ∀{Γ A B} → Tm Γ (A ×o B) → Tm Γ B
    -- β
    ×β₁    : ∀{Γ A B} {t : Tm Γ A}{u : Tm Γ B} → fst ⟨ t ,o u ⟩ ≡ t
    ×β₂    : ∀{Γ A B} {t : Tm Γ A}{u : Tm Γ B} → snd ⟨ t ,o u ⟩ ≡ u 
    ×η     : ∀{Γ A B} {t : Tm Γ (A ×o B)} → ⟨ fst t ,o snd t ⟩ ≡ t

    -- Helyettesitesi szabalyok
    ,[]    : ∀{Γ A B}{t : Tm Γ A}{u : Tm Γ B}{Δ}{σ : Sub Δ Γ} → ⟨ t ,o u ⟩ [ σ ] ≡ ⟨ t [ σ ] ,o u [ σ ] ⟩
    fst[]  : ∀{Γ A B}{t : Tm Γ (A ×o B)}{Δ}{σ : Sub Δ Γ} → fst t [ σ ] ≡ fst (t [ σ ])
    snd[]  : ∀{Γ A B}{t : Tm Γ (A ×o B)}{Δ}{σ : Sub Δ Γ} → snd t [ σ ] ≡ snd (t [ σ ])

  -- these are provable
  postulate
    [p][⁺]     : ∀{Γ A}{a : Tm Γ A}{B}{Δ}{γ : Sub Δ Γ} → a [ p {Γ}{B} ] [ γ ⁺ ] ≡ a [ γ ] [ p ]
    [p][⟨⟩]    : ∀{Γ A}{a : Tm Γ A}{B}{b : Tm Γ B} → a [ p ] [ ⟨ b ⟩ ] ≡ a
    [p⁺][⟨⟩⁺]  : ∀{Γ A C}{a : Tm (Γ ▹ C) A}{B}{b : Tm Γ B} → a [ p ⁺ ] [ ⟨ b ⟩ ⁺ ] ≡ a
    [⟨⟩][]     : ∀{Γ A B}{t : Tm (Γ ▹ A) B}{a : Tm Γ A}{Δ}{γ : Sub Δ Γ} → t [ ⟨ a ⟩ ] [ γ ] ≡ t [ γ ⁺ ] [ ⟨ a [ γ ] ⟩ ]
    [p⁺][⟨vz⟩] : ∀{Γ A B}{t : Tm (Γ ▹ A) B} → t [ p ⁺ ] [ ⟨ var vz ⟩ ] ≡ t

  def : {Γ : Con}{A B : Ty} → Tm Γ A → Tm (Γ ▹ A) B → Tm Γ B
  def t u = u [ ⟨ t ⟩ ]

  private
    Var' : ℕ → Con → Ty → Set
    Var' zero Γ A = Var Γ A
    Var' (suc n) Γ A = ∀ {B} → Var' n (Γ ▹ B) A

    Tm' : ℕ → Con → Ty → Set
    Tm' zero Γ A = Tm Γ A
    Tm' (suc n) Γ A = ∀ {B} → Tm' n (Γ ▹ B) A

    vs' : (n : ℕ) {Γ : Con} {A B : Ty} → Var' n Γ A → Var' n (Γ ▹ B) A
    vs' zero x = vs x
    vs' (suc n) x = vs' n x

    var' : (n : ℕ) {Γ : Con} {A : Ty} → Var' n Γ A → Tm' n Γ A
    var' zero x = var x
    var' (suc n) x = var' n x

    v' : (n : ℕ) {Γ : Con} {A : Ty} → Var' n (Γ ▹ A) A
    v' zero = vz
    v' (suc n) = vs' n (v' n)

  v : (n : ℕ) {Γ : Con} {A : Ty} → Tm' n (Γ ▹ A) A
  v n = var' n (v' n)

  v0 : ∀{Γ A} → Tm (Γ ▹ A) A
  v0 = var vz
  v1 : ∀{Γ A B} → Tm (Γ ▹ A ▹ B) A
  v1 = var (vs vz)
  v2 : ∀{Γ A B C} → Tm (Γ ▹ A ▹ B ▹ C) A
  v2 = var (vs (vs vz))
  v3 : ∀{Γ A B C D} → Tm (Γ ▹ A ▹ B ▹ C ▹ D) A
  v3 = var (vs (vs (vs vz)))
  v4 : ∀{Γ A B C D E} → Tm (Γ ▹ A ▹ B ▹ C ▹ D ▹ E) A
  v4 = var (vs (vs (vs (vs vz))))


  swap : ∀{Γ A B} → Tm Γ (A ×o B ⇒ B ×o A)
  swap = lam ⟨ snd v0 ,o fst v0 ⟩

  swaptest : ∀{Γ} → swap $ ⟨ num 1 ,o true ⟩ ≡ ⟨ true {Γ} ,o num 1 ⟩
  swaptest = ⇒β 
    ◾ ,[] 
    ◾ cong₂ (λ x y → ⟨ x ,o y ⟩) snd[] fst[] 
    ◾ cong₂ (λ x y → ⟨ snd x ,o fst y ⟩) vz[⟨⟩] vz[⟨⟩] 
    ◾ cong₂ (λ x y → ⟨ x ,o y ⟩) ×β₂ ×β₁

record Model {i j} : Set (lsuc (i ⊔ j)) where
  infixl 6 _[_]
  infixl 5 _▹_
  infixl 7 _+o_
  infixr 6 _⇒_
  infixl 5 _$_
  infixl 8 _×o_
  infixl 8 ⟨_,o_⟩

  field
    Ty        : Set i
    Con       : Set i
    Var       : Con → Ty → Set j
    Tm        : Con → Ty → Set j
    Sub       : Con → Con → Set j
    
    ◇         : Con
    _▹_       : Con → Ty → Con

    p         : ∀{Γ A} → Sub (Γ ▹ A) Γ
    ⟨_⟩       : ∀{Γ A} → Tm Γ A → Sub Γ (Γ ▹ A)
    _⁺        : ∀{Γ Δ A} → (σ : Sub Δ Γ) → Sub (Δ ▹ A) (Γ ▹ A)

    vz        : ∀{Γ A} → Var (Γ ▹ A) A
    vs        : ∀{Γ A B} → Var Γ A → Var (Γ ▹ B) A
    var       : ∀{Γ A} → Var Γ A → Tm Γ A
    _[_]      : ∀{Γ Δ A} → Tm Γ A → Sub Δ Γ → Tm Δ A
    [p]       : ∀{Γ A B x} →      var {Γ}{A} x [ p {A = B} ] ≡ var (vs x)
    vz[⟨⟩]    : ∀{Γ A t} →        var (vz {Γ}{A}) [ ⟨ t ⟩ ] ≡ t
    vz[⁺]     : ∀{Γ Δ A σ} →      var (vz {Γ}{A}) [ σ ⁺ ] ≡ var (vz {Δ}{A})
    vs[⟨⟩]    : ∀{Γ A B x t} →    var (vs {Γ}{A}{B} x) [ ⟨ t ⟩ ] ≡ var x
    vs[⁺]     : ∀{Γ Δ A B x σ} →  var (vs {Γ}{A}{B} x) [ σ ⁺ ] ≡ var x [ σ ] [ p {Δ} ]

    Bool      : Ty
    true      : ∀{Γ} → Tm Γ Bool
    false     : ∀{Γ} → Tm Γ Bool
    ite       : ∀{Γ A} → Tm Γ Bool → Tm Γ A → Tm Γ A → Tm Γ A
    iteβ₁     : ∀{Γ A u v} → ite {Γ}{A} true  u v ≡ u
    iteβ₂     : ∀{Γ A u v} → ite {Γ}{A} false u v ≡ v
    true[]    : ∀{Γ Δ σ} → true  {Γ} [ σ ] ≡ true  {Δ}
    false[]   : ∀{Γ Δ σ} → false {Γ} [ σ ] ≡ false {Δ}
    ite[]     : ∀{Γ Δ A t u v σ} → (ite {Γ}{A} t u v) [ σ ] ≡ ite {Δ} (t [ σ ]) (u [ σ ]) (v [ σ ])
    
    Nat       : Ty
    num       : ∀{Γ} → ℕ → Tm Γ Nat
    isZero    : ∀{Γ} → Tm Γ Nat → Tm Γ Bool
    _+o_      : ∀{Γ} → Tm Γ Nat → Tm Γ Nat → Tm Γ Nat
    isZeroβ₁  : ∀{Γ} → isZero (num 0) ≡ true {Γ = Γ}
    isZeroβ₂  : ∀{Γ n} → isZero (num (1 + n)) ≡ false {Γ = Γ}
    +β        : ∀{Γ m n} → num m +o num n ≡ num {Γ = Γ} (m + n)
    num[]     : ∀{Γ Δ σ n} → num {Γ} n [ σ ] ≡ num {Δ} n
    isZero[]  : ∀{Γ Δ t σ} → (isZero {Γ} t) [ σ ] ≡ isZero {Δ} (t [ σ ])
    +[]       : ∀{Γ Δ u v}{σ : Sub Δ Γ} → (u +o v) [ σ ] ≡ (u [ σ ]) +o (v [ σ ])
    
  def : ∀{Γ A B} → Tm Γ A → Tm (Γ ▹ A) B → Tm Γ B
  def u t = t [ ⟨ u ⟩ ]
  field
    _⇒_    : Ty → Ty → Ty
    lam    : ∀{Γ A B} → Tm (Γ ▹ A) B → Tm Γ (A ⇒ B)
    _$_    : ∀{Γ A B} → Tm Γ (A ⇒ B) → Tm Γ A → Tm Γ B
    ⇒β     : ∀{Γ A B}{t : Tm (Γ ▹ A) B}{u : Tm Γ A} → lam t $ u ≡ t [ ⟨ u ⟩ ]
    ⇒η     : ∀{Γ A B}{t : Tm Γ (A ⇒ B)} → t ≡ lam (t [ p ] $ var vz)
    lam[]  : ∀{Γ A B}{t : Tm (Γ ▹ A) B}{Δ}{σ : Sub Δ Γ} → lam t [ σ ] ≡ lam (t [ σ ⁺ ])
    $[]    : ∀{Γ A B}{t : Tm Γ (A ⇒ B)}{u : Tm Γ A}{Δ}{σ : Sub Δ Γ} →
             (t $ u) [ σ ] ≡ (t [ σ ]) $ (u [ σ ])

    _×o_     : Ty → Ty → Ty
    -- constructor
    ⟨_,o_⟩  : ∀{Γ A B} → Tm Γ A → Tm Γ B → Tm Γ (A ×o B)
    -- destructors
    fst    : ∀{Γ A B} → Tm Γ (A ×o B) → Tm Γ A
    snd    : ∀{Γ A B} → Tm Γ (A ×o B) → Tm Γ B
    -- β
    ×β₁    : ∀{Γ A B} {t : Tm Γ A}{u : Tm Γ B} → fst ⟨ t ,o u ⟩ ≡ t
    ×β₂    : ∀{Γ A B} {t : Tm Γ A}{u : Tm Γ B} → snd ⟨ t ,o u ⟩ ≡ u 
    ×η     : ∀{Γ A B} {t : Tm Γ (A ×o B)} → ⟨ fst t ,o snd t ⟩ ≡ t

    -- Helyettesitesi szabalyok
    ,[]    : ∀{Γ A B}{t : Tm Γ A}{u : Tm Γ B}{Δ}{σ : Sub Δ Γ} → ⟨ t ,o u ⟩ [ σ ] ≡ ⟨ t [ σ ] ,o u [ σ ] ⟩
    fst[]  : ∀{Γ A B}{t : Tm Γ (A ×o B)}{Δ}{σ : Sub Δ Γ} → fst t [ σ ] ≡ fst (t [ σ ])
    snd[]  : ∀{Γ A B}{t : Tm Γ (A ×o B)}{Δ}{σ : Sub Δ Γ} → snd t [ σ ] ≡ snd (t [ σ ])
    
