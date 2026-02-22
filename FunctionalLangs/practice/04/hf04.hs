-- Functors
-- a Functor is a TYPECLASS
-- a typeclass, you can think of it as an interface

-- class Functor f where
--  fmap :: (a -> b) -> f a -> f b

data Maybe2 a = Just2 a | Nothing2 deriving (Show)

instance Functor Maybe2 where
  fmap :: (a -> b) -> Maybe2 a -> Maybe2 b
  fmap func (Just2 a) = Just2 (func a)
  fmap func Nothing2 = Nothing2

-- haskell defined functor for Maybe, Either, List

data Tree a = Tip a | Branch (Tree a) (Tree a)

instance Functor Tree where
  fmap func (Tip a) = Tip (func a)
  fmap func (Branch left right) = Branch (fmap func left) (fmap func right) -- func <$> right

-- Applicatives

-- class Functor f => Applicative f where
--   pure :: a -> f a
--   (<*>) :: f (a -> b) -> f a -> f b

-- Just (+1) <*> (Just 8) ==> Just 9
-- Like Functors but the f also wrapped

instance Applicative Maybe2 where
  pure :: a -> Maybe2 a
  pure = Just2

  (<*>) :: Maybe2 (a -> b) -> Maybe2 a -> Maybe2 b
  --  (<*>) (Just2 f) (Just2 a) = Just2 (f a)
  (<*>) (Just2 f) a = fmap f a -- Unwrap f and use fmap
  (<*>) Nothing2 a = Nothing2 -- We don't have any function

instance Applicative Tree where
  pure :: a -> Tree a
  pure = Tip

  (<*>) :: Tree (a -> b) -> Tree a -> Tree b
  Tip f <*> t = fmap f t
  Branch left right <*> t = Branch (left <*> t) (right <*> t)