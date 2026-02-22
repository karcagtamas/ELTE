(* HF *)

Lemma pl (A B : Prop) : A /\ B -> (B /\ A) \/ A.
Proof.
intro.
destruct H.
left.
split.
* assumption. (* exact H0. *)
* assumption.
Qed.

Lemma egyszeru (A : Prop) : False -> A.
Proof.
intro.
destruct H.
Qed.

(*
  Logika a Coqban:
                                A cel ilyen alaku       Ha egy feltetel ilyen alaku (vagy korabbi Lemma)
  logikai osszekoto             bevezeto                eliminacios
  /\ (and)                      split                   destruct
  \/ (or)                       left, right             destruct
  True                          split
  False                                                 destruct
  ->                            intro                   apply
  forall                        intro                   apply
  exists                        exists                  destruct
  =                             reflexivity.            rewrite
------------------------------------------------------------------------------------------------
  Nat                                                   induction
------------------------------------------------------------------------------------------------
  akarmi, de a cel = feltetel                           assumption
*)


(* Aritmetikai kifejezesnyelv es denotacios szemantika, pelda
   kiertekelesek 

    bin_tree, height, sum
    aexp, aeval, leaves_cnt, height

*)

From Coq Require Import Init.Nat.

Check nat.

Check 5.

Compute 1 + 3.

(* absztrakcios szintek*)

(*a ::= n | a1 + a2 | a1 - a2*)
(*a ::= alit(n) | plus(a1,a2) | sub(a1,a2)*)
Inductive AExp : Type := (* Artihmetic expressions *)
| ALit (n : nat)
| APlus (a1 a2 : AExp)
| ASub (a1 a2 : AExp)
.

(* Checkek *)
(* (5 + 7) - 42 *)
Check (ASub (APlus (ALit 5) (ALit 7)) (ALit 42)).

(*
Ird le, mint AExp elemet!
    +
   / \
  +   3
 / \
1  2
*)
Definition t1 : AExp := APlus (APlus (ALit 1) (ALit 2)) (ALit 3).

(*
Ird le, mint AExp elemet!
    +
   / \
  1   +
     / \
    2   3
*)
Definition t1' : AExp := APlus (ALit 1) (APlus (ALit 2) (ALit 3)).

(*
Ird le, mint AExp elemet!
    +
   / \
  3   +
     / \
    1  2
*)
Definition t1'' : AExp := APlus (ALit 3) (APlus (ALit 1) (ALit 2)).

(*
Ird le, mint AExp elemet!
     -
   /  \
  +    +
 / \   /\
1  2  +  3
     / \
    4  5
*)
Definition t2 : AExp := ASub (APlus (ALit 1) (ALit 2)) (APlus (APlus (ALit 4) (ALit 5)) (ALit 3)).


(* Rajzold le! *)
Definition t3 := ASub (APlus (ALit 5) (ALit 7)) (ALit 42).
Definition t3' := ASub (APlus (ALit 5) (ALit 7)) (ALit 42).

Compute 5 - 15.
Compute (ASub (ALit 5) (ALit 15)).

(* notation AExp-re is *)
Notation "x + y" := (APlus x y) (at level 50, left associativity).
Notation "x - y" := (ASub x y) (at level 50, left associativity).
Coercion ALit : nat >-> AExp.

Definition ae : AExp := ALit 2 + (ALit 3 - ALit 1).
Definition ae' : AExp := 2 + (3 - 1).
Check 1 + 1.

Compute ae.

Example egyenlosed : 1 + 1 = APlus (ALit 1) (ALit 1).
Proof.
simpl. reflexivity.
Qed.

(* Denotacios szemantikaja az AExp nyelvnek *)
Fixpoint aeval (a : AExp) : nat :=
match a with
 | ALit n => n
 | APlus a1 a2 => aeval a1 + aeval a2
 | ASub a1 a2 => aeval a1 - aeval a2
end.

Compute aeval t1.
Compute aeval t2.

Fixpoint leaves_count (a : AExp) : nat :=
match a with
| ALit n => 1
| APlus a1 a2 => leaves_count a1 + leaves_count a2
| ASub a1 a2 =>  leaves_count a1 + leaves_count a2
end
.

Compute leaves_count t1.
Compute leaves_count t3'.

From Coq Require Import Arith.PeanoNat.

Lemma leaf_l_r: forall a1 a2 : AExp, leaves_count (APlus a1 a2) = leaves_count (APlus a2 a1).
Proof.
simpl.
intro.
intro.
apply Nat.add_comm.
Qed.


Lemma leaf_l_r2: forall a1 a2 : AExp, leaves_count (APlus a1 a2) = leaves_count (APlus a2 a1).
Proof.
simpl.
intro.
intro.
apply Nat.add_comm.
Qed.