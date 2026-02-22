import Data.Set
import Prelude hiding (Foldable, Monoid, Semigroup, foldl, foldr, foldMap, (<>), Sum)

class Semigroup a where
  (<>) :: a -> a -> a

instance Semigroup [a] where
  (<>) = (++)

instance Ord a => Semigroup (Set a) where
  (<>) = union

instance Semigroup a => Semigroup (Maybe a) where
  (<>) Nothing b = b
  (<>) a Nothing = a
  (<>) (Just a) (Just b) = Just (a <> b)

class Semigroup a => Monoid a where
  mempty :: a

instance Monoid [a] where
  mempty = []

instance Semigroup a => Monoid (Maybe a) where
  mempty = Nothing

class Foldable t where
  foldMap :: Monoid m => (a -> m) -> t a -> m
  foldr :: (a -> b -> b) -> b -> t a -> b
  foldl :: (b -> a -> b) -> b -> t a -> b

data Tree a = Leaf a | Node (Tree a) a (Tree a)

foldrTree :: (a -> b -> b) -> b -> Tree a -> b
foldrTree f b (Leaf a) = f a b
foldrTree f b (Node tr1 a tr2) = foldrTree f (f a (foldrTree f b tr2)) tr1

-- length' :: Foldable t => t a -> Int
-- length' = foldr (const (+ 1)) 0

data Sum a = Sum { runSum :: a }

instance Num a => Semigroup (Sum a) where
  (<>) (Sum a) (Sum b) = Sum (a + b)

instance Num a => Monoid (Sum a) where
  mempty = Sum 0

sum :: (Foldable t, Num a) => t a -> a
sum = runSum . foldMap Sum