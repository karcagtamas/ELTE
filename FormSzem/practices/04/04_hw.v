Inductive AExp : Type :=
| ALit (n : nat)
| APlus (a1 a2 : AExp)
| ASub (a1 a2 : AExp)
.

Notation "x + y" := (APlus x y) (at level 50, left associativity).
Notation "x - y" := (ASub x y) (at level 50, left associativity).
Coercion ALit : nat >-> AExp.

(* Ez az AExp-hez tartozo indukcio elve. *)
Lemma AExp_ind' : forall P : AExp -> Prop,
       (forall n : nat, P (ALit n)) ->
       (forall a1 : AExp,
        P a1 -> forall a2 : AExp, P a2 -> P (APlus a1 a2)) ->
       (forall a1 : AExp,
        P a1 -> forall a2 : AExp, P a2 -> P (ASub a1 a2)) ->
       forall a : AExp, P a.
(* hasznalj induction-t! *)
Proof.
induction a.
apply H.
apply H0. assumption. assumption.
apply H1. assumption. assumption.
Qed.

Fixpoint aeval (a : AExp) : nat :=
match a with
 | ALit n => n
 | APlus a1 a2 => aeval a1 + aeval a2
 | ASub a1 a2 => aeval a1 - aeval a2
end.

(* ez egy pelda a discriminate taktika hasznalatara.
ha van egy egyenlosegunk, aminek a ket oldalan kulonbozo
konstruktorok vannak, akkor abbol be tudunk latni barmit.
*)

Lemma nemegyenlo : ~ (ALit 3 = APlus (ALit 3) (ALit 0)).
Proof. intro. discriminate H. Qed.

Lemma nemInj : ~ (forall a1 a2, aeval a1 = aeval a2 -> a1 = a2).
(* adj meg ket olyan kifejezest, melyek szemantikaja ugyanaz, de kulonboznek! 
hasznald a discriminate taktikat!
*)
Proof.
intro.
assert (ALit 0 = APlus (ALit 0) (ALit 0)).
apply H.
simpl.
reflexivity.
discriminate H0.
Qed.

Example mkExp : exists a, aeval a = 3.
(* hasznald az exists taktikat! *)
Proof.
exists (ALit 3).
simpl. reflexivity.
Qed.

Example mkExp2 : exists a1 a2, aeval a1 = aeval a2 /\ aeval a1 = 4 /\ a1 <> a2.
(* hasznald az exists es split taktikakat! *)
Proof.
simpl.
exists (ALit 4).
exists (APlus (ALit 0) (ALit 4)).
split.
simpl. reflexivity.
simpl. split.
simpl. reflexivity.
discriminate.
Qed.

Example notSubterm : forall (a b : AExp), APlus b a <> a.
(* indukcio a-n, hasznald discriminate-et es inversion-t *)
Proof.
intros.
induction a.
* discriminate.
* intro. inversion H. apply IHa2. rewrite H1. simpl. assumption.
* discriminate.
Qed.

Fixpoint leaves (a : AExp) : nat := match a with
  | ALit n => 1
  | APlus a1 a2 => leaves a1 + leaves a2
  | ASub a1 a2 => leaves a1 + leaves a2
  end.

Example ex1 : leaves (APlus (ALit 1) (APlus (ALit 2) (ALit 3))) = 3.
Proof.
simpl. reflexivity.
Qed.

Example ex2 : leaves (APlus (ALit 1) (ALit 1)) = 2.
Proof.
simpl. reflexivity.
Qed.

Example ex3 : leaves (ALit 1) = 1.
Proof.
simpl. reflexivity.
Qed.

Lemma l1 : forall a1 a2, leaves (ASub a1 a2) = leaves (APlus a1 a2).
Proof.
intros.
simpl. reflexivity.
Qed.


Require Import Nat.
Require Import Arith.

Check max.
Fixpoint height (a : AExp) : nat :=
(* hasznald a max fuggvenyt! *)
match a with
| ALit n => 0
| APlus a1 a2 => 1 + max (height a1) (height a2)
| ASub a1 a2 => 1 + max (height a1) (height a2)
end.


Example ex4 : height (APlus (ALit 1) (APlus (ALit 2) (ALit 3))) = 2.
Proof.
simpl. reflexivity.
Qed.

Example ex5 : height (APlus (ALit 1) (ALit 1)) = 1.
Proof.
simpl. reflexivity.
Qed.

Lemma l2 : forall a1 a2, height (ASub a1 a2) = height (APlus a1 a2).
Proof.
intros.
simpl. reflexivity.
Qed.

Example expWithProperty : exists (a : AExp), leaves a = 3 /\ height a = 2.
(* /\ bizonyitasanal hasznalj split-et *)
Proof.
exists (APlus (APlus (ALit 1) (ALit 2)) (ALit 3)).
split.
simpl. reflexivity.
simpl. reflexivity.
Qed.

Example notPoss : 
  not (exists (a : AExp), leaves a = 2 /\ height a = 0).
(* hasznalj destruct-ot es discriminate-t! *)
Proof.
intro.
destruct H.
destruct H.
destruct x.
* discriminate.
* discriminate.
* discriminate.
Qed.

(* Bizonyitsd be az inversion taktika nelkul! (hasznald a pred fuggvenyt) *)
Lemma inversionS (a b : nat) : S a = S b -> a = b.
Proof. Check pred. Compute (pred 3).
intro. assert (pred (S a) = pred (S b)).
* rewrite H. simpl. reflexivity.
* simpl in H0. assumption.
Qed.

Lemma heightPlus : forall a : AExp, height (APlus (ALit 0) a) = (1 + height a)%nat.
(* nem kell indukcio *)
Proof.
intro.
simpl. reflexivity.
Qed.

Lemma notPlus : forall n, 1 + n <> n.
(* indukcio n-en, hasznald: discriminate, inversion *)
Proof.
intro.
induction n.
* discriminate.
* simpl. intro. inversion H. apply IHn2. assumption.
* simpl. intro. inversion H.
Qed.

(* oran kimaradt *)
Fixpoint optim' (a : AExp) : AExp :=
  match a with
  | ALit n => ALit n
  | APlus (ALit x) (ALit y) => ALit (x + y)
  | APlus e1 e2 => APlus (optim' e1) (optim' e2)
  | ASub  e1 e2 => ASub  (optim' e1) (optim' e2)
  end.

(*Lemma optim'_sound (a : AExp) : aeval (optim' a) = aeval a.
Proof.
simpl.
induction a.
* simpl. reflexivity.
Qed.*)

(* Innentol fakultativ feladatok. *)

Definition f : nat -> Prop := fun a => match a with
  | O => True
  | S _ => False
  end.

(* a kovetkezo feladatbol latszik, hogy a 
   discriminate taktika belul hogyan mukodik *)
(* hasznald f-et, ne hasznald discriminate-et! hasznalj assert-et. *)
Lemma discriminateOS (a : nat) : O <> S a.
Proof.
intro.
assert (f O = f (S O)).
simpl. discriminate.
discriminate.
Qed.

Lemma differentHeight : forall a, height (APlus (ALit 0) a) <> height a.
(* hasznald a heightPlus es notPlus lemmakat! *)
Proof.
intro.
intro.
Admitted.

Check plus_0_r.
Check le_n_S.
Check Nat.le_trans.
Check le_S.
Check Nat.add_le_mono.
Lemma max_plus : forall m n, max m n <= m + n.
(* m szerinti indukcio *)
Admitted.

Lemma minOne : forall a, 1 <= leaves a.
Admitted.

Check Nat.add_succ_r.
Check Nat.le_trans.
Check le_n_S.
Check Nat.add_le_mono.
Lemma leaves_height1 : forall (a : AExp), height a < leaves a.
(* kicsit nehez. a szerinti indukcio *)
Admitted.

Check Nat.le_refl.
Check Nat.le_trans.
Check Nat.le_max_l.
Check Nat.le_max_r.
Check Nat.pow_le_mono.
Check Nat.add_le_mono.
Lemma leaves_height2 (a : AExp) : leaves a <= 2 ^ height a.
(* a szerinti indukcio. erdemes eloszor papiron atgondolni. *)
Admitted.