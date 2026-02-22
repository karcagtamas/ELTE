import Data.List

-- * State
type Var   = String
type State = Var -> Integer

aState "x" = 1
aState "y" = 2
aState "z" = 3

showState :: [Var] -> State -> String
showState vars s =
  intercalate ", "
  [ v ++ " = " ++ show (s v) | v <- vars ]

see = showState ["x","y","z"]

-- * Arithematic expressions
-- syntax
data AExp
  = Literal Integer | Variable Var
  | Plus AExp AExp | Minus AExp AExp | Negate AExp


instance Show AExp where
  show (Literal n)   = show n
  show (Variable v)  = v
  show (Plus x1 x2)  = "(" ++ show x1 ++ " + " ++ show x2 ++ ")"
  show (Minus x1 x2) = "(" ++ show x1 ++ " - " ++ show x2 ++ ")"
  show (Negate x)    = "-(" ++ show x ++ ")"

lit :: Integer -> AExp
lit = Literal

var :: Var -> AExp
var = Variable

infixl 6 %+%

(%+%) :: AExp -> AExp -> AExp
(%+%) = Plus

infixl 6 %-%

(%-%) :: AExp -> AExp -> AExp
(%-%) = Minus

neg :: AExp -> AExp
neg = Negate

-- semantics
sAExp :: AExp -> (State -> Integer)
sAExp (Literal n)   _ = n
sAExp (Variable v)  s = s v
sAExp (Plus a1 a2)  s = (sAExp a1 s) + (sAExp a2 s)
sAExp (Minus a1 a2) s = (sAExp a1 s) - (sAExp a2 s)
sAExp (Negate a1)   s = -(sAExp a1 s)

-- * Boolean expressions
-- syntax
data BExp
  = TT | FF
  | Not BExp | And BExp BExp
  | AEQ AExp AExp | ALT AExp AExp

instance Show BExp where
  show TT = "true"
  show FF = "false"
  show (Not x) = "not (" ++ show x ++ ")"
  show (And x1 x2) = "(" ++ show x1 ++ " ^ " ++ show x2 ++ ")"
  show (AEQ x1 x2) = "(" ++ show x1 ++ " == " ++ show x2 ++ ")"
  show (ALT x1 x2) = "(" ++ show x1 ++ " < " ++ show x2 ++ ")"

true :: BExp
true = TT

false :: BExp
false = FF

lnot :: BExp -> BExp
lnot = Not

land :: BExp -> BExp -> BExp
land = And

infix 4 %==%

(%==%) :: AExp -> AExp -> BExp
(%==%) = AEQ

infix 4 %<%

(%<%) :: AExp -> AExp -> BExp
(%<%) = ALT

-- semantics
sBExp :: BExp -> State -> Bool
sBExp TT          _ = True
sBExp FF          _ = False
sBExp (Not b)     s = not (sBExp b s)
sBExp (And b1 b2) s = (sBExp b1 s) && (sBExp b2 s)
sBExp (AEQ a1 a2) s = (sAExp a1 s) == (sAExp a2 s)
sBExp (ALT a1 a2) s = (sAExp a1 s) <  (sAExp a2 s)

