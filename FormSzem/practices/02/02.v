
(*
    negneg, andor, orand, nat, is_one, double, plus, four, six, dummy_zero, plus_left_id, plus_right_id, plus_r_s, succ_cong

    Fixpoint, Notation (+)

    induction, rewrite, symmetry
*)

(*Inductive Bool : Type :=
  | true : Bool
  | false : Bool.*)
(* Bool = {true, false} *)
(* Natural numbers *)
Inductive Nat : Type :=
  | O : Nat (* Zero *)
  | S : Nat -> Nat.
(* Nat = { O, S O, S (S O), S (S (S O))} *)
(*         0   1      2           3*)

Definition four : Nat := S (S (S (S O))).
Definition six  : Nat := S (S four).

Definition isOne (n : Nat) : bool :=
(* fun-nal is *)
match n with
| S O => true
| _ => false
end.

Definition isOne' : Nat -> bool := fun n => match n with
| S O => true
| _ => false
end.

Compute isOne four.
Compute isOne six.
Compute isOne O.
Compute isOne (S O).

Lemma oneIsOne : isOne (S O) = true.
Proof.
simpl. reflexivity.
Qed.

Lemma notIsOne (n : Nat) : isOne (S (S n)) = false.
Proof.
simpl. reflexivity.
Qed.

Fixpoint twice (n : Nat) : Nat := 
match n with
| O => O
| S m => S (S (twice m))
end.

Fixpoint replaceOWith(m n : Nat) : Nat := match n with
| O => m
| S x => S (replaceOWith m x)
end.

Definition twice' (n : Nat) := replaceOWith n n.

Compute twice six.
Compute twice O.
Compute twice (S O).
Compute twice (S (S O)).

Lemma SStwice : forall (n : Nat),
  S (S (S (twice n))) = S (twice (S n)).
Proof.
intro n.
simpl. reflexivity.
Qed.

Lemma SStwice' (n : Nat) : S (S ( S (twice n))) = S (twice (S n)).
Proof.
simpl.
reflexivity.
Qed.

Fixpoint f (n : Nat) : Nat := match n with
  | O => O
  | S n => f n
  end.

Check O.
Check Type.
Check S (O).
Check S.
Check f.

Lemma f0 (a : Nat) : f a = O.
Proof.
induction a.
* simpl. reflexivity.
* simpl. (*rewrite IHa. reflexivity.*) assumption.
Qed.
(* Teljes indukcio:
    Alapeset: P O
    Induktiveset: forall (m : Nat), P m -> P (S m)

    -------------------
    forall (n: Nat), P n
    P n := (f n = 0)
    Alapeset: f O = O
    Induktiveset: forall (m : Nat), f m = O -> f (S m) = O
    -------------------
    forall (n : Nat), f n = 0
*)
(*

  * karakter => focus goal
  induction a. => teljes indukcio to
  assumption => belatas
*)


(* Fixpoint f (n : Nat) : Nat := f n. *)

Fixpoint plus (n m : Nat) {struct n} : Nat :=
match n with
| O => m
| S x => S (plus x m)
end.


Compute plus four (S O).
Compute plus (twice six) (twice four).

Notation "x + y" := (plus x y)
  (at level 50, left associativity).

Lemma leftid (n : Nat) : O + n = n.
Proof.
simpl. reflexivity.
Qed.

Lemma rightid (n : Nat) : n + O = n.
Proof.
induction n.
* simpl. reflexivity.
* simpl. rewrite IHn. reflexivity.
Qed.

Lemma assoc (a b c : Nat) : (a + b) + c = a + (b + c).
Proof.
induction a.
simpl. reflexivity.
simpl. rewrite IHa. simpl. reflexivity.
Qed.


Lemma cong (f : Nat -> Nat)(a b : Nat) : a = b -> f a = f b.
Proof.
intro. rewrite H. reflexivity.
Qed.

(*
        bevezeto szabaly      elminiacios
->      intro                 apply
forall  intro                 apply
=       reflexivity, symmetry  rewrite
---------------------------------------
Nat     O, S                  induction, destruct
*)

Lemma plus_r_s : forall (a b : Nat), S a + b = a + S b.
Proof.
intro a.
intro b.
simpl.
induction a.
simpl. reflexivity.
simpl. apply (cong S).
assumption.
(*simpl. rewrite IHa.
simpl. reflexivity.*)
Qed.
(*
  P a = S (a + b) = a + S b
  P O = (S b = S b)
  (forall n, P n -> P (S n) = forall n, S (n + b) = n + S b -> S ( S (n + b)) = S (n + S b))
*)

Check cong S.

Lemma comm (a b : Nat) : a + b = b + a.
Proof.
induction a.
* simpl. symmetry. apply rightid.
* simpl. rewrite IHa. apply plus_r_s.
Qed.

Check rightid.

Definition pred (n : Nat) : Nat :=
match n with
| O => O
| S n => n
end.

Lemma S_inj (a b : Nat) : S a = S b -> a = b.
Proof.
intro.
simpl.
apply (cong pred (S a) (S b)).
assumption.
Qed.

(*Definition P : Nat -> Prop := fun n =>*)

(*
Lemma O_S_disj (a : Nat) : O <> S a.
Proof.
Qed.
*)

Fixpoint times (a b : Nat) : Nat :=
match a with
| O => O
| S O => b
| S x => plus b (times x b)
end.

Notation "x * y" := (times x y)
  (at level 40, left associativity).

Lemma times_leftid (a : Nat) : S O * a = a.
Proof.
simpl.
simpl. reflexivity.
Qed.

Lemma times_rightid (a : Nat) : a * S O = a.
Proof.
simpl.
induction a.
* simpl. reflexivity.
* simpl. rewrite IHa.
** destruct a.
*** simpl. reflexivity.
*** simpl. reflexivity.
Qed.

Lemma times_leftzero (a : Nat) : O * a = O.
Proof.
simpl. reflexivity.
Qed.

Lemma times_rightzero (a : Nat) : a * O = O.
Proof.
induction a.
* simpl. reflexivity.
* simpl. rewrite IHa.
** simpl. destruct a.
*** reflexivity.
*** reflexivity.
Qed.

Lemma times_assoc (a b c : Nat) : (a * b) * c = a * (b * c).
Proof.
simpl.
induction a.
induction b.
induction c.
* simpl. reflexivity.
* simpl. reflexivity.
* simpl. reflexivity.
* simpl. induction a. induction b. induction c.
** simpl. reflexivity.
** simpl. reflexivity.
** simpl. reflexivity.
** simpl. reduction b.
Qed.

Lemma times_comm (a b : Nat) : a * b = b * a.

Fixpoint max (a b : Nat) : Nat :=

Lemma decEq (a b : Nat) : a = b \/ a <> b.

Compute (max four six).

Inductive BinaryTree : Type :=
| Leaf (n : Nat)
| Node (l r : BinaryTree).

Fixpoint height (t : BinaryTree) : Nat :=

Fixpoint leaves_count (t : BinaryTree) : Nat :=

Fixpoint sum1 (t : BinaryTree) : Nat :=
match t with
| Leaf n => n
| Node l r => sum1 l + sum1 r
end.

Fixpoint sum2 (t : BinaryTree) : Nat :=
match t with
| Leaf n => n
| Node l r => sum2 r + sum2 l
end.

Lemma sum1_2_eq : forall t : BinaryTree, sum1 t = sum2 t.