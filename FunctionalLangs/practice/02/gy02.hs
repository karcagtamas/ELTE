{-# LANGUAGE InstanceSigs #-}
{-# OPTIONS_GHC -Wincomplete-patterns -Wno-tabs #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use <" #-}
{-# HLINT ignore "Use >" #-}

module Gy02 where

import Prelude hiding (Eq, Functor, Ord, fmap, max, min, (/=), (<), (<$>), (<=), (==), (>), (>=))
import Prelude qualified

infixl 1 <$>

infix 4 ==, /=, >=, <=, >, <

-- Típus osztályok
--------------------------------------------------------------------------------

class Eq a where
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
  (/=) x y = not (x == y)
  {-# MINIMAL (==) #-}

class Eq a => Ord a where
  (<=) :: a -> a -> Bool
  (>=) :: a -> a -> Bool
  (<) :: a -> a -> Bool
  (>) :: a -> a -> Bool

  (>=) x y = y <= x
  (<) x y = not (x >= y)
  (>) x y = not (x <= y)
  {-# MINIMAL (<=) #-}

-- Hasznos szintaxis: if _ then _ else _

max :: Ord a => a -> a -> a
max a b
  | a > b = a
  | otherwise = b

min :: Ord a => a -> a -> a
min a b
  | a < b = a
  | otherwise = b

-- Emlékeztető: Típus osztály használata
data Color = Red | Green | Blue

instance Eq Color where
  (==) Red Red = True
  (==) Green Green = True
  (==) Blue Blue = True
  (==) _ _ = True

-- A továbbiakhoz definiálok néhány instance-t.
instance Eq Integer where
  (==) = (Prelude.==)

instance Ord Integer where
  (<=) = (Prelude.<=)

instance Eq Char where
  (==) = (Prelude.==)

instance Ord Char where
  (<=) = (Prelude.<=)

instance Eq a => Eq [a] where
  (==) [] [] = True
  (==) (x : xs) (y : ys) = (x == y) && (xs == ys)
  (==) _ _ = False

instance Ord a => Ord [a] where
  (<=) [] _ = True
  (<=) (x : xs) (y : ys) = case x == y of
    True -> xs <= ys
    False -> x <= y
  (<=) (x : xs) [] = False

-- Fás feladatok
--------------------------------------------------------------------------------

-- Huffman Tree: A levél csúcsok tárolnak értékeket.
data HTree a = HLeaf a | HNode (HTree a) (HTree a)

-- Tetszőleges
t1 :: HTree Integer
t1 = HLeaf 1

-- Legyen legalább 3 HLeaf benne!
t2 :: HTree Integer
t2 = HNode (HNode (HLeaf 1) (HLeaf 2)) (HLeaf 3)

-- Számold meg a leveleket.
numLeaves :: HTree a -> Integer
numLeaves (HLeaf _) = 1
numLeaves (HNode a b) = numLeaves a + numLeaves b

-- Fa magassága
-- Példa: depthHTree (HLeaf 5) == 1
-- Példa: depthHTree (HNode (HLeaf 1) (HLeaf 2)) == 2
depthHTree :: HTree a -> Integer
depthHTree (HLeaf _) = 1
depthHTree (HNode a b) = 1 + max (depthHTree a) (depthHTree b)

-- Összegezd a fában tárolt értékeket.
-- Segítség, GHCI-ben: ":i Num"
sumHTree :: Num a => HTree a -> a
sumHTree (HLeaf x) = x
sumHTree (HNode a b) = sumHTree a + sumHTree b

e1 :: HTree Integer
e1 = HNode (HNode (HLeaf 5) (HLeaf 3)) (HNode (HLeaf 6) (HLeaf 4))

-- Ord: Keresd meg a legnagyobb értéket a fában.
maxInHTree :: Ord a => HTree a -> a
maxInHTree (HLeaf x) = x
maxInHTree (HNode a b) = max (maxInHTree a) (maxInHTree b)

-- Search Tree: A belső csúcsok tárolnak értékeket.
data STree a = SLeaf | SNode (STree a) a (STree a)

-- Tetszőleges
t3 :: STree Integer
t3 = SNode SLeaf 1 SLeaf

-- Legyen legalább 1 SNode benne!
t4 :: STree Integer
t4 = t3

-- Összegezd a fában tárolt értékeket.
sumSTree :: Num a => STree a -> a
sumSTree SLeaf = 0
sumSTree (SNode a x b) = x + sumSTree a + sumSTree b

instance Show a => Show (HTree a) where
  show (HLeaf a) = "HLeaf " ++ show a
  show (HNode a b) = "HNode (" ++ show a ++ ", " ++ show b ++ ")"

instance Eq a => Eq (HTree a) where
  (==) (HLeaf x) (HLeaf y) = x == y
  (==) (HNode a1 b1) (HNode a2 b2) = a1 == a2 && b1 == b2
  (==) _ _ = False

instance Ord a => Ord (HTree a) where
  (<=) (HLeaf x) (HLeaf y) = x <= y
  (<=) (HLeaf _) (HNode _ _) = True
  (<=) (HNode a1 b1) (HNode a2 b2)
    | a1 == a2 = b1 <= b2
    | otherwise = a1 <= a2
  (<=) _ _ = False

instance Show a => Show (STree a) where
  show SLeaf = "SLeaf"
  show (SNode a x b) = "SNode (" ++ show a ++ ", " ++ show x ++ ", " ++ show b ++ ")"

instance Eq a => Eq (STree a) where
  (==) SLeaf SLeaf = True
  (==) (SNode a1 x b1) (SNode a2 y b2) = x == y && a1 == a2 && b1 == b2
  (==) _ _ = False

instance Ord a => Ord (STree a) where
  (<=) SLeaf SLeaf = True
  (<=) SLeaf _ = True
  (<=) (SNode a1 x b1) (SNode a2 y b2)
    | x == y = case a1 == a2 of
        True -> b1 <= b2
        False -> a1 <= a2
    | otherwise = x < y
  (<=) _ _ = False

-- Alkalmazz egy függvényt az összes tárolt értékre
-- Példa: mapHTree (+5) (HLeaf 5) == (HLeaf 10)
mapHTree :: (a -> b) -> HTree a -> HTree b
mapHTree f (HLeaf x) = HLeaf (f x)
mapHTree f (HNode a b) = HNode (mapHTree f a) (mapHTree f b)

mapSTree :: (a -> b) -> STree a -> STree b
mapSTree _ SLeaf = SLeaf
mapSTree f (SNode a x b) = SNode (mapSTree f a) (f x) (mapSTree f b)

-- Functor
--------------------------------------------------------------------------------

-- "Szerkezetet" megőrző morfizmus
class Functor f where
  fmap :: (a -> b) -> f a -> f b

-- f -> egy tipus lesz, amire a mapet hajtjuk vegre
-- a,b -> a tipusok a forras es celnek

(<$>) :: Functor f => (a -> b) -> f a -> f b
(<$>) = fmap

-- Kotunk egy <$> operator az fmap funktorra

instance Functor [] where
  fmap :: (a -> b) -> [a] -> [b]
  fmap _ [] = []
  fmap f (x : xs) = f x : map f xs

instance Functor Maybe where
  fmap :: (a -> b) -> Maybe a -> Maybe b
  fmap _ Nothing = Nothing
  fmap f (Just x) = Just (f x)

instance Functor HTree where
  fmap :: (a -> b) -> HTree a -> HTree b
  fmap = mapHTree

instance Functor STree where
  fmap :: (a -> b) -> STree a -> STree b
  fmap = mapSTree

-- További adattípusok
--------------------------------------------------------------------------------

data Triplet a = T a a a deriving (Show)

data Quad a = Q a a a a deriving (Show)

data Tagged a = Tag String a deriving (Show)

data Void a = Void deriving (Show)

data Try a = Success a | Fail String

e2 :: Triplet Integer
e2 = T 5 6 7

e3 :: Quad Bool
e3 = Q True False True False

e4 :: Tagged Color
e4 = Tag "Sky" Blue

e5 :: Void Integer
e5 = Void

e6 :: Try Integer
e6 = Success 5

e7 :: Try Integer
e7 = Fail "Number not found"

-- Mi a típusa az fmap függvényeknek?

instance Functor Triplet where
  fmap :: (a -> b) -> Triplet a -> Triplet b
  fmap f (T a b c) = T (f a) (f b) (f c)

instance Functor Quad where
  fmap :: (a -> b) -> Quad a -> Quad b
  fmap f (Q a b c d) = Q (f a) (f b) (f c) (f d)

instance Functor Tagged where
  fmap :: (a -> b) -> Tagged a -> Tagged b
  fmap f (Tag t x) = Tag t (f x)

instance Functor Void where
  fmap :: (a -> b) -> Void a -> Void b
  fmap _ _ = Void

instance Functor Try where
  fmap :: (a -> b) -> Try a -> Try b
  fmap _ (Fail m) = Fail m
  fmap f (Success x) = Success (f x)

-- Bónusz feladatok
--------------------------------------------------------------------------------

data IFun a = IFun (Integer -> a)

data Fun a b = Fun (a -> b)

data RoseTree a = RoseNode a [RoseTree a] deriving (Show)

data TreeI i a = LeafI a | NodeI (i -> TreeI i a)

data Const a b = Const a

e8 :: IFun String
e8 = IFun show

e9 :: Fun Color Bool
e9 = Fun (Green ==)

instance Functor IFun where
  fmap f (IFun g) = IFun (f . g)

instance Functor (Fun a) where
  fmap f (Fun g) = Fun (f . g)

instance Functor RoseTree where
  -- fmap f (RoseNode x nodes) = RoseNode (f x) (map (fmap f) nodes)
  fmap f (RoseNode x nodes) = RoseNode (f x) (fmap f <$> nodes)

instance Functor (TreeI i) where
  fmap f (LeafI x) = LeafI (f x)
  fmap f (NodeI g) = NodeI (fmap f . g)

instance Functor (Const i) where
  fmap _ (Const x) = Const x
