(* BEGIN FIX *)
(** Pótold a hiányzó kódrészleteket! A BEGIN FIX és END FIX közötti részeket ne módosítsd! Akkor jó a megoldásod, ha a Coq elfogadja az egészet (zöld lesz a teljes fájl).*)
(** Fill out the missing parts! Do not modify the code between BEGIN FIX and END FIX! *)
Inductive bool : Type :=
| true
| false.

(* Add meg a logikai "nem" műveletet! *)
(* Define the logical conjunction *)
Definition not (a : bool) : bool :=
(* END FIX *)
match a with
| true => false
| false => true
end.

(* BEGIN FIX *)
Lemma notnotnottrue : not (not (not true)) = not true.
(* END FIX *)
Proof.
simpl. reflexivity.
Qed.


(* BEGIN FIX *)
Lemma notnotnot (b : bool) : not (not (not b)) = not b.
(* END FIX *)
Proof.
simpl.
destruct b.
simpl. reflexivity.
simpl. reflexivity.
Qed.