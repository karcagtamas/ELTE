# Typesystems

## Sequence of Lexical Elements

- Removing space character from the source String
- Lexical analyze - correct lexical element checking

`if isZero (num 0 + num 1) then false else isZero (num 0) => [if,isZero,(,num,0,+,num,1,),then,false,else,isZero,(,num,0,)]`
`isZero (num 1) === isZero    (   num 1 )`

- Spaces are removed, so the second example is equal
- When one or more lexical elements are not permitted => throws error

### Lexical Element Exercises

- Equtions of lists of lexical elements
  - `num   3 ?= num (3)` - No (**[num,3] vs [num,(,3,)]**)
  - `isZero 0 ?= true` - No (**[isZero,0] vs [true]**)
  - `if 3 then (false) ?= if   3 then (  false)` - Yes (**[if,3,then,(,false,)]**)
  - `(if 3 then (false)) ?= if   3 then (   false)` - No (**[(,if,then,(,false,),)] vs [if,3,then,(,false,)]**)
  - `then then if ?= then  then if` - Yes (**[then,then,if]**)
- Lexical analyzer throw error
  - `if true then true else num 0` - False
  - `if true then num 0 else num 0` - False
  - `if num 0 then num 0 else num 0` - False
  - `if if then num 0 else num 0` - False
  - `true + zero` - True (_because of zero_)
  - `true + num 1` - False
  - `true + isZero` - False
  - `isZero + 0` - False

## Abstract Syntax Tree

- **BNF** : `T ::= true | false | if T then T else T | num N | isZero T | T + T` where _N_ is a _Natural number_

```agda
data Tm : Set where
    true   : Tm
    false  : Tm
    ite    : Tm -> Tm -> Tm -> Tm
    num    : N -> Tm
    isZero : Tm -> Tm
    _+o_   : Tm -> Tm -> Tm
```

- `if isZero (num 0 + num 1) then false else isZero (num 0)`

```text
            ite
         /   |   \
    isZero false isZero
      |             |
      +           num 0
    /   \
 num 1 num 0
```

- Tree elements
  - num, true, false - the leaves
  - ite ternary operator
  - isZero unary operator
  - _+o_ binary operator
- `(true)` === `true`
- `(num 0 + num 0) + num 0` !== `num 0 + (num 0 + num 0)`
- `(true` and `num 1 +` were valid lexical sequences, but not valid ASTs

> Meta language: Agda, Object language: Razor

### AST Exercises

- `(true + true) + true`

```text
      +
     / \
    +  true
   / \
true true
```

- `(true + (true + true)) + true`

```text
            +
           / \
          +  true
         / \
      true +
          / \
       true true
```

- `ite (true + true) ((true + true) + true) (true + (true + true))`

```text
                        ite
                   /     |      \
                 +       +       +
                / \     / \     / \
             true true + true true +
                      / \         / \
                   true true    true true
```

- `ite (num 0 + (isZero (num 2))) (num 0) (ite (true + false) (num 3) true)` - converted from AST

- Whiches are accapted:
  - `isZero (num 1) + (num 1)` - Not (**isZero is unary operator (much arguments)**)
  - `isZero (num 1 + num 1)` - Yes
  - `isZero (num 2) 3` - Not (**isZero is unary operator (two arguments)**)
  - `num 1 + isZero` - Not (**isZero is unary operator (missing arguments)**)
  - `1 + num 1` - Yes
  - `true + 1` - Yes
- Whices are accepted by a Parser for a `Tm`
  - `if true then true else num 0` - Yes
  - `if true then num 0 else num 0` - Yes
  - `if num 0 then num 0 else num 0` - Yes
  - `if num 0 then (num 0 else num 0)` - No
  - `if if then num 0 else num 0` - No
  - `true + false` - Yes
  - `true + (num 1))` - No
  - `true + (num 1)` - Yes
  - `(true + isZero)` - No
  - `isZero + num 0` - No

```agda
record Model {l} : Set (lsuc l) where
  field
    Tm     : Set l
    true   : Tm
    false  : Tm
    ite    : Tm -> Tm -> Tm -> Tm
    num    : N -> Tm
    isZero : Tm -> Tm
    _+o_   : Tm -> Tm -> Tm
```

```agda
HeightModel : Model
HeightModel = record
  { Tm = N
  ; true = 0
  ; false = 0
  ; ite = lamda n n' n'' -> 1 + max n (max n' n'')
  ; num = lamda n -> 0
  ; isZero = lamda n -> 1 + n
  ; _+o_ = lamda n n' -> 1 + max n n'
  }
```

## Well-typed Syntax

- The problem is: `isZero true` and `true + num 2` are still meaningless
- Add type nformation to the terms

```agda
record Model {l l'} : Set (lsuc (l U l')) where
  field
    Ty     : Set l
    Tm     : Ty -> Set l'
    Nat    : Ty
    Bool   : Ty
    true   : Tm Bool
    false  : Tm Bool
    ite    : {A : Ty} => Tm Bool -> Tm A -> Tm A -> Tm A
    num    : N -> Tm Nat
    isZero : Tm Nat -> Tm Bool
    _+o_   : Tm Nat -> Tm Nat -> Tm Nat
```

- Each operator expects a term of the correct type as input and return a term of the approproate type

Derivation rule style:

```text
t : Tm Bool   u : Tm A   v : Tm A
---------------------------------
         ite t u v : Tm A
```

```text
--------------   --------------
num 0 : Tm Nat   num 1 : Tm Nat
-------------------------------                             --------------
    num 0 + num 1 : Tm Nat                                  num 0 : Tm Nat
    -----------------------          ---------------   ------------------------
     isZero (num 0 + num 1)          false : Tm Bool   isZero (num 0) : Tm Bool
---------------------------------------------------------------------------------
         ite (isZero (num 0 + num 1)) false (isZero (num 0)) : Tm Bool
```

- `ite (isZero (num 0)) (num 1 + num 2) (num 3)`

```text
     --------------        --------------   --------------
     num 0 : Tm Nat        num 1 : Tm Nat   num 2 : Tm Nat
------------------------   -------------------------------      --------------
isZero (num 0) : Tm Bool        num 1 + num 2 : Tm Nat          num 3 : Tm Nat
------------------------------------------------------------------------------
          ite (isZero (num 0)) (num 1 + num 2) (num 3) : Tm Nat
```

- Which ones are rejected by type interference
  - `if true then true else num 0` - Rejected (**true vs num 0**)
  - `if true then num 0 else num 0` - OK (Tm Bool , Tm Nat , Tm Nat)
  - `if num 0 then num 0 else num 0` - Rejected (**first num 0 should be Tm Bool**)
  - `if num 0 then num 0 else true` - Rejected (**first num 0 should be Tm Bool and true should be Tm Nat (or second num 0 should be Tm Bool)**)
  - `true +o zero` - Rejected (**true should be Tm Nat**)
  - `true +o num 1` - Rejected (**true should be Tm Nat**)
  - `true +o isZero (num 1)` - Rejected (**true and isZero (num 1) has invalid type**)
  - `isZero (num 1) +o num 0` - Rejected (**isZero (num 1) and num 0 has invalid type**)
- Standard Model
  - Metatheoretic counterparts

```agda
St : Model
St = record
  { Ty     = Set
  ; Tm     = lamda T -> T
  ; Nat    = N
  ; Bool   = 2
  ; true   = tt
  ; false  = ff
  ; ite    = if_then_else_
  ; num    = lamda n -> n
  ; isZero = lamda { zero -> tt ; _ -> ff }
  ; _+o_   = _+_
  }
```

## Well-typed Syntax with Equations

- We create equality in the sensible semantics
  - For example: `I.true === I.isZero (I.num 0)`
  - Two term which result in the same boolean or number are equal
  - Equational consistency with standard model
- Normalisation
  - Language can aslo be defined without equations
  - Normal forms: pairwise distinct and every syntatic term is equal to a normal form
  - Normalisation is simply interpretation into the standard model
  - Completeness
    - Every term is equal to its normal form
    - `I.Tm I.Bool` => `true` or `false`
    - Every natural number term is a finite application of `I.sucs` on `I.zero`

### Exercises

- Get types
  - `lam {} (suc (var vz))` : Tm <> (Nat => Nat)
  - `lam {} (pair (suc (var vz)) zero)` : Tm <> (Nat => Prod Nat Nat)
  - `lam {} (iteNat zero zero (var vz))` : Tm <> (Nat => Nat)
  - `lam {} (iteProd {}{}{A} (suc (var (vs vz))) (var vz))` : Tm <> (Prod Nat A => Nat)
  - `lam {} (lam (suc (var vz $ (var (vs vz)))))` : Tm <> (Nat => ((Nat => Nat) => Nat))
- Type checker (AST syntax)
  - `iteProd x y (var y) (pair zero (lam z (var z)))` - OK
  - `lam z (iteProd x y (var x) (var y))` - OK
  - `iteProd x y (var y) (iteProd x y (var y) (pair zero zero))` - NOK (**iteProd (second) is not Prod type**)
  - `iteProd x y (var y) (pair zero zero)` - OK
  - `iteProd x y (var y) (lam x (var x))` - NOK (**lam is not Prod type (=>)**)
  - `iteProd x y (var y) zero` - NOK (**zero is not Prod type (Nat)**)
- Convert (from AST syntax to Well-typed)
  - `lam x (iteNat x y (suc y) x)` => `lam (iteNat (var vz) (suc (var vz)) (var vz))`
  - `iteProd x y (var y) (pair zero zero)` => `iteProd (var vz) (pair zero zero)`
  - `lam z (iteProd x y (var y) (pair zero (var z)))` => `lam (iteProd (var vz) (pair zero (var vz)))`
  - `lam x (lam y (var x))` => `lam (lam (var (vs vz)))`
  - `lam y (lam x (var y))` => `lam (lam (var (vs vz)))`
  - `lam y (lam x (var x))` => `lam (lam (var vz))`
- What terms are binding variables in parameters
  - `[lam, iteNat, iteProd]`
- What statements are valid
  - `suc zero != suc (suc zero)` in syntax - True
  - Exists model where Tm <> Nat empty - False
  - Every model: `zero != suc zero` - False
  - Exists model: `zero = suc zero` - True
  - Exists model: `Con = Ty` - True
  - `zero != suc zero` in syntax - True

## Bindings

- Define variables
  - Add binders what has scope
  - Add variable definition
  - `def x:= 1 + 2 in x + x` - it's equal with: (1 + 2) + (1 + 2)
  - `def : {A B : Ty} -> Tm A -> (Tm A -> Tm B) -> Tm B`
- Free variables are not in the scope of a binder (which binds the same name)
  - The term is closed if there are no free variables in it
  - The term is open if it containes at least one free variable
- The binding names not matter, we use natural numbers -> De Bruijn indices
  - `v0` reference to the nearest binder, `v1` to the next, and so on
  - `Tm 0` is set of closed terms (programs)
  - `Tm 1` is set of open terms (with 1 free variable), ...
    - The binders decrease this number
    - `def` takes a `Tm (1 + n)` and binds the bariable and return a `Tm n`
- `(def x:= 1 + 2 in x + x) + (def y:= 3 + 4 in y + y)`
  - `t = def (num 1 +o num 2) (v0 +o v0) +o def (num 3 +o num 4) (v0 + v0)`
- `def x:= 1 + 2 in (x + x + def y:= 3 + 4 int x + y)`
  - `t = def (num 1 +o num 2) (v0 + v0 + def (num 3 +o num 4) (v1 +o v0))`
- For Well-typed syntax, we ises context with correct types
  - `v0 : {Γ : Con}{A : Ty} -> Tm (Γ |> A) A`
  - `v3 : {Γ: Con}{A B C D : Ty} -> Tm (Γ |> A |> B |> C |> D) A`
- For Well-typed syntax with equations
  - We use new term: Sub what is weakening the current context
  - We can use p to reverse it
  - For this, we can define standard model
    - This is equal with the equations
    - If 2 terms are equal in the standard model, then they are equals in the equations (syntax)
  - Normalisation
    - constructors
      - introduce elements: true, false, num
    - destructors
      - eliminate an element: ite, isZero, \_+o\_
    - computation (B - beta riles)
      - explain what happens if a destructor is applied to a constructor: iteB1, iteB2, isZeroB1, isZeroB2, +B
    - uniqueness (n rules)
      - explain what heppens if a constructor is applied to a destructor
    - substitution rules
      - how instation \_[\_] interacts with the operators: true[], false[], ite[], num[], isZero[], +[]
    - If we can't use any B (beta) rules on a term, then it is in normal form

```text
                                              --------------------------
                                              vz : Var (<> |> Bool) Bool
     -----------------                       -----------------------------   ---------------------------   ---------------------------
     num 0 : Tm <> Nat                       var vz : Tm (<> |> Bool) Bool   num 0 : Tm (<> |> Bool) Nat   num 1 : Tm (<> |> Bool) Nat
---------------------------                  -----------------------------------------------------------------------------------------
isZero (num 0) : Tm <> Bool                                     ite (var vz) (num 0) (num 1) : Tm (<> |> Bool) Nat
--------------------------------------------------------------------------------------------------------------------------------------
                                  def (isZero (num 0)) (ite (var vz) (num 0) (num 1)) : Tm <> Nat
```

```text
                                                                                                              ------------------------
                                                                                                              vz : Var (<> |> Nat) Nat
                                                                    -------------------------------      ----------------------------------
                                                                    vz : Var (<> |> Nat |> Nat) Nat      vs vz : Var (<> |> Nat |> Nat) Nat
                                                                  ----------------------------------   ---------------------------------------
                                                                  var vz : Tm (<> |> Nat |> Nat) Nat   var (vs vz) : Tm (<> |> Nat |> Nat) Nat
                                     ------------------------     ----------------------------------------------------------------------------
                                     vz : Var (<> |> Nat) Nat                   var vz + var (vs vz) : Tm (<> |> Nat |> Nat) Nat
                                    ---------------------------   ----------------------------------------------------------------------------
                                    var vz : Tm (<> |> Nat) Nat            isZero (var vz + var (vs vz)) : Tm (<> |> Nat |> Nat) Bool
-----------------                   ----------------------------------------------------------------------------------------------------------
num 2 : Tm <> Nat                                       def (var vz) (isZero (var vz + var (vs vz))) : Tm (<> |> Nat) Bool
----------------------------------------------------------------------------------------------------------------------------------------------
                             def (num 2) (def (var vz) (isZero (var vz + var (vs vz)))) : Tm <> Bool
```

### Bindings Exercises

- Find free variables
  - `x + y`: [x,y]
  - `x + def x := 3 in y + x`: [first x, y]
  - `x + def x := y in y + x`: [first x, y]
  - `x + def x := x' in (x + def x' := z in x' + x)`: [first x, first x', z]
  - `3 + def x := x in (x' + def x' := 2 in x' + x)`: [first x, first x']
- The terms are closed are open
  - `def x := 3 in x + x` - Closed
  - `def x := y in x + x` - Open
  - `def x := y in x + y` - Open
  - `def y := x in x + y` - Open
  - `def y := x in x + x` - Open
- Rewrite the terms with De Bruijn notation
  - `def x:= 1 in x + def y := x + 1 in y + def z := x + y in (x + z)+(y+z)`
    - `def (num 1) (v0 +o def (v0 +o 1) (v0 +o (def (v1 +o v0) ((v2 +o) +o (v1 +o v0))))`
  - `(def x:=1 in x) + (def y:=1 in y) + def z := 1 in z + z`
    - `def (num 1) v0 +o def (num 1) v0 + def (num 1) (v0 +o v0)`
- Rewrite the terms with variable name notation
  - `def true (v0 +o def v0 (v0 +o v1))`
    - `def x:=true in (x +o def y:=x in (y + x))`
  - `def true (def false (def true (def false ((v0 +o v1) +o (v2 +o v3)))))`
    - `def x:=true in (def y:=false in (def z:= true in (def w:= false in ((w + z) + (y + x)))))`
- Derive `def (var vz) true : Tm (<> |> Nat) Bool`

```text
 ------------------------
 vz : Var (<> |> Nat) Nat
---------------------------   ---------------------------------
var vz : Tm (<> |> Nat) Nat   true : Tm (<> |> Nat |> Nat) Bool
---------------------------------------------------------------
         def (var vz) true : Tm (<> |> Nat) Bool
```

- Derive `def (num 1) (var vz + var (vs vz)) : Tm (<> |> Nat) Nat`

```text
                                                                          -----------------------
                                                                          vz : Tm (<> |> Nat) Nat
                               -------------------------------       ---------------------------------
                               vz : Var (<> |> Nat |> Nat) Nat       vs vz : Tm (<> |> Nat |> Nat) Nat
                             ----------------------------------   ---------------------------------------
                             var vz : Tm (<> |> Nat |> Nat) Nat   var (vs vz) : Tm (<> |> Nat |> Nat) Nat
--------------------------   ----------------------------------------------------------------------------
            num 1 : Tm (<> |> Nat) Nat   var vz + var (vs vz) : Tm (<> |> Nat |> Nat) Nat
---------------------------------------------------------------------------------------------------------
                       def (num 1) (var vz + var (vs vz)) : Tm (<> |> Nat) Nat
```

- What can be `t` such that `def t (def true (ite v0 v1 v1)) : Tm <> Nat`
  - `t` can be any term what type is `Nat` => any `Tm Γ Nat`

### Normalisation Exercises

- What are the normal form of these terms?
  - `t1 : Σsp (Nf (⋄ ▷ Nat) Nat) λ v → ￿ v ￿Nf ≡ v0 +o (num 1 +o num 2)`
    - `t1 : v0 +o num 3`
  - `t2 : Σsp (Nf (⋄ ▷ Nat) Nat) λ v → ￿ v ￿Nf ≡ v0 +o v0`
    - `t2 : v0 +o v0`
  - `t3 : Σsp (Nf (⋄ ▷ Nat) Nat) λ v → ￿ v ￿Nf ≡ (num 1 +o num 2) +o v0`
    - `t3 : num 3 +o v0`
  - `t4 : Σsp (Nf (⋄ ▷ Nat) Nat) λ v → ￿ v ￿Nf ≡ (num 1 +o v0) +o v0`
    - `t4 : (num 1 +o v0) +o v0`
  - `t5 : Σsp (Nf (⋄ ▷ Nat) Bool) λ v → ￿ v ￿Nf ≡ isZero (num 2)`
    - `t5 : false`
  - `t6 : Σsp (Nf (⋄ ▷ Nat) Bool) λ v → ￿ v ￿Nf ≡ isZero (num 1 +o num 2)`
    - `t6 : false`
  - `t7 : Σsp (Nf (⋄ ▷ Nat) Bool) λ v → ￿ v ￿Nf ≡ isZero (num 1 +o v0)`
    - `t7 : isZero (num 1 +o v0)`
  - `t8 : Σsp (Nf ⋄ Bool) λ v → ￿ v ￿Nf ≡ def (num 0) (def (isZero v0) (ite v0 false true))`
    - `t8 : false`

## High order function space

- First class highorder functions
  - `_=>_` right-associative: A => B => C => D === A => (B => (C => D)) : type introduction
  - `lam` : constructor
  - `_$_` left associative: t $ u $ v = (t $ u) $ v : destructor
  - `=>B` : computatation
  - `=>n` : uniqueness

## Product and sum types

- Binary products
  - `_xo_ : Ty -> Ty -> Ty`
  - `A x B` notation or a `record { a : A, b : B }`
  - Ordered pair of a term of type A and another of type B
  - The constructor is pairing, the two destructors: first and second projectsions
  - The computation rules say what happens if we project out the first or second element of a pair
  - The uniqueness rule says that any term of the product type is a pair
- Nullary products
  - `Unit : Ty`
  - The nullary produst is the unit (top, ()) type with only one constructor and no destructor (shows no information)
  - Other programming languages are calling this as `void` - when a method does not return with anything, it returns `unit`
- Binary sums
  - `_+o_ : Ty -> Ty -> Ty`
  - `A + B` is a type what contains A or B type term
  - Two constructors: `inl` and `inr`, one destructor: `caseo`
- Nullary sums
  - `Empty : Ty`

## Inductive types

- Specified by its constructors
- Its destructor and computation rules are determined by the constructors
- Natural numbers or Bools are inductive types also
  - `zero`, `suc`

### Natural numbers

```agda
Nat : Ty
zeroo : ∀{Γ} → Tm Γ Nat
suco : ∀{Γ} → Tm Γ Nat → Tm Γ Nat
iteNat : ∀{Γ A} → Tm Γ A → Tm (Γ ▷ A) A → Tm Γ Nat → Tm Γ A
Natβ1 : ∀{Γ A}{u : Tm Γ A}{v : Tm (Γ ▷ A) A} → iteNat u v zeroo ≡ u
Natβ2 : ∀{Γ A}{u : Tm Γ A}{v : Tm (Γ ▷ A) A}{t : Tm Γ Nat} →
iteNat u v (suco t) ≡ v [ ⟨ iteNat u v t ⟩ ]
zero[] : ∀{Γ Δ}{𝛾 : Sub Δ Γ} → zeroo [ 𝛾 ] ≡ zeroo
suc[] : ∀{Γ}{t : Tm Γ Nat}{Δ}{𝛾 : Sub Δ Γ} → (suco t) [ 𝛾 ] ≡ suco (t [ 𝛾 ])
iteNat[] : ∀{Γ A}{u : Tm Γ A}{v : Tm (Γ ▷ A) A}{t : Tm Γ Nat}{Δ}{𝛾 : Sub Δ Γ} → iteNat u v t [ 𝛾 ] ≡ iteNat (u [ 𝛾 ]) (v [ 𝛾 + ]) (t [ 𝛾 ])
```

- `iteNat` binds a variable of type `A` in its second argument
- Computation riles `NatB1` and `NatB2` express that `iteNat u v t` works as follows: it replaces all `suco`s in t by what is specified by `v` and replaces `zeroo` by `u`
  - Example `iteNat u v (suco (suco (suco zeroo)))` is equal to `v [< v [< v [< u >] >] >]`

### Lists

- Another inductive type is list: `cons`, `nil` constructors and `iteList` destructor

### Trees

- `leaf`, `node` constructors and `iteTree` destructor

### Uniqueness rules

- Inductive types usually dont come with n rules: that would make equality undecidable: we can have many non-equal implementation of the same fuctions

### Standard model

- We are using the Agda's inductive types to define lists and trees

### Normalisation

- For each inductive type, the constructor becomes a normal form, the destructor becomes a netural term
- Inductive types act as base types, so all netural term of a base type are normal forms

## Exam Tasks

- What terms are in `Tm <> (Nat => Prod Nat Nat)`
  - `lam v0` - No (**v0 is Nat**)
  - `lam (pair zero zero)` - Yes
  - `lam (pair v0 zero)` - Yes
  - `lam (lam v0)` - No (**Result should be A => A => A**)
  - `pair (lam v0) (lam v0)` - No (**Result will be Prod (=>) (=>)**)
  - `lam (iteNat (pair v0 v0) v0 v0)` - Yes
- What terms are in `Tm Γ (Prod A B => Prod B A)` all Γ, A and B
  - `lam v0` - No
  - `lam (pair v0 v1)` - No
  - `lam (iteProd (pair v0 v1) v0)` - Yes
  - `lam (pair (iteProd v0 v0) (iteProd v1 v0))` - Yes
  - `lam (iteProd (pair v1 v0) v0)` - No
- There is `u : Tm Γ (Prod A B => Prod B A)` and `v : Tm Γ (Prod B A => Prod A B)`: True or false: All `t : Tm Γ (Prod A B)` => `v $ (u $ t)`
  - No
- What we used for the proving (to reach the next row)?
  - `(lam (iteNat zero v0 v0)) $ zero` - `=>B`
  - `(iteNat zero v0 v0)[<zero>]` - `iteNat[]`
  - `iteNat (zero[<zero>]) (v0[<zero>+]) (v0[<zero>])` - `zero[]`
  - `iteNat zero (v0[<zero>+]) (v0[<zero>])` - `vz[<>]`
  - `iteNat zero (v0[<zero>+]) zero` - `iteNatB1`
  - `zero`
- What equations are correct in the syntax?
  - `lam (iteProd (pair v1 v0) v0) = lam v0` - False
  - `iteNat zero (suc v0) (suc (suc v0)) = suc (suc v0)` - False
  - `iteProd (pair v1 v0) (pair v1 v0) = (pair v1 v0)` - True
  - `iteNat zero (suc v0) (suc (suc zero)) = suc (suc zero)` - True
  - `iteNat zero (suc v0) v0 = v0` - False
- When the `Tm <> (Nat => Prod Nat Nat) terms give back the number, and the bigger with 2`
  - `lam (pair v0 (iteNat (suc (suc v0)) (suc v0) v0))` - False
  - `lam (pair v0 (suc (suc (iteNat zero (suc v0) v0))))` - True
  - `lam (pair v0 (iteNat (suc (suc v0)) v0 v0))` - True
  - `lam (pair v0 (suc (suc (iteNat v0 v0 v0))))` - True
  - `lam (pair v0 (iteNat (suc (suc zero)) (suc v0) v0))` - True
  - `lam (pair v0 (suc (suc v0)))` - True
- These terms are in `Tm <> ((A => A) => (A => A))` fixed `A : Ty`. Which equals with lam v0?
  - `lam (lam v0)` - False
  - `lam (lam (v1 $ v0))` - True
  - `lam (lam (v1 $ (v1 $ v0)))` - False
  - `lam (lam (v1 $ (v1 $ (v1 $ v0))))` - False
  - `lam (lam (v1 $ (v1 $ (v1 $ (v1 $ v0)))))` - False
- What are the normal forms of these terms:
  - `iteNat (suc zero) v0 v0 : Tm <> Nat`
    - `neuNat (iteNat (suc zero) (neuNat (var vz)) (var vz)) : Nf <> Nat`
  - `iteNat (suc zero) (suc v0) (suc zero) : Tm <> Nat`
    - `suc (suc zero) : Nf <> Nat`
  - `v2 : Tm (<> |> Nat |> Nat |> Nat) Nat`
    - `neuNat v2 : Nf (<> |> Nat |> Nat |> Nat) Nat`
  - `v0 : Tm (<> |> Nat => Nat) (Nat => Nat)`
    - `lam (natNat (v1 $ neuNat v0)) : Nf (<> |> Nat => Nat) (Nat => Nat)`
  - `v0 : Tm (<> |> Prod Nat Nat) (Prod Nat Nat)`
    - `neuProd v0 : Nf (<> |> Prod Nat Nat) (Prod Nat Nat)`
- What statements are true?
  - There is a model where: `v0 [ p ] [<v> +] != v [ p ]` - False
  - In syntax: `zero != suc zero` - True
  - If `zero = suc zero` in a moder, then `suc (suc (suc zero)) = zero` - True
  - There is a model where `Con = Ty` - True
  - There is a model where `Nat = Prod Nat Nat` - True
  - In all model: `iteProd zero (pair (suc zero) (suc zero)) = zero` - True
  - In all model: `iteProd zero (pair (suc zero) (suc zero)) = suc zero` - False
  - In syntax: `Nat = Prod Nat Nat` - False
  - In the inicial model, if `t : Tm <> Nat` then `t = zero` or `t = suc t'` any `t'` - True
  - In all modell if `t : Tm <> Nat` then `t = zero` or `t = suc t'` any `t'` - False
- We expand the language with a `Tree` type, what has 2 or more branches. What is the correct iterator?
  - `iteTree : Tm (Γ▹C) C → Tm (Γ▹Prod C C) C → Tm (Γ▹(Nat⇒C)) C → Tm Γ Tree → Tm Γ C` - False
  - `iteTree : Tm Γ C → Tm (Γ▹C) C → Tm (Γ▹Prod C C) C → Tm (Γ▹Nat▹C) C → Tm Γ Tree → Tm Γ C` - False
  - `iteTree : Tm (Γ▹C) C → Tm (Γ▹C▹C▹C) C → Tm Γ Tree → Tm Γ C` - False
  - `iteTree : Tm Γ C → Tm (Γ▹C) C → Tm (Γ▹C▹C) C → Tm (Γ▹(Nat⇒C)) C → Tm Γ Tree → Tm Γ C` - True
  - `iteTree : Tm (Γ▹C) C → Tm (Γ▹Prod C C) C → Tm (Γ▹Nat▹C) C → Tm Γ Tree → Tm Γ C` - False
