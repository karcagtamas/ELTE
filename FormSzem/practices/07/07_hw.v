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

Reserved Notation "e , s => e'" (at level 50).
Inductive evalo : exp -> state -> exp -> Prop :=
  | eval_var (x : string)(s : state) :
    var x , s => lit (s x)
  | eval_plus_lhs (e1 e2 e1' : exp)(s : state) :
    e1 , s => e1' ->
    plus e1 e2 , s => plus e1' e2
  | eval_plus_rhs (e2 e2' : exp)(s : state)(n : nat) :
    e2 , s => e2' ->
    plus (lit n) e2 , s => plus (lit n) e2'
  | eval_plus_fin (n m : nat)(s : state) :
    plus (lit m) (lit n) , s => lit (m + n)
  where "e , s => e'" := (evalo e s e').

Reserved Notation "e , s =>* e'" (at level 50).
Inductive evalo_rtc : exp -> state -> exp -> Prop :=
  | eval_refl (e : exp)(s : state) : 
    e , s =>* e
  | eval_trans (e e' e'' : exp)(s : state) :
    e , s => e'    ->    e' , s =>* e'' ->
    e , s =>* e''
  where "e , s =>* e'" := (evalo_rtc e s e').

Example steps1 : plus (var X) (plus (var X) (lit 3)) , (update X 4 empty) =>* lit 11.
Proof.
apply eval_trans with (e' := plus (lit 4) (plus (var X) (lit 3))).
apply eval_plus_lhs.
apply eval_var.
apply eval_trans with (e' := plus (lit 4) (plus (lit 4) (lit 3))).
apply eval_plus_rhs.
apply eval_plus_lhs.
apply eval_var.
apply eval_trans with (e' := plus (lit 4) (lit 7)).
apply eval_plus_rhs.
apply eval_plus_fin.
apply eval_trans with (e' := lit 11).
apply eval_plus_fin.
apply eval_refl.
Qed.

Definition e3 : exp := plus (lit 5) (plus (plus (plus (lit 2) (var X)) (lit 2)) (lit 3)).

Example e3eval1step : exists (e3' : exp), e3 , (update X 4 empty) => e3'.
Proof.
exists (plus (lit 5) (plus (plus (plus (lit 2) (lit 4)) (lit 2)) (lit 3))).
apply eval_plus_rhs.
apply eval_plus_lhs.
apply eval_plus_lhs.
apply eval_plus_rhs.
apply eval_var.
Qed.

(* gondolkozz, ennek lehet tobb megoldasa is! *)
Example e3eval : exists (e3' : exp), e3 , (update X 4 empty) =>* e3'.
Proof.
exists (plus (lit 5) (plus (plus (plus (lit 2) (lit 4)) (lit 2)) (lit 3))).
apply eval_trans with ( e' := plus (lit 5) (plus (plus (plus (lit 2) (lit 4)) (lit 2)) (lit 3))).
apply eval_plus_rhs.
apply eval_plus_lhs.
apply eval_plus_lhs.
apply eval_plus_rhs.
apply eval_var.
apply eval_refl.
Qed.

Example e3eval' : exists (n : nat), e3 , (update X 4 empty) =>* lit n.
Proof.
exists 16.
apply eval_trans with (e' := plus (lit 5) (plus (plus (plus (lit 2) (lit 4)) (lit 2)) (lit 3))).
apply eval_plus_rhs.
apply eval_plus_lhs.
apply eval_plus_lhs.
apply eval_plus_rhs.
apply eval_var.
apply eval_trans with (e' := plus (lit 5) (plus (plus (lit 6) (lit 2)) (lit 3))).
apply eval_plus_rhs.
apply eval_plus_lhs.
apply eval_plus_lhs.
apply eval_plus_fin.
apply eval_trans with (e' := plus (lit 5) (plus (lit 8) (lit 3))).
apply eval_plus_rhs.
apply eval_plus_lhs.
apply eval_plus_fin.
apply eval_trans with (e' := plus (lit 5) (lit 11)).
apply eval_plus_rhs.
apply eval_plus_fin.
apply eval_trans with (e' := lit 16).
apply eval_plus_fin.
apply eval_refl.
Qed.

Definition eval_singl (e e' : exp)(s : state) : e , s => e' -> e , s =>* e'.
Proof.
intro.
inversion H.
* apply eval_trans with (e' := lit (s x)). apply eval_var. apply eval_refl.
* apply eval_trans with (e' := plus e1' e2). apply eval_plus_lhs. apply H0. apply eval_refl.
* apply eval_trans with (e' := plus (lit n) e2'). apply eval_plus_rhs. apply H0. apply eval_refl.
* apply eval_trans with (e' := lit (m + n)). apply eval_plus_fin. apply eval_refl.
Qed.

Example notPoss1 : forall s, ~ (plus (lit 1) (lit 2) , s => plus (lit 2) (lit 1)).
Proof.
intro.
intro.
inversion H.
Qed.

Example notPoss2 : forall s, ~ (plus (lit 1) (lit 2) , s => lit 2).
Proof.
intro.
intro.
inversion H.
Qed.

Example notPoss3 : forall s e x, ~ (e , s => var x).
Proof.
intro.
intro.
intro.
intro.
inversion H.
Qed.

Example notPoss4 : forall s e x, ~ (e , s => plus (var x) (lit 1)).
Proof.
intros. intro. inversion H. inversion H3. 
Qed.

(* nehezebb, itt indukciora van szukseg *)
Example notPoss5 : forall e e' s, ~ (e , s => plus e e').
Proof.
intro. induction e.
- intros. intro. inversion H.
- intros. intro. inversion H.
- intros. intro. inversion H.
  unfold not in IHe1. apply IHe1 with (e' := e')(s := s). assumption.
Qed.

Example notPoss6 : forall n s x, ~ (lit n , s =>* var x).
Proof.
intros.
intro.
inversion H.
inversion H0.
Qed.

(* hasznald notPoss6-ot! *)
Example notPoss7 : forall s, ~ (var X , s =>* var Y).
Proof.
intro.
intro.
inversion H.
inversion H0.
rewrite <- H7 in H1.
apply notPoss6 with (n := s X)(s := s)(x := Y). 
assumption.
Qed.

(* small step operacios szemantika es denotacios szemantika ekvivalenciaja, fakultativ *)

(* haladas tetele *)
Lemma progress (e : exp)(s : state) : 
  (exists (n : nat), e = lit n) \/ exists (e' : exp), e , s => e'.
induction e.
- left. exists n. reflexivity.
- right. exists (lit (s s0)). apply eval_var.
- right. destruct IHe1.
-- destruct H. rewrite H. destruct IHe2.
--- destruct H0. rewrite H0. exists (lit (x + x0)). apply eval_plus_fin.
--- destruct H0. exists (plus (lit x) x0). apply eval_plus_rhs. assumption.
-- destruct H. exists (plus x e2). apply eval_plus_lhs. assumption.
Qed.

Lemma determ : forall (e e0 : exp)(s : state), 
  e , s => e0 -> forall e1, e , s => e1 -> e0 = e1.
Proof.
intros e e0 s H. induction H. (* inversion, indukcios hipotezisek *)
* intro. intro. inversion H. reflexivity.
* intro. intro. inversion H0.
** assert (e1' = e1'0). apply IHevalo. assumption. rewrite H6. reflexivity.
** rewrite <- H1 in H. inversion H.
** rewrite <- H2 in H. inversion H.
* intros. inversion H0.
** inversion H5.
** assert (e2' = e2'0). apply IHevalo. assumption. rewrite H6. reflexivity.
** rewrite <- H3 in H. inversion H.
* intros. inversion H.
** inversion H4.
** inversion H4.
** reflexivity.
Qed.

(* reflexiv, tranzitiv lezart tenyleg tranzitiv: *)
Lemma trans (e e' e'' : exp)(s : state) : e , s =>* e' -> e' , s =>* e'' -> e , s =>* e''.
Proof.
intros.
induction H.
* assumption.
* apply (eval_trans _ _ _ _ H). apply IHevalo_rtc. assumption.
Qed.

Definition eval_singl (e e' : exp)(s : state) : e , s => e' -> e , s =>* e'.
Admitted.

Lemma eval_plus_lhs_rtc (e1 e1' e2 : exp)(s : state) : e1 , s =>* e1' ->
  plus e1 e2 , s =>* plus e1' e2.
Admitted.

Lemma eval_plus_rhs_rtc (n : nat)(e2 e2' : exp)(s : state) : e2 , s =>* e2' -> 
  plus (lit n) e2 , s =>* plus (lit n) e2'.
Admitted.

Lemma operDenot (e : exp)(s : state) : e , s =>* lit (eval e s).
Admitted.

Lemma totality (e : exp)(s : state) : exists (n : nat), e , s =>* lit n.
Admitted.

Require Import Coq.Program.Equality.

Lemma determ_rtc (e : exp)(s : state)(n0 : nat) : e , s =>* lit n0 -> forall n1, e , s =>* lit n1 -> n0 = n1.
Admitted.

Lemma denotVsOper (e : exp)(s : state)(n : nat) : eval e s = n  e , s =>* lit n.
Admitted.