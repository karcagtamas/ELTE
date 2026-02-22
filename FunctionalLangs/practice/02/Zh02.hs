-- Definiáld a következő függvényt tetszőleges típushelyes módon, végtelen
-- ciklus és kivételdobás nélkül!

-- Bármit használhatsz a megoldáshoz, más személy vagy M.I. segítségén kívül.

feladat :: ((a, b) -> c) -> ((b, a) -> c)
feladat f (b, a) = f (a, b)
