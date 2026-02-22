(** Pótold a hiányzó kódrészleteket! A BEGIN FIX és END FIX közötti részeket ne módosítsd! Akkor jó a megoldásod, ha a Coq elfogadja az egészet (zöld lesz a teljes fájl).*)
(** Fill out the missing parts! Do not modify the code between BEGIN FIX and END FIX! *)
(* BEGIN FIX *)
Inductive AExp : Type :=
| ALit (n : nat)
| APlus (a1 a2 : AExp)
| ASub (a1 a2 : AExp)
.

Fixpoint aeval (a : AExp) : nat :=
match a with
 | ALit n => n
 | APlus a1 a2 => aeval a1 + aeval a2
 | ASub a1 a2 => aeval a1 - aeval a2
end.

Example mk2Exp : exists a1 a2, aeval a1 = aeval a2 /\ aeval a1 = 3 /\ a1 <> a2.
(* END FIX *)
Proof.
exists (ALit 3).
exists (APlus (ALit 0) (ALit 3)).
simpl.
split.
reflexivity.
split.
reflexivity.
intro.
discriminate.
Qed.