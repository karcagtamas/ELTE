{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wincomplete-patterns -Wno-tabs #-}

import Data.Bool
import Data.Either
import Data.Functor
import Data.Maybe
import GHC.Classes
import GHC.Num
import GHC.Show
import Prelude (const, flip, id, map, otherwise, undefined, ($), (++), (.))

infixr 6 <>

data HTree a = HLeaf a | HNode (HTree a) (HTree a) deriving (Eq, Ord, Functor)

data STree a = SLeaf | SNode (STree a) a (STree a) deriving (Eq, Ord, Functor)

e1 :: HTree Integer
e1 = HNode (HNode (HLeaf 1) (HLeaf 5)) (HNode (HNode (HLeaf 3) (HLeaf 2)) (HLeaf 4))

instance Show a => Show (HTree a) where
  show (HLeaf x) = show x
  show (HNode a b) = hshow a ++ " <> " ++ hshow b
    where
      hshow (HNode a b) = "(" ++ show (HNode a b) ++ ")"
      hshow (HLeaf x) = show (HLeaf x)

instance Show a => Show (STree a) where
  show SLeaf = "Leaf"
  show (SNode a b c) = hshow a ++ " " ++ show b ++ " " ++ hshow c
    where
      hshow (SNode a b c) = "(" ++ show (SNode a b c) ++ ")"
      hshow SLeaf = ""

-- Semigroup & Monoid
--------------------------------------------------------------------------------

class Semigroup t where
  (<>) :: t -> t -> t

-- Asszociativitás (a <> b) <> c == a <> (b <> c)

class Semigroup t => Monoid t where
  mempty :: t

-- Nulla tulajdonság: mempty <> a == a && a <> mempty == a

newtype Addition a = Addition {fromAddition :: a}

newtype Multiplication a = Multiplication {fromMultiplication :: a}

instance Num a => Semigroup (Addition a) where
  (<>) (Addition x) (Addition y) = Addition (x + y)

instance Num a => Monoid (Addition a) where
  mempty = Addition 0

instance Num a => Semigroup (Multiplication a) where
  (<>) (Multiplication x) (Multiplication y) = Multiplication (x * y)

instance Num a => Monoid (Multiplication a) where
  mempty = Multiplication 1

instance Semigroup [a] where
  (<>) = (++)

instance Monoid [a] where
  mempty = []

instance Semigroup a => Semigroup (Maybe a) where
  (<>) (Just x) (Just y) = Just (x <> y)
  (<>) Nothing Nothing = Nothing
  (<>) (Just x) _ = Just x
  (<>) _ (Just y) = Just y

instance Semigroup a => Monoid (Maybe a) where
  mempty = Nothing

instance Semigroup (HTree a) where
  -- Technikailag nem asszociatív, de hasznos!
  (<>) = HNode

-- Foldable
--------------------------------------------------------------------------------

class Foldable t where
  foldMap :: Monoid b => (a -> b) -> t a -> b
  foldMap f = foldr ((<>) . f) mempty

  fold :: Monoid a => t a -> a
  fold = foldMap id

  foldr :: (a -> b -> b) -> b -> t a -> b
  foldl :: (b -> a -> b) -> b -> t a -> b

-- foldr jobb asszociatív
-- foldr f z [x1,x2,x3,x4,x5] = x1 `f` (x2 `f` (x3 `f` (x4 `f` (x5 `f` z))))

-- foldl bal asszociatív
-- foldl f z [x1,x2,x3,x4,x5] = ((((z `f` x1) `f` x2) `f` x3) `f` x4) `f` x5

-- A definíció szerint a fold-nak jobb asszociatívan kell alkalmaznia a <> operátort.
-- De <> úgy is definíció szerint asszociatív.

-- Implementáljuk a foldMap-et fold és fmap segítségével
functorFoldMap :: (Functor f, Foldable f, Monoid b) => (a -> b) -> f a -> b
functorFoldMap f = fold . fmap f

instance Foldable [] where
  fold :: Monoid a => [a] -> a
  fold = foldr (<>) mempty

  foldMap :: Monoid b => (a -> b) -> [a] -> b
  foldMap = functorFoldMap

  foldr :: (a -> b -> b) -> b -> [a] -> b
  foldr _ b [] = b
  foldr f b (x : xs) = f x $ foldr f b xs

  foldl :: (b -> a -> b) -> b -> [a] -> b
  foldl _ b [] = b
  foldl f b (x : xs) = foldl f (f b x) xs

toList :: Foldable t => t a -> [a]
-- toList = foldr (:) []
toList = foldMap (: [])

instance Foldable HTree where
  fold :: Monoid a => HTree a -> a
  fold (HLeaf a) = a
  fold (HNode a b) = fold a <> fold b

  foldMap :: Monoid b => (a -> b) -> HTree a -> b
  foldMap = functorFoldMap

  foldr :: (a -> b -> b) -> b -> HTree a -> b
  foldr f b (HLeaf x) = f x b
  foldr f b (HNode x y) = foldr f (foldr f b y) x

  foldl :: (b -> a -> b) -> b -> HTree a -> b
  foldl f b (HLeaf x) = f b x
  foldl f b (HNode x y) = foldl f (foldl f b x) y

toHTree :: Foldable t => t a -> Maybe (HTree a)
toHTree = foldMap (Just . HLeaf)

instance Foldable STree where
  fold :: Monoid a => STree a -> a
  fold SLeaf = mempty
  fold (SNode a x b) = fold a <> x <> fold b

  foldMap :: Monoid b => (a -> b) -> STree a -> b
  foldMap = functorFoldMap

  foldr :: (a -> b -> b) -> b -> STree a -> b
  foldr _ b SLeaf = b
  foldr f b (SNode c x d) = foldr f (f x (foldr f b d)) c

  foldl :: (b -> a -> b) -> b -> STree a -> b
  foldl _ b SLeaf = b
  foldl f b (SNode c x d) = foldl f (f (foldl f b c) x) d

instance Foldable Maybe where
  fold Nothing = mempty
  fold (Just a) = a

  foldMap = functorFoldMap

  foldr _ b Nothing = b
  foldr f b (Just a) = f a b

  foldl _ b Nothing = b
  foldl f b (Just a) = f b a

-- Foldable függvények
--------------------------------------------------------------------------------

-- Vizsgáljuk meg hogy üres-e.
null :: (Foldable t) => t a -> Bool
null = foldr (\x y -> False) True

-- Számoljuk meg az elemeket.
length :: (Foldable t) => t a -> Integer
length = foldl (\b x -> b + 1) 0

-- Tartalmazza-e az elemet?
elem :: (Foldable t, Eq a) => a -> t a -> Bool
elem a = foldr (\x b -> x == a || b) False

min' :: (Ord a) => Maybe a -> Maybe a -> Maybe a
min' Nothing Nothing = Nothing
min' Nothing b = b
min' a Nothing = a
min' (Just a) (Just b) = Just (min a b)

minimum :: (Foldable t, Ord a) => t a -> Maybe a
minimum = foldr (min' . Just) Nothing

maximum :: (Foldable t, Ord a) => t a -> Maybe a
maximum = foldr (max . Just) Nothing

-- Használjuk a foldr vagy foldl függvényt!
sum :: (Foldable t, Num a) => t a -> a
sum = foldr (+) 0

product :: (Foldable t, Num a) => t a -> a
product = foldr (*) 1

-- Használjuk a fenti Addition és Multiplication típusokat!
sum' :: (Foldable t, Num a) => t a -> a
sum' = fromAddition . foldMap Addition

product' :: (Foldable t, Num a) => t a -> a
product' = fromMultiplication . foldMap Multiplication

-- Szorzat és összeg
-- Példa: sumAndProduct [2,2,3] = (7,12)
sumAndProduct :: (Foldable t, Num a) => t a -> (a, a)
sumAndProduct t = (sum t, product t)

-- Bónusz: Szorzatok összege
-- Példa: sumOfProducts [[2,5],[3,7]] == 31
sumOfProducts :: (Foldable t1, Foldable t2, Num a) => t1 (t2 a) -> a
sumOfProducts = fromAddition . foldMap (Addition . fromMultiplication . foldMap Multiplication)

-- További feladatok
--------------------------------------------------------------------------------

data SparseList a = Nil | Skip (SparseList a) | Cons a (SparseList a)

data Sum f g a = Inl (f a) | Inr (g a) deriving (Show)

data Product f g a = Product (f a) (g a) deriving (Show)

newtype Compose f g a = Compose (f (g a)) deriving (Show)

data RoseTree a = RoseNode a [RoseTree a] deriving (Show)

data Pit a = PNil | PLeft a (Pit a) | PRight (Pit a) a

instance Functor SparseList where
  -- Ez ismerős...
  fmap _ Nil = Nil
  fmap f (Skip a) = Skip (fmap f a)
  fmap f (Cons x a) = Cons (f x) (fmap f a)

instance (Functor f, Functor g) => Functor (Sum f g) where
  fmap m (Inl f) = Inl (fmap m f)
  fmap m (Inr g) = Inr (fmap m g)

instance (Functor f, Functor g) => Functor (Product f g) where
  fmap m (Product f g) = Product (fmap m f) (fmap m g)

instance (Functor f, Functor g) => Functor (Compose f g) where
  fmap m (Compose f) = Compose (fmap (fmap m) f)

instance Functor RoseTree where
  -- Ez is ismerős...
  fmap :: (a -> b) -> RoseTree a -> RoseTree b
  fmap f (RoseNode x others) = RoseNode (f x) (fmap f <$> others)

instance Functor Pit where
  fmap :: (a -> b) -> Pit a -> Pit b
  fmap _ PNil = PNil
  fmap f (PLeft x a) = PLeft (f x) (fmap f a)
  fmap f (PRight b x) = PRight (fmap f b) (f x)

instance (Semigroup (f a), Semigroup (g a)) => Semigroup (Product f g a) where
  (<>) (Product f1 g1) (Product f2 g2) = Product (f1 <> f2) (g1 <> g1)

instance (Monoid (f a), Monoid (g a)) => Monoid (Product f g a) where
  mempty = Product mempty mempty

instance Foldable SparseList where
  fold Nil = mempty
  fold (Skip a) = fold a
  fold (Cons x a) = x <> fold a

  foldMap = functorFoldMap

  foldr _ b Nil = b
  foldr f b (Skip a) = foldr f b a
  foldr f b (Cons x a) = f x (foldr f b a)

  foldl _ b Nil = b
  foldl f b (Skip a) = foldl f b a
  foldl f b (Cons x a) = foldl f (f b x) a

instance (Foldable f, Foldable g) => Foldable (Sum f g) where
  fold (Inl f) = fold f
  fold (Inr g) = fold g

  foldMap = undefined

  foldr m b (Inl f) = foldr m b f
  foldr m b (Inr f) = foldr m b f

  foldl m b (Inl f) = foldl m b f
  foldl m b (Inr f) = foldl m b f

instance (Foldable f, Foldable g) => Foldable (Product f g) where
  fold = undefined
  foldMap = undefined
  foldr = undefined
  foldl = undefined

instance (Foldable f, Foldable g) => Foldable (Compose f g) where
  fold = undefined
  foldMap = undefined
  foldr = undefined
  foldl = undefined

instance Foldable RoseTree where
  -- Preorder bejárás.
  fold (RoseNode x others) = x <> foldMap fold others

  foldMap = functorFoldMap

  foldr f b (RoseNode x others) = f x (foldr (flip (foldr f)) b others)

  foldl f b (RoseNode x others) = foldl (foldl f) (f b x) others

instance Foldable Pit where
  fold PNil = mempty
  fold (PLeft x a) = x <> fold a
  fold (PRight b x) = x <> fold b

  foldMap = functorFoldMap

  foldr _ b PNil = b
  foldr f z (PLeft x a) = foldr f (f x z) a
  foldr f z (PRight b x) = f x (foldr f z b)

  foldl _ b PNil = b
  foldl f z (PRight b x) = foldl f (f z x) b
  foldl f z (PLeft x a) = f (foldl f z a) x
