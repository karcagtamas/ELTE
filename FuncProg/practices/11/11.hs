{-
- new type: 1 konstruktora lehet
            1 parametere lehet
            nem kerul eltarolasra a konstruktor
-}

data Direction = R | L -- deriving (Show)

-- instance [mit rendelunk] [mihez rendeljuk]
instance Show Direction where
    show L = "Left"
    show R = "Right"

instance Eq Direction where
    (==) L R = True
    (==) R L = True
    (==) _ _ = False

mirror :: Direction -> Direction
mirror L = R
mirror R = L

sumLs :: [Direction] -> Int
--sumLs [] = 0
--sumLs (L:ls) = 1 + sumLs ls
--sumLs (R:ls) = sumLs ls
sumLs d = sum [1 | L <- d]
-- mintaillesztes lista generatoron belul
-- ha illik a mintara, akkor berakja a listaba, ha nem, akkor nem lakja bele a listaba

data Type a = T1 a | T2 deriving (Show)

-- megkotes, ha a parameterre mar definialt az Eq
instance Eq a => Eq (Type a) where
    (==) (T1 a) (T1 b) = a == b
    (==) _ _ = False

-- Maybe

data Maybee a = Justt a | Nothingg deriving (Show, Eq)

div' :: Int -> Int -> Maybe Int
div' n 0 = Nothing
div' n d = Just (n `div` d)

out :: Maybe a -> Maybe a
out Nothing = error "Hiba"
out x = x

safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead (x:_) = Just x

isJust :: Maybe a -> Bool
isJust (Just x) = True
isJust _ = False

isNothing :: Maybe a -> Bool
isNothing Nothing = True
isNothing _ = False

maybeToList :: [Maybe a] -> [a]
maybeToList maybes = [a | (Just a) <- maybes]

lookup' :: Eq k => k -> [(k,v)] -> Maybe v
lookup' key values = safeHead (map (\(_,v) -> v) (filter (\(k,v) -> k == key) values))


-- Rekurziv data
data Nat 
    = Zero     -- Nulla
    | Succ Nat -- Rakovetkezo
        deriving (Eq, Show)

one :: Nat
one = Succ Zero

two :: Nat
two = Succ (Succ Zero)

add :: Nat -> Nat -> Nat
add Zero a = a
add (Succ a) b = add a (Succ b)

mul :: Nat -> Nat -> Nat
mul Zero _ = Zero
mul _ Zero = Zero
mul (Succ a) b = add b (mul a b)

convert :: Int -> Nat
convert 0 = Zero
convert n = Succ (convert (n - 1))

-- Lancolt lista
data List a = Nil | Cons a (List a) --deriving (Show)

instance Foldable List where
    foldr _ b Nil = b
    foldr f b (Cons x xs) = f x (foldr f b xs)

instance Show a => Show (List a) where
    show l = '<' : innerShow l ++ ">" where
        innerShow Nil = ""
        innerShow (Cons x Nil) = show x
        innerShow (Cons x c) = show x ++ ":" ++ innerShow c

fromList :: [a] -> List a
--fromList [] = Nil
--fromList (x:xs) = Cons x (fromList xs)
fromList = foldr Cons Nil