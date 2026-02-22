(* This is a comment *)
(* Inductive type - Days what are can be the days of the week. *)
Inductive day : Type :=
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday.

(* Definition - function *)
(* Name: aday; Type: day; Definition: it only returns a type *)
Definition aday : day := thursday.

(* Write out the result of the aday func *)
Compute aday.

(* Pattern matching *)
Definition next_weekday (a : day) : day :=
  match a with
  | monday  => tuesday
  | tuesday => wednesday
  | wednesday => thursday
  | thursday => friday
  | friday => saturday
  | saturday => sunday
  | sunday => monday
  end.

Compute next_weekday (next_weekday wednesday).

(* Theory [NAME]*)
(* The theory is the type (after :) *)
Theorem test_next_weekday :
  (next_weekday (next_weekday saturday)) =
    monday.
(* tactics *)
(* Proof - start of the tactic *)
Proof.
simpl. (* Simple *)
reflexivity. (* Reflexivity *)
(* Qed - end of the tactic *)
Qed.

(* Theory - with other key-word *)
Lemma next7 (d : day) :
   next_weekday (next_weekday (next_weekday (
   next_weekday (next_weekday (next_weekday (
   next_weekday d)))))) = d.
Proof.
simpl.
destruct d.
simpl. reflexivity.
simpl. reflexivity.
simpl. reflexivity.
simpl. reflexivity.
simpl. reflexivity.
simpl. reflexivity.
simpl. reflexivity.
Qed.

Inductive bool : Type :=
  | true
  | false.

(* orb
   notb
   orb true false = true
   (a : bool) : orb true a = true
*)

Definition orb (a : bool)(b : bool) : bool :=
  match a with
  | true => true
  | false => b
  end.

Lemma orb_test : orb true false = true.
Proof.
simpl. reflexivity.
Qed.

Lemma orb_test1 (a : bool) : orb true a = true.
Proof.
simpl. reflexivity.
Qed.

Lemma orb_test2 (a : bool) : orb a true = true.
Proof.
simpl.
destruct a.
simpl. reflexivity.
simpl. reflexivity.
Qed.

Lemma orb_comm (a b : bool) : orb a b = orb b a.
Proof.
simpl.
destruct a.
simpl.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
simpl.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
Qed.

Lemma orb_comm_o (a b : bool) : orb a b = orb b a.
Proof.
destruct a eqn:H.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
simpl.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
Qed.

Lemma orb_comm' (a b : bool) : orb a b = orb b a.
Proof.
simpl.
destruct a.
simpl.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
simpl.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
Qed.

(*
Inductive (tipus), Definition (fv), match, Theorem (theory), Lemma (same as Theorem), Proof (Start of proof), Qed (end of proof),
simpl (simple), unfold, reflexivity (belatas), destruct (eset szetvalasztas - Inductive elemekre)
*)

(* HF
andb
notb (andb a b) = orb (notb a) (notb b)
notb (orb a b) = andb (notb a) (notb b)
*)

Definition andb (a: bool) (b: bool): bool :=
  match a with
  | true => b
  | false => false
  end.

Definition notb (a: bool) : bool := 
  match a with
  | true => false
  | false => true
  end.

Lemma test1 (a: bool) (b: bool) : notb (andb a b) = orb (notb a) (notb b).
Proof.
simpl.
destruct a.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
Qed.

Lemma test2 (a: bool) (b: bool) : notb (orb a b) = andb (notb a) (notb b).
Proof.
simpl.
destruct a.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
Qed.

(* nehez! *)

Lemma nehez (f : bool -> bool)(x : bool) : f (f (f x)) = f x.
Proof.
simpl.
destruct (f true) eqn:Htrue.
destruct (f false) eqn:HFalse.
destruct x.
rewrite Htrue.
rewrite Htrue.
rewrite Htrue.
simpl. reflexivity.
rewrite HFalse.
rewrite Htrue.
rewrite Htrue.
simpl. reflexivity.
destruct x.
rewrite Htrue.
rewrite Htrue.
rewrite Htrue.
simpl. reflexivity.
rewrite HFalse.
rewrite HFalse.
rewrite HFalse.
simpl. reflexivity.
destruct (f false) eqn:HFalse.
destruct x.
rewrite Htrue.
rewrite HFalse.
rewrite Htrue.
simpl. reflexivity.
rewrite HFalse.
rewrite Htrue.
rewrite HFalse.
simpl. reflexivity.
destruct x.
rewrite Htrue.
rewrite HFalse.
rewrite HFalse.
simpl. reflexivity.
rewrite HFalse.
rewrite HFalse.
rewrite HFalse.
simpl. reflexivity.
Qed.

(*
Definition orb (a b : bool) : bool :=
Definition orb : bool -> bool -> bool :=
  fun a => fun b => match ...
*)
