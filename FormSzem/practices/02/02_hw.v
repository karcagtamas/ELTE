(* BEGIN FIX *)
(** Pótold a hiányzó kódrészleteket! A BEGIN FIX és END FIX közötti részeket ne módosítsd! Akkor jó a megoldásod, ha a Coq elfogadja az egészet (zöld lesz a teljes fájl).*)
(** Fill out the missing parts! Do not modify the code between BEGIN FIX and END FIX! *)

Inductive Nat : Type :=
  | O : Nat
  | S : Nat -> Nat.

Fixpoint plus (n m : Nat) {struct n} : Nat := match n with
| O => m
| S n' => S (plus n' m)
end.

Notation "x + y" := (plus x y)
  (at level 50, left associativity).

Lemma leftid (n : Nat) : O + n = n.
Proof. simpl. reflexivity. Qed.

Lemma rightid (n : Nat) : n + O = n.
Proof. simpl. induction n.
* reflexivity.
* simpl. rewrite -> IHn. reflexivity. Qed.

Lemma assoc (a b c : Nat) : (a + b) + c = a + (b + c).
(* END FIX *)
Proof.
induction a.
* simpl. reflexivity.
* simpl. rewrite IHa. reflexivity.
Qed.

(* BEGIN FIX *)
Lemma cong (f : Nat -> Nat)(a b : Nat) : a = b -> f a = f b.
(* END FIX *)
Proof.
intro.
induction a.
* simpl. rewrite H. reflexivity.
* simpl. rewrite H. reflexivity.
Qed.

(* BEGIN FIX *)
Lemma plus_r_s : forall (a b : Nat), S a + b = a + S b.
(* END FIX *)
Proof.
intro a.
intro b.
simpl.
induction a.
* simpl. reflexivity.
* simpl. rewrite IHa. reflexivity.
Qed.

(* BEGIN FIX *)
Lemma comm (a b : Nat) : a + b = b + a.
(* END FIX *)
Proof.
induction a.
* simpl. symmetry. apply rightid.
* simpl. rewrite IHa. apply plus_r_s.
Qed.

(* BEGIN FIX *)
Fixpoint times (a b : Nat) : Nat := match a with
| O => O
| S n => b + (times n b)
end.

Notation "x * y" := (times x y)
  (at level 40, left associativity).

Lemma times_leftid (a : Nat) : S O * a = a.
(* END FIX *)
Proof.
simpl.
induction a.
* simpl. reflexivity.
* simpl. rewrite IHa. reflexivity.
Qed.

(* BEGIN FIX *)
Lemma times_rightid (a : Nat) : a * S O = a.
(* END FIX *)
Proof.
simpl.
induction a.
* simpl. reflexivity.
* simpl. rewrite IHa. reflexivity.
Qed.

(* BEGIN FIX *)
Lemma times_leftzero (a : Nat) : O * a = O.
(* END FIX *)
Proof.
simpl. reflexivity.
Qed.

(* BEGIN FIX *)
Lemma times_rightzero (a : Nat) : a * O = O.
(* END FIX *)
Proof.
simpl.
induction a.
* simpl. reflexivity.
* simpl. assumption.
Qed.

Lemma rdistr (a b c : Nat) : (a + b) * c =  a * c + b * c.
Proof.
induction a.
- reflexivity.
(*- simpl. rewrite -> IHa. rewrite -> (assoc c (a * c) (b * c)). reflexivity.*)
- simpl. rewrite IHa. symmetry. apply assoc.
Qed.

(* BEGIN FIX *)
Lemma times_assoc (a b c : Nat) : (a * b) * c = a * (b * c).
(* END FIX *)
Proof.
simpl.
induction a.
* simpl. reflexivity.
* simpl. rewrite <- IHa. apply rdistr.
Qed.

(* BEGIN FIX *)
Lemma times_comm (a b : Nat) : a * b = b * a.
(* END FIX *)
Proof.
Qed.




