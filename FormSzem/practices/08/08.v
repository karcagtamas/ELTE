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

(* big step operational semantics *)

Reserved Notation "e , s =v n" (at level 50).
Inductive evalb : exp -> state -> nat -> Prop :=
  | evalb_lit (n : nat)(s : state) :

    (*------------------*)
    lit n , s =v n

  | evalb_var (x : string)(s : state) :

    (*------------------*)
    var x , s =v s x

  | evalb_plus (n1 n2 : nat)(e1 e2 : exp)(s : state) :

    e1 , s =v n1  ->  e2 , s =v n2 ->
    (*----------------------------*)
    plus e1 e2 , s =v (n1 + n2)

  where "e , s =v n" := (evalb e s n).


(*
s = W |-> 200, X |-> 0

Levezetesi fa megadasa, aminek a gyokere az, amit ki akarunk ertekelni

-------------evalb_var   ------------evalb_var
  W, s =v 200               X, S =v 0
-------------------------------------evalb_plus               -----------------evalb_lit
  W + X, s =v 200                                               100, s =v 100
--------------------------------------------------------------------------------evalb_plus
  (W + X) + 100, s =v 300
*)

Example ex1 : eval (plus (plus (var W) (var X)) (lit 100)) 
                     (update W 200 empty) = 300.
Proof.
simpl.
reflexivity.
Qed.

Example ex1b : plus (plus (var W) (var X)) (lit 100) ,
                     update W 200 empty =v 300.
Proof.
Check evalb_plus.
pose proof (evalb_plus).
specialize (H 200 100).
(*apply evalb_plus with (n1 := 200) (n2 := 100).*)
simpl in H.
apply H.
apply (evalb_plus 200 0). (* Mukodik mert az elso ket parameter az n1 es n2 -> nevszerinti atadas with segitsegevel *)
apply evalb_var.
apply evalb_var.
apply evalb_lit.
Qed.

Example ex1b_not : ~ plus (plus (var W) (var X)) (lit 100) ,
                     update W 201 empty =v 300.
Proof.
intro.
(* eapply evalb_plus in H. <- ez tovabbi plus kifejezesek levezetesere kovetkeztet *)
inversion H. subst. (* subst - rewrite-ol a hipotezisekben es kitorli a felesleget *) clear H. (* eltorli H-t *)
inversion H4. subst. clear H4. (* Megkerdezi a Coq-tol hogy hogyan kaphattuk ezt a hipotezist *)
inversion H5. subst. clear H5.
inversion H1. subst. clear H1.
inversion H7. subst. clear H7.
(* discriminate *)
cbn in H2. (* ugyanaz mint a simpl. csak tobb mindent unfoldol egyszerusites kozben *)
inversion H2.
Qed.

Example ex2b : exists (n : nat),
  plus (plus (var X) (var Y)) (plus (lit 3) (var Z)) , 
  update X 3 (update Y 2 empty) =v n.
Proof.
exists 8.
(* replace 8 with (5 + 3) by reflexivity. - by reflexivity -> ha az uj goal belathato reflexivitassal, akkor azonnal belatja*)
apply (evalb_plus 5 3).
apply (evalb_plus 3 2).
apply evalb_var.
apply evalb_var.
apply (evalb_plus 3 0).
apply evalb_lit.
apply evalb_var.
Qed.


Lemma denot2bigstep (e : exp)(s : state) : forall (n : nat), eval e s = n -> e , s =v n.
Proof.
induction e; intros. (* Erdemes minel elobb induction-t hasznalni, mert az intros takarithat ki dolgokat, amik miatt nem lesz hasnzalhato az indukcios hipotezis *)
* simpl in H. rewrite H. apply evalb_lit.
* simpl in H. rewrite <- H. apply evalb_var.
* simpl in H. rewrite <- H. apply evalb_plus.
  - apply IHe1. reflexivity.
  - apply IHe2. reflexivity.
Qed.

Lemma bigstep2denot (e : exp)(s : state) : forall (n : nat), e , s =v n -> eval e s = n.
Proof.
intros. induction H. (* Levezetes szerinti indukcio *)
* simpl. reflexivity.
* simpl. reflexivity.
* simpl. rewrite IHevalb1. rewrite IHevalb2. reflexivity.
Qed.

(* no need for induction. just use bigstep2denot! *)
Lemma determBigstep (e : exp)(s : state)(n : nat) : e , s =v n -> forall n', e , s =v n' -> n = n'.
Proof.
(*intro. induction H.*)
intros.
apply bigstep2denot in H, H0.
rewrite <- H. rewrite <- H0. reflexivity.
Qed.

Lemma totality :
  forall (e: exp) (s: state), exists (n: nat), e, s =v n.
Proof.
intros.
exists (eval e s).
apply denot2bigstep. (* Nem kell definialni a denotacios totalitas, mert azok fuggvenyek, es Coq-ban minden fv totalis *)
reflexivity.
Qed.

Lemma bigstepVsdenot (e : exp)(s : state)(n : nat) : e , s =v n <-> eval e s = n.
Proof.
split.
* apply bigstep2denot.
* apply denot2bigstep.
Qed.


Lemma notInvertible (n : nat)(s : state) : 
  exists (e e' : exp), e <> e' /\ e , s =v n /\ e' , s =v n.
Proof.
Admitted.