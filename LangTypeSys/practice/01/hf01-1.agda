{-# OPTIONS --prop --rewriting #-}

module hf01-1 where

open import Lib

-- A házi feladatok között lesznek megjelölve "Nehezebb" és "Nehéz"
-- feladatok. A +/- szintje kb. a "nehezebb" kategóriából kerül ki.
-- Nem lesz ez mindig igaz, inkább úgy fogalmazom meg, hogy legfeljebb
-- abban a nehézségben. Persze ez szubjektív, kinek mi a nehéz.

plus : ℕ → ℕ → ℕ
plus zero y = y
plus (suc x) y = suc (plus x y)

plus-idl : (n : ℕ) → plus 0 n ≡ n
plus-idl n = refl

plus-idr : (n : ℕ) → plus n 0 ≡ n
plus-idr zero = refl
plus-idr (suc n) = cong suc (plus-idr n)

-- A plus művelet kommutatív és asszociatív is:
-- Adott függvényeken működő bizonyítást mindig érdemes
-- úgy kezdeni, hogy megnézzük, hogy az eredeti függvény
-- hogyan van definiálva, mik a definíció szerinti egyenlőségei,
-- hiszen agda csak azokkal tud dolgozni magától.
-- Ez alapján melyik paraméterre lesz érdemes mintailleszteni?
plus-assoc : (n m k : ℕ) → plus (plus n m) k ≡ plus n (plus m k)
plus-assoc zero m k = refl
plus-assoc (suc n) m k = cong suc (plus-assoc n m k)

-- Nehéz feladat:
-- Kommutativitás bizonyításához egy lemmára is szükség van,
-- hogy ez micsoda, azt mindenkire rábízom, hogy jöjjön rá.
-- Illetve ha olyan helyzet áll elő, hogy egy korábbi bizonyítás már létezik,
-- de az egyenlőség két oldala fordítva vannak, akkor azt a _⁻¹ függvénnyel
-- meg lehet fordítani, hiszen az egyenlőség szimmetrikus is.
-- Több bizonyítást egymás után fűzni a _◾_
-- (\sq5 emacs-on, vscode-ban \sq és utána 4-szer jobbra kell lépni a nyilakkal)
-- függvénnyel lehet, hiszen az egyenlőség egy ekvivalencia reláció, tehát reflexív, szimmetrikus és tranzitív
plus-comm : (n m : ℕ) → plus n m ≡ plus m n
plus-comm zero m = _⁻¹ (plus-idr m)
plus-comm (suc n) m = cong suc (plus-comm n m)

--------------------------------
-- Definiáld a "mul" függvényt, amely két számot összeszoroz.
-- A létező _*_ függvény használata nem megengedett, de a plus-t
-- lehet használni.
-- Mi lesz a függvény típusa?

mul : ℕ -> ℕ -> ℕ
mul zero _ = zero
mul (suc x) b = plus b (mul x b)

-- A szorzásnak is vannak szép tulajdonságai:
-- pl. null elem, egység elem

mul-nulll : (n : ℕ) → mul 0 n ≡ 0
mul-nulll _ = refl

mul-nullr : (n : ℕ) → mul n 0 ≡ 0
mul-nullr zero = refl
mul-nullr (suc n) = mul-nullr n

mul-idl : (n : ℕ) → mul 1 n ≡ n
mul-idl zero = refl
mul-idl (suc n) = cong suc (mul-idl n)

mul-idr : (n : ℕ) → mul n 1 ≡ n
mul-idr zero = refl
mul-idr (suc n) = cong suc (mul-idr n)

-- Nehéz feladat:
-- Összeadás és szorzás felbontása:
dist-plus-mul : (m n o : ℕ) → mul (plus m n) o ≡ plus (mul m o) (mul n o)
dist-plus-mul = {!   !}