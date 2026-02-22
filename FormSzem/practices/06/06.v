Require Import Strings.String.

Inductive exp : Type :=
  | lit : nat -> exp
  | var : string -> exp
  | plus : exp -> exp -> exp.
Definition W : string := "W".
Definition X : string := "X".
Definition Y : string := "Y".
Definition Z : string := "Z".
Definition state : Type := string -> nat.
Fixpoint eval (e : exp)(s : state) : nat :=
  match e with
  | lit n => n
  | var x => s x
  | plus e1 e2 => eval e1 s + eval e2 s
  end.
Definition empty : state := fun x => 0.
Definition update (x : string)(n : nat)(s : state)
  : state := fun x' => match string_dec x x' with
  | left e  => n
  | right ne => s x'
  end.

(* ismetles *)
Definition e1 : exp := plus (var Y) (plus (var X) (var Y)).
Definition st1 : state := update Y 2 empty. (* st1-et modositsd, hogy e1 bizonyithato legyen! *)
Lemma e1test : eval e1 (update X 0 st1) = 4.
Proof.
simpl.
unfold update.
destruct (string_dec X Y).
* simpl. discriminate.
* simpl. unfold st1. simpl. unfold update.
** simpl. reflexivity.
Qed.

(* 
  Egyszeru kifejezesnyelv, valtozok, denotacios szemantika
  exp -> (state -> nat)
  
  operacios szemantika
  exp -> relacio

 *)

(* hf-bol *)
Lemma update_sound (x : string)(n : nat)(s : state) :
  (update x n s) x = n.
Proof.
(* tipp *) unfold update. destruct (string_dec x x).
* simpl. reflexivity.
*  assert False. apply n0. reflexivity. destruct H.
Qed.

Lemma update_neq (x x' : string)(n : nat)(s : state)(ne : x <> x') :
  (update x n s) x' = s x'.
Proof.
unfold update.
destruct (string_dec x x').
* simpl. assert False. apply ne. apply e. destruct H.
* simpl. reflexivity.
Qed.


(* Denotacios szemantika: egy e kifejezes jelentese egy 

     eval e : state -> nat

   fuggveny.

   Operacios szemantika: egy e kifejezes jelentese egy 

      evalo e : state -> exp -> Prop

   relacio.
 *)

(* Other relations in Coq:
   ----------------------- *)

Definition P : nat -> Prop
  := fun n => 3 <= n.

Example P3 : P 3.
Proof.
simpl. unfold P. reflexivity.
Qed.

(* hasznalj inversion-t! *)
Example notP2 : not (P 2).
Proof.
simpl.
intro.
inversion H.
inversion H1.
inversion H3.
Qed.


Definition R : nat -> nat -> Prop
  := fun a b => a + b = 10.

Example R46 : R 4 6.
Proof.
simpl. reflexivity.
Qed.

Example notR44 : not (R 4 4).
Proof.
simpl. intro.
unfold R in H.
discriminate H.
Qed.

Definition Q : nat -> nat -> Prop :=
  fun a b => (a + 1) = b. (* ird at ugy, hogy Q12 es notQ13 bizonyithatoak legyenek! *)

Example Q12 : Q 1 2.
Proof.
simpl. reflexivity.
Qed.

Example notQ13 : not (Q 1 3).
Proof.
simpl.
intro.
unfold Q in H. discriminate H.
Qed.

Definition Even' : nat -> Prop := fun n => exists m, 2*m = n.

Example even4' : Even' 4.
Proof. unfold Even'. exists 2. simpl. reflexivity. Qed.

Inductive Even : nat -> Prop :=
  | evenO : Even 0
  | evenSS : forall (n : nat), Even n -> Even (S (S n)).

Example even4 : Even 4.
Proof.
(*tipp*) apply evenSS.
simpl.
apply evenSS.
apply evenO.
Qed.

(* hasznald a repeat tacticle-t (meta-taktikat)! *)
Example even100 : Even 100.
Proof.
repeat (apply evenSS).
(*do 50 (apply evenSS).*)
apply evenO.
Qed.

(* hasznalj inversion-t! *)
Example notEven1 : not (Even 1).
Proof.
intro.
inversion H.
Qed.

Require Import Arith. (* egyszeru nat-okrol szolo egyenlosegek bizonyitasara *)
Lemma evenSound : forall n, Even n -> exists m, 2 * m = n.
Proof.
(* tipp *) intro n. intro. induction H.
* simpl. exists 0. reflexivity.
* destruct IHEven. exists (S x). rewrite <- H0. simpl. ring.
Qed.

(* https://www.cs.cornell.edu/courses/cs3110/2018sp/a5/coq-tactics-cheatsheet.html *)

(* hasznald a Nat.add_comm es plus_n_O lemmakat! *)
Lemma evenComplete' : forall x, Even (2 * x).
Proof.
intro.
simpl.
induction x.
* simpl. apply evenO.
* simpl. rewrite (Nat.add_comm x (S (x + 0))). simpl. apply evenSS.
rewrite <- (plus_n_O x). simpl in IHx. rewrite <- (plus_n_O x) in IHx. assumption.
Qed.

(* hasznald evenComplete'-ot! *)
Lemma evenComplete : forall n, (exists x, 2 * x = n) -> Even n.
Proof.
intro.
intro.
destruct H.
rewrite <- H.
apply evenComplete'.
Qed.

(* add meg az Odd : nat -> Prop predikatumot induktivan! *)
Inductive Odd : nat -> Prop :=
  | odd1 : Odd 1
  | oddSS : forall (n : nat), Odd n -> Odd (S (S n)).

Lemma oddProp : forall n, Odd n <-> exists m, 2 * m + 1 = n.
Proof.
intro.
split.
* intro. induction n.
Admitted.

(* Most megadunk induktivan egy relaciot a kifejezeseken.

Levezetesi szabalyok:

  ----------------------eval_var
  var x , s => lit (s x)
  kifejezes, state => kifejezes (big step)

          e1 , s => e1'
  -----------------------------eval_plus_lhs
  plus e1 e2 , s => plus e1' e2

               e2 , s => e2'
  ---------------------------------------eval_plus_rhs
  plus (lit n) e2 , s => plus (lit n) e2'

  ---------------------------------------eval_plus_fin
  plus (lit m) (lit n) , s => lit (m + n)


Ha s X = 1, vezesd le, hogy:


                  -------------------------eval_var
                    (var X) , s => (lit 1) 
-----------------------------------------------------eval_plus_lhs
  plus (var X) (lit 3) , s => plus (lit 1) (lit 3)
!

Mutasd meg, hogy


----------------------------------------- (nem lehet szabalyt illeszteni ra)
  plus (var X) (lit 3) , s => lit 4
nem levezetheto!

Vezesd le, hogy:

-------------------------------------------eval_plus_fin
  plus (lit 1) (lit 3) , s => lit 4
!

Vezesd le, hogy mire irodik at (tobb lepesben)


        ----------------------------eval_var
          (var X), s => lust (s X)
---------------------------------------eval_plus_lhs
  plus (var X) (var Y), s => plus (lit 1) (var Y)



         ------------------------------eval_var
            (var Y), s => (lit (s Y))
----------------------------------------------------eval_plus_rhs
plus (lit 1) (var Y), s => plus (lit (s X)) (lit (s Y))
!

Most megcsinaljuk ezeket formalisan is:
*)

Reserved Notation "e , s => e'" (at level 50).
Inductive evalo : exp -> state -> exp -> Prop :=
  | eval_var (x : string)(s : state) :

    var x , s => lit (s x)

  | eval_plus_lhs (e1 e2 e1' : exp)(s : state) :

    e1 , s => e1' ->
    (*-------------------------*)
    plus e1 e2 , s => plus e1' e2

  | eval_plus_rhs (e2 e2' : exp)(s : state)(n : nat) :

    e2 , s => e2' ->
    (*-----------------------------------*)
    plus (lit n) e2 , s => plus (lit n) e2'

  | eval_plus_fin (n m : nat)(s : state) :

    plus (lit m) (lit n) , s => lit (m + n)

  where "e , s => e'" := (evalo e s e').


(* 
          ----------------------eval_var
          (var X) , s => (lit 4)
  ------------------------------------------------eval_plus_lhs
  plus (var X) (lit 3) , s => plus (lit 4) (lit 3)
*)

Example eval1 : plus (var X) (lit 3) , (update X 4 empty) => plus (lit 4) (lit 3).
(* probald meg eval_plus_rhs-t alkalmazni! *)
Proof.
apply eval_plus_lhs.
apply eval_var.
Qed.

Example eval2 : forall s, plus (lit 4) (lit 3) , s => lit 7.
Proof.
intro.
apply eval_plus_fin.
Qed.

Example eval3 :
  plus (plus (var X) (lit 3)) (var Y) , (update X 4 empty) => 
  plus (plus (lit 4) (lit 3)) (var Y).
Proof.
apply eval_plus_lhs.
apply eval_plus_lhs.
apply eval_var.
Qed.

Example eval4 :
  plus (plus (lit 4) (lit 3)) (var Y) , (update X 4 empty) => 
  plus (lit 7) (var Y).
Proof.
apply eval_plus_lhs.
apply eval_plus_fin.
Qed.

Example eval5 :
  plus (lit 7) (var Y) , (update X 4 empty) => 
  plus (lit 7) (lit 0).
Proof.
apply eval_plus_rhs.
apply eval_var.
Qed.

Example eval6 :
  plus (lit 7) (lit 0) , (update X 4 empty) => 
  lit 7.
Proof.
apply eval_plus_fin.
Qed.

Example exStep : plus (lit 5) (plus (plus (plus (lit 2) (var X)) (lit 2)) (lit 3)) , (update X 4 empty) => 
                 plus (lit 5) (plus (plus (plus (lit 2) (lit 4)) (lit 2)) (lit 3)).
Proof.
apply eval_plus_rhs.
apply eval_plus_lhs.
apply eval_plus_lhs.
apply eval_plus_rhs.
apply eval_var.
Qed.

Lemma lem1 : ~ (lit 3 , empty => lit 100).
Proof.
intro.
inversion H.
Qed.

Lemma lem2 : forall n s, 
  ~ (lit n , s => plus (lit n) (lit 0)).
Proof.
intro.
intro.
intro.
inversion H.
Qed.

Lemma notrefl (e : exp)(s : state) : ~ (e , s => e).
Proof.
(* tipp *) intro. induction e.
* inversion H.
* inversion H.
* inversion H.
** apply IHe1. assumption.
** apply IHe2. assumption.
Qed.