(* BEGIN FIX *)
From Coq Require Import Strings.String
                        Arith.PeanoNat
                        Arith.Plus.

Definition X:string := "X"%string.
Definition Y:string := "Y"%string.
Definition Z:string := "Z"%string.

Inductive AExp : Type :=
| ALit (n : nat)
| AVar (s : string)
| APlus (a1 a2 : AExp)
(* END FIX *)
(** 1. feladat: (0.5 pont)
                Egeszitsd ki a kifejezesnyelvet a ternary operatorral 
                (konkret szintaxissal: `a1 ? a2 : a3`)!
                Legyen a konstruktor neve `AIf`!
                A konkret hasznalatra lentebb lathatsz peldakat.

                Define the abstract syntax for the ternary operator (`a1 ? a2 : a3`)!
                The name of the corresponding constructor should be `AIf`.
*)
| AIf (a1 a2 a3 : AExp)
.

(* BEGIN FIX *)
Definition ex1 := AIf (ALit 1) (ALit 2) (ALit 3).
Definition ex2 := AIf (ALit 0) (ALit 2) (ALit 3).
Definition ex3 := APlus (AIf (ALit 0) (AVar X) (AVar Z)) 
                        (AIf (AVar X) (ALit 0) (ALit 1)).
Definition ex4 := AIf (APlus (AVar Z) (ALit 1)) (ALit 1) (ALit 0).

Definition state := string -> nat.

Definition empty : state := fun x => 0.

Definition aState : state := 
fun x =>
  match x with
  | "X"%string => 1
  | "Y"%string => 2
  | "Z"%string => 42
  | _ => 0
  end
.

Fixpoint aeval (a : AExp) (s : state) : nat :=
match a with
| ALit n => n
| AVar x => s x
| APlus a1 a2 => aeval a1 s + aeval a2 s
(* END FIX *)
(** 2. feladat: (0.5 pont)
                Ertelmezd a denotacios szemantikat a ternary operatorokra,
                ugy hogy az alabbi tesztek lefussanak! A ternary operator
                `a1 ? a2 : a3` ugy mukodik, mint egy kifejezesszintu elagazas,
                azaz eloszor kiertekeli `a1`-et, es ha a vegeredmeny `0`, akkor 
                `a2`-t, egyekent `a3`-t ertekeli ki.

                Define denotational semantics for the ternary operator `a1 ? a2 : a3`
                in the following way: first, evaluate `a1`, if the result is `0`, 
                then evaluate `a2`, otherwise evaluate `a3`!
*)
| AIf a1 a2 a3 => if Nat.eqb (aeval a1 s) 0 then aeval a2 s else aeval a3 s
end.

(* BEGIN FIX *)

Goal forall s, aeval ex1 s = 3. Proof. reflexivity. Qed.
Goal forall s, aeval ex2 s = 2. Proof. reflexivity. Qed.
Goal aeval ex3 aState = 2. Proof. reflexivity. Qed.
Goal aeval ex4 aState = 0. Proof. reflexivity. Qed.

Fixpoint optim (a : AExp) : AExp :=
match a with
| ALit n => ALit n
| AVar x => AVar x
| APlus a1 a2 => APlus (optim a1) (optim a2)
| AIf (ALit 0) a2 a3 => a2
| AIf a1 a2 a3 => AIf (optim a1) (optim a2) (optim a3)
end.



Theorem optim_sound :
  forall a s, aeval a s = aeval (optim a) s.
(* END FIX *)
(** 3. feladat: (1 pont)
                Bizonyitsd be a fenti optimalizacio helyesseget!

                Prove the correctness of the optimisation above!
*)
Proof.
(* Tipp: AIf eseten segithet a `remember` vagy a `simpl in *` taktika
         az atirasok megvalositasahoz.

   Hint: to avoid oversimplification, `remember` could be useful, or `simpl in *`.
*)
induction a; intros.
* simpl. reflexivity.
* simpl. reflexivity.
* simpl. rewrite IHa1. rewrite IHa2. reflexivity.
* induction (aeval a1 s).
Admitted.

(* BEGIN FIX *)
Reserved Notation "| a , st | -=> v" (at level 60).
Inductive eval_bigstep : AExp -> state -> nat -> Prop :=

| eval_lit (n : nat) (s : state) :
(* ----------------------- *)
   | ALit n , s | -=> n

| eval_var (x : string) (s : state) :
(* ---------------------- *)
  | AVar x , s | -=> s x

| eval_plus (a1 a2 : AExp) (s : state) (n1 n2 : nat) :
    | a1 , s | -=> n1 -> | a2 , s | -=> n2 ->
(* --------------------------------------- *)
       | APlus a1 a2 , s | -=> (n1 + n2)

(* END FIX *)
(** 4. feladat: (1 pont)
               Add meg a ternary operator big-step szemantikajat a
               2. feladatbeli leiras szerint, ugy, hogy a lenti
               tetelek (tesztek) bizonyithatoak legyenek!
               Tipp: 2 levezetesi szabalyt is fel kell venned!

               Define the big-step semantics of the ternary operator
               based on the informal descrition in task 2!
               Hint: you need to define 2 derivation rules!
*)

| eval_if_0 (a1 a2 a3 : AExp) (s : state) (n2 : nat):
  | a1, s | -=> 0 -> | a2 , s | -=> n2 ->
(* ------------------------------------------ *)
  | AIf a1 a2 a3 , s | -=> n2

| eval_if_not_0 (a1 a2 a3 : AExp) (s : state) (n1 n3 : nat):
  | a1 , s | -=> n1 -> | a3 , s | -=> n3 ->
(* ------------------------------------------ *)
  | AIf a1 a2 a3 , s | -=> n3

(* BEGIN FIX *)
where "| a , st | -=> v" := (eval_bigstep a st v).


(** 5. feladat: (1 pont)
               Bizonyitsd a kovetkezo teszteseteket! A jobb oldalon levo szamok
               felbontasakor figyelj a zarojelekre es precedenciakra!

               Prove the following derivations!
*)
Goal forall s, | ex1 , s | -=> 3.
(* END FIX *)
Proof.
intro.
apply eval_if_not_0 with (n1 := 1).
apply eval_lit.
apply eval_lit.
Qed.

(* BEGIN FIX *)
Goal | ex2 , aState | -=> 2.
(* END FIX *)
Proof.
apply eval_if_0.
apply eval_lit.
apply eval_lit.
Qed.

(* BEGIN FIX *)
Goal | ex3 , aState | -=> 2.
(* END FIX *)
Proof.
  (* Tipp: 2-t csereld le 1 + 1-re!
     Hint: replace 2 with 1 + 1 *)
replace 2 with (1 + 1).
apply eval_plus.
apply eval_if_0.
apply eval_lit.
apply eval_var.
apply eval_if_not_0 with (n1 := 1).
apply eval_var.
apply eval_lit.
simpl. reflexivity.
Qed.

(* BEGIN FIX *)
Goal | ex4 , aState | -=> 0.
(* END FIX *)
Proof.
  (* Tipp: Itt is szukseg lehet cserere! 
     Hint: you might need replacments here too *)
apply eval_if_not_0 with (n1 := 43).
replace 43 with (42 + 1).
apply eval_plus.
apply eval_var.
apply eval_lit.
reflexivity.
apply eval_lit.
Qed.

(* BEGIN FIX *)
Theorem bigstep_deterministic : 
  forall a s n, | a, s | -=> n -> forall m, | a, s | -=> m -> n = m.
(* END FIX *)
(** 6. feladat: (0.5 pont)
                Bizonyitsd a determinizmusat az igy kapott big-step szemantikanak!

                Prove that the big-step semantics is deterministic!
*)
Proof.
  (* Tipp: `AIf` eseten 4 eset lesz, attol fuggoen, hogy a1 0-ra vagy 1-re 
           ertekelodik ki. Probalj meg ellentmodast talalni abban a 2
           esetben, amikor `a1` egyszerre 0-ra es nem 0-ra ertekelodik ki
           a ket levezetesben!

     Hint: In case of `AIf`, four goals will be created based on which derivation
           rule has been applied in which derivation. In two cases, try to
           find counterexample when `a1` is evaluated both to 0 and not 0!
*)
induction a; intros; inversion H; inversion H0; subst.
* reflexivity.
* reflexivity.
* subst. assert (n0 = n1). 
** apply IHa1 with s. 
*** assumption. 
*** assumption.
** subst. assert (n2 = n3).
*** apply IHa2 with s.
**** assumption.
**** assumption.
*** subst. reflexivity.
* apply IHa2 with s.
** assumption.
** assumption.
* apply IHa2 with s.
** assumption.
**
Admitted.

(* BEGIN FIX *)
Reserved Notation "| a , st | => v" (at level 60).
Inductive eval_smallstep : AExp -> state -> AExp -> Prop :=

| seval_var x s :
  (* ------------------------ *)
    | AVar x, s | => ALit (s x)

| seval_plus_lhs a1 a1' a2 s:
     | a1, s | => a1' ->
  (* ---------------------------------- *)
     | APlus a1 a2, s | => APlus a1' a2

| seval_plus_rhs n a2' a2 s:
     | a2, s | => a2' ->
  (* ---------------------------------------------- *)
     | APlus (ALit n) a2, s | => APlus (ALit n) a2'

| seval_plus n1 n2 s :
  (* ------------------------------------------------- *)
    | APlus (ALit n1) (ALit n2), s | => ALit (n1 + n2)
(* END FIX *)
(** 7. feladat: (1 pont)
                Add meg a ternaris operator small-step szemantikajat a 2.
                feladateli leírás alapán úgy, hogy a követező tesztek 
                bizonyíthatóak legyenek!

                Define the small-step semantics of the ternary operator based
                on the description in task 2!
*)
| seval_if a1 a1' a2 a3 s:
      | a1, s | => a1' ->
      | AIf a1 a2 a3, s | => AIf a1' a2 a3

| seval_if_lit0 a2 a3 s:
      | AIf (ALit 0) a2 a3, s | => a2

| seval_if_lit n a2 a3 s:
      | AIf (ALit n) a2 a3, s | => a3
(* BEGIN FIX *)
where "| a , st | => v" := (eval_smallstep a st v).

Reserved Notation "| a , st | =>* v" (at level 60).
Inductive eval_smallstep_rtc : AExp -> state -> AExp -> Prop := 

| seval_refl a s :
  | a , s | =>* a
| seval_trans a a' a'' s :
  | a, s | => a' -> | a', s | =>* a'' ->
(* ------------------------------------*)
            | a, s | =>* a''

where "| a , st | =>* v" := (eval_smallstep_rtc a st v).

(** 8. feladat: (1 pont)
               Bizonyitsd a kovetkezo teszteseteket!

               Prove the following tests!
*)
Goal forall s, | ex1 , s | =>* ALit 3.
(* END FIX *)
Proof.
intro.
unfold ex1.
apply seval_trans with (a' := ALit 3).
apply seval_if_lit.
apply seval_refl.
Qed.

(* BEGIN FIX *)
Goal | ex2 , aState | =>* ALit 2.
(* END FIX *)
Proof.
unfold ex2.
apply seval_trans with (a' := ALit 2).
apply seval_if_lit0.
apply seval_refl.
Qed.

(* BEGIN FIX *)
Goal | ex3 , aState | =>* ALit 2.
(* END FIX *)
Proof.
unfold ex3.
apply seval_trans with (a' := APlus (AVar X) (AIf (AVar X) (ALit 0) (ALit 1))).
apply seval_plus_lhs.
apply seval_if_lit0.
apply seval_trans with (a' := APlus (ALit 1) (AIf (AVar X) (ALit 0) (ALit 1))).
apply seval_plus_lhs.
apply seval_var.
apply seval_trans with (a' := APlus (ALit 1) (AIf (ALit 1) (ALit 0) (ALit 1))).
apply seval_plus_rhs.
apply seval_if.
apply seval_var.
apply seval_trans with (a' := APlus (ALit 1) (ALit 1)).
apply seval_plus_rhs.
apply seval_if_lit.
apply seval_trans with (a' := ALit 2).
apply seval_plus.
apply seval_refl.
Qed.

(* BEGIN FIX *)
Goal | ex4 , aState | =>* ALit 0.
(* END FIX *)
Proof.
unfold ex4.
apply seval_trans with (a' := AIf (APlus (ALit 42) (ALit 1)) (ALit 1) (ALit 0)).
apply seval_if.
apply seval_plus_lhs.
apply seval_var.
apply seval_trans with (a' := AIf (ALit 43) (ALit 1) (ALit 0)).
apply seval_if.
apply seval_plus.
apply seval_trans with (a' := ALit 0).
apply seval_if_lit.
apply seval_refl.
Qed.

(* BEGIN FIX *)
Theorem smallstep_determinism :
  forall a s a', | a, s | => a' -> forall a'', | a, s | => a'' -> a' = a''.
(** 9. feladat: (0.5 pont)
                 Bizonyitsd a determinizmusat az igy kapott small-step szemantikanak!

                 Prove the determinism of the small-step semantics!
*)
(* END FIX *)
Proof.

intros e e' s H. induction H.
- intros. inversion H. reflexivity.
- intros. inversion H0.
-- assert (a1' = a1'0). apply IHeval_smallstep. assumption. rewrite -> H6. reflexivity.
-- rewrite <- H1 in H. inversion H.
-- rewrite <- H2 in H. inversion H.
- intros. inversion H0.
-- inversion H5.
-- assert (a2' = a2'0). apply IHeval_smallstep. assumption. rewrite -> H6. reflexivity.
-- rewrite <- H3 in H. inversion H.
- intros e H0. inversion H0.
-- inversion H4.
-- inversion H4.
-- reflexivity.
- intros e H0. inversion H0.
-- inversion H6. subst.
--- assert (a1' = (ALit (s x))). apply IHeval_smallstep. assumption. rewrite -> H1. reflexivity.
--- subst. assert (a1' = (APlus a1'1 a7)). apply IHeval_smallstep. assumption. rewrite H1. reflexivity.
--- subst. assert (a1' = (APlus (ALit n) a2')). apply IHeval_smallstep. assumption. rewrite H1. reflexivity.
--- subst. assert (a1' = (ALit (n1 + n2))). apply IHeval_smallstep. assumption. rewrite H1. reflexivity.
--- subst. assert (a1' = (AIf a1'1 a7 a8)). apply IHeval_smallstep. assumption. rewrite H1. reflexivity.
--- subst. assert (a1' = a1'0). apply IHeval_smallstep. assumption. rewrite H1. reflexivity.
--- subst. assert (a1' = a1'0). apply IHeval_smallstep. assumption. rewrite H1. reflexivity.
-- subst. assert (a1' = (ALit 0)). apply IHeval_smallstep.
Admitted.