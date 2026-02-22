{-# OPTIONS_GHC -Wno-tabs #-}

-- Definiáld az alábbi függvényt típushelyes módon, végtelen ciklus és kivételdobás nélkül.
-- A függvény Just értéket kell hogy visszaadjon minden esetben amikor ez lehetséges.

-- Bármit használhatsz a megoldáshoz, más személy vagy M.I. segítségén kívül.

composeMaybe :: (a -> Maybe b) -> (b -> Maybe c) -> (Maybe a -> Maybe c)
composeMaybe f g Nothing = Nothing
composeMaybe f g (Just a) = case f a of
  Nothing -> Nothing
  Just b -> g b
