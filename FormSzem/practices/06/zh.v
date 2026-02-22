(* BEGIN FIX *)
Require Import Strings.String.

Inductive exp : Type :=
  | lit : nat -> exp
  | var : string -> exp
  | sub : exp -> exp -> exp
  | plus : exp -> exp -> exp.
Definition state : Type := string -> nat.
Fixpoint eval (e : exp)(s : state) : nat :=
  match e with
  | lit n => n
  | var x => s x
  | sub e1 e2 => eval e1 s - eval e2 s
  | plus e1 e2 => eval e1 s + eval e2 s
  end.
Definition empty : state := fun x => 0.
Definition update (x : string)(n : nat)(s : state)
  : state := fun x' => match string_dec x x' with
  | left e  => n
  | right ne => s x'
  end.

Definition W : string := "W".
Definition X : string := "X".
Definition Y : string := "Y".
Definition Z : string := "Z".

Definition e1 : exp := plus (plus (var W) (lit 3)) (var X).

Definition s2 : state := update X 1 (update Y 2 empty).

(* Ugy add meg e2-t, hogy e2test-et be tudd bizonyitani! *)
Definition e2 : exp :=
(* END FIX *)
plus (plus (var Y) (var Y)) (lit 1).

(* Ide ird e2 megoldasat! Ne az END FIX ele! *)

(* BEGIN FIX *)
Lemma e2test : eval e2 empty = 1 /\ eval e2 s2 = 5.
(* END FIX *)
Proof.
simpl.
split.
* reflexivity.
* reflexivity.
Qed.