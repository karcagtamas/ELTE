(**
  Oldd meg az alábbi feladatokat!

  A következő taktikák használata tiltott:
    (e)constructor, tauto, btauto, firstorder, lia, omega, nia
*)

(* BEGIN FIX *)
From Coq Require Import Strings.String
                        Arith.PeanoNat
                        Arith.Plus
                        Program.Equality.
Require Import Coq.Logic.FunctionalExtensionality.

Definition X:string := "X"%string.
Definition Y:string := "Y"%string.
Definition Z:string := "Z"%string.

Definition state := string -> nat.

Definition empty : state := fun x => 0.

Definition update (s : state) (x : string) (n : nat) : state :=
  fun x' =>
    match string_dec x x' with
    | left _ => n
    | right _ => s x'
    end.

Inductive AExp : Type :=
| ALit (n : nat)
| AVar (x : string)
| APlus (a1 a2 : AExp)
| AMinus (a1 a2 : AExp)
| AMult (a1 a2 : AExp).

Inductive BExp : Type :=
| BTrue
| BFalse
| BAnd (b1 b2 : BExp)
| BNot (b : BExp)
| BEq (a1 a2 : AExp)
| BLe (a1 a2 : AExp).

Definition true_and_false : BExp := BAnd BTrue BFalse.

Fixpoint aeval (a : AExp) (st : state) : nat :=
match a with
| ALit n => n
| AVar x => st x
| APlus a1 a2 => (aeval a1 st) + (aeval a2 st)
| AMinus a1 a2 => (aeval a1 st) - (aeval a2 st)
| AMult a1 a2 => (aeval a1 st) * (aeval a2 st)
end.

Fixpoint beval (b : BExp) (s : state) : bool :=
match b with
| BTrue => true
| BFalse => false
| BAnd b1 b2 => (beval b1 s) && (beval b2 s)
| BNot b => negb (beval b s)
| BEq a1 a2 => (aeval a1 s) =? (aeval a2 s)
| BLe a1 a2 => (aeval a1 s) <=? (aeval a2 s)
end.




Inductive Stmt : Type :=
| SSkip (* skip *)
| SAssign (x : string) (a : AExp) (* x := a *)
| SSeq (S1 S2 : Stmt) (* S1; S2 *)
| SIf (b : BExp) (S1 S2 : Stmt) (* if b then S1 else S2 *)
| SWhile (b : BExp) (S0 : Stmt) (* while b do S0 *)
(**
   Az SCond parancs úgy működik, mint egy értékadás, ami a feltételétől 
   függően vagy az első vagy a második aritmetikai kifejezést adja értékül 
   a paraméter változónak:
   pl. SCond X BTrue (ALit 1) (ALit 2)  ---> ALit 1 adódik értékül X-nek
       SCond X BFalse (ALit 1) (ALit 2) ---> ALit 2 adódik értékül X-nek


   Add meg az SCond parancs szintaxisát!
*)
(* END FIX *)
| SCond (x : string) (b : BExp) (a1 a2 : AExp)
.

(* BEGIN FIX *)
Fixpoint eval (fuel : nat) (S0 : Stmt) (st : state) : option state :=
match fuel with
| O => None
| S fuel' =>
  match S0 with
   | SSkip => Some st
   | SAssign x a => Some (update st x (aeval a st))
   | SSeq S1 S2 => match eval fuel' S1 st with
                   | Some st' => eval fuel' S2 st'
                   | None => None
                   end 
                   (* let st' := (eval fuel' S1 st) in
                      eval fuel' S2 st' *)
   | SIf b S1 S2 => if beval b st
                    then eval fuel' S1 st
                    else eval fuel' S2 st
   | SWhile b S0 => if beval b st
                    then 
                      match eval fuel' S0 st with
                      | Some st' => eval fuel' (SWhile b S0) st'
                      | None => None
                      end
                    else Some st
   (** Add meg a denotációs szemantikát a fenti leírás alapján! *)
   | SCond x b a1 a2 => if beval b st
                        then Some (update st x (aeval a1 st))
                        else Some (update st x (aeval a2 st))
  end
end.

Definition ofSome (st : option state) (x : string) : option nat :=
match st with
| Some st' => Some (st' x)
| None => None
end.

Definition cond1  := (SCond X BTrue (ALit 1) (ALit 2)).
Definition cond1' := (SCond X BFalse (ALit 1) (ALit 2)).
Definition cond2 := SWhile (BNot (BEq (AVar X) (ALit 0)))
                           (SCond X (BLe (AVar X) (ALit 10))
                                  (ALit 0) (AMinus (AVar X) (ALit 10))).

Goal ofSome (eval 10 cond1 empty) X = Some 1.
Proof.
  reflexivity.
Qed.

Goal ofSome (eval 10 cond1' empty) X = Some 2.
Proof.
  reflexivity.
Qed.

Goal ofSome (eval 30 cond2 (update empty X 11)) X = Some 0.
Proof.
  reflexivity.
Qed.


Reserved Notation "| s , st | -=> st' " (at level 50).
Inductive eval_bigstep : Stmt -> state -> state -> Prop :=
| eval_skip (st : state) :
  | SSkip , st | -=> st
| eval_assign (x : string) (a : AExp) (st : state) :
  | SAssign x a, st | -=> update st x (aeval a st)
| eval_seq (S1 S2 : Stmt) (st st' st'' : state) :
  | S1, st | -=> st' -> | S2, st' | -=> st''
->
  | SSeq S1 S2, st | -=> st''
| eval_if_true (b : BExp) (S1 S2 : Stmt) (st st' : state) :
  beval b st = true -> | S1, st | -=> st'
->
  | SIf b S1 S2, st | -=> st'
| eval_if_false (b : BExp) (S1 S2 : Stmt) (st st' : state) :
  beval b st = false -> | S2, st | -=> st'
->
  | SIf b S1 S2, st | -=> st'
| eval_while_true (b : BExp) (S0 : Stmt) (st st' st'' : state) :
  beval b st = true -> | S0, st | -=> st' -> | SWhile b S0, st' | -=> st''
->
  | SWhile b S0, st | -=> st''
| eval_while_false (b : BExp) (S0 : Stmt) (st : state) :
  beval b st = false
->
  | SWhile b S0, st | -=> st
(* END FIX *)
(** Add meg az SCond big-step szemantikáját! *)
| eval_cond_false (x : string) (b : BExp) (a1 a2 : AExp) (st : state) :
  beval b st = false -> | SCond x b a1 a2, st | -=> update st x (aeval a2 st)
| eval_cond_true (x : string) (b : BExp) (a1 a2 : AExp) (st : state) :
  beval b st = true -> | SCond x b a1 a2, st | -=> update st x (aeval a1 st)


(* BEGIN FIX *)
where "| s , st | -=> st' " := (eval_bigstep s st st').


(** Bizonyitsd az alábbi teszteket! *)
Goal exists st, | cond1, empty | -=> st.
Proof.
(* END FIX *)
unfold cond1.
exists (update empty X 1).
apply eval_cond_true.
simpl.
reflexivity.
Qed.

(* BEGIN FIX *)
Goal exists st, | cond1',  empty | -=> st.
Proof.
(* END FIX *)
unfold cond1'.
exists (update empty X 2).
apply eval_cond_false.
simpl.
reflexivity.
Qed.

(* BEGIN FIX *)
Goal exists st, | cond2, (update empty X 11) | -=> st.
Proof.
(* END FIX *)
unfold cond2.
exists (update (update (update empty X 11) X 1) X 0).
eapply eval_while_true.
* simpl. reflexivity.
* apply eval_cond_false.
** simpl. reflexivity.
* eapply eval_while_true.
** simpl. reflexivity.
** apply eval_cond_true.
*** simpl. reflexivity.
** eapply eval_while_false.
*** simpl. reflexivity.
Qed.

(** Definiáld az SCond-ot szintaktikus cukorkaként (azaz ne használd az SCond
    konstruktort a következő definícióban)! *)
Definition scond_sugar (x : string) (b : BExp) (a1 a2 : AExp) :=
SIf b (SAssign x a1) (SAssign x a2).

(* BEGIN FIX *)

Definition Equiv (c1 c2 : Stmt) : Prop := forall st st',
 | c1 , st | -=> st' <-> | c2 , st | -=> st'.

(** Bizonyítsd be, hogy a feltételes értékadás ekvivalens a fent megadott
    szintaktikus cukorral! *)
Theorem scond_sugar_equiv_scond :
  forall x b a1 a2, Equiv (SCond x b a1 a2) (scond_sugar x b a1 a2).
Proof.
(* END FIX *)
intros.
intro.
intro.
split.
* intro. unfold scond_sugar. inversion H. subst. apply eval_if_false.
** assumption.
** apply eval_assign.
** subst. apply eval_if_true.
*** assumption.
*** apply eval_assign.
* intro. inversion H; inversion H6; subst.
** apply eval_cond_true. assumption.
** apply eval_cond_false. assumption.
Qed.

(* BEGIN FIX *)
(** Bizonyítsd a szemantika determinisztikusságát! *)
Theorem determinism : forall S0 st st', |S0, st| -=> st' -> (forall st'', |S0, st| -=> st'' -> st' = st'').
Proof.
(* END FIX *)
intros.
induction H;inversion H0;subst;try (reflexivity).
* apply IHeval_bigstep2. assert (st'=st'0).
intros. inversion H; subst.
* inversion H0. reflexivity.
Admitted.


(** További gyakorlatok kiegészítésre:
    - repeat-until ciklus
    - szimultán értékadás
    - feltételes értékadás
    - számláló ciklus *)