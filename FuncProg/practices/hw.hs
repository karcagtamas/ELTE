import Data.List
import Data.Maybe
import Data.Char

-- Available colors in the game (10)
data Color = Purple | DarkGreen | Orange | Pink | Yellow | Red | Gray | DarkBlue | Green | Blue deriving (Show, Eq)

type Guess = [Color]
type ColorRow = [Color]

-- Response variations (2)
data Mark = Black | White deriving (Show, Eq)

data GuessResp  = Resp Guess [Mark] deriving (Show, Eq)

type AvailableGuesses = Int

-- Completion state
data Completion = Success Int | Failure String | Ongoing deriving (Show, Eq)

-- Game
data Game = Game ColorRow (AvailableGuesses, [GuessResp]) Completion deriving (Show, Eq)

-- Predefined games for tests
emptyGame1 :: Game
emptyGame1 = Game [Red, DarkGreen, Pink, Orange] (10, []) Ongoing

emptyGame2 :: Game
emptyGame2 = Game [Yellow, Gray, Green, DarkBlue] (3, []) Ongoing

wrongGame1 :: Game
wrongGame1 = Game [Red] (10,[]) Ongoing

wrongGame2 :: Game
wrongGame2 = Game (repeat Purple) (2,[]) Ongoing

isColorRowInvalid :: [Color] -> Bool
isColorRowInvalid colors = not (length (take 5 colors) == 4)

-- Matching colors right place
matchingColorsRightPlace :: Guess -> ColorRow -> Maybe Int
matchingColorsRightPlace guess colors
    | isColorRowInvalid guess = Nothing
    | isColorRowInvalid colors = Nothing
    | otherwise = Just (foldl (\s (a,b) -> s + match a b) 0 $ zip guess colors)
        where match a b
                | a == b = 1
                | otherwise = 0

-- Matcing colors wrong place
matchingColorsWrongPlace :: Guess -> ColorRow -> Maybe Int
matchingColorsWrongPlace guess colors
    | isColorRowInvalid guess = Nothing
    | isColorRowInvalid colors = Nothing
    | otherwise = Just (length $ filter (\x -> x) $ map (\(g,c) -> not (g == c) && contains g colors) $ zip guess colors) where 
        contains _ [] = False
        contains a (l:ls)
            | a == l = True
            | otherwise = contains a ls

-- Guess
guessOnce :: Guess -> ColorRow -> AvailableGuesses -> Maybe (AvailableGuesses, GuessResp)
guessOnce guess colors ava
    | ava <= 0 = Nothing
    | Nothing <- colorsWrongPlace = Nothing
    | Nothing <- colorsRightPlace = Nothing
    | otherwise = Just (ava - 1, Resp guess ((take (fromJust colorsRightPlace) (repeat Black)) ++ (take (fromJust colorsWrongPlace) (repeat White)))) where 
        colorsWrongPlace = matchingColorsWrongPlace guess colors
        colorsRightPlace = matchingColorsRightPlace guess colors

-- Update game
isRespsSuccess :: GuessResp -> Bool
isRespsSuccess (Resp guess marks) = and (map converter marks) && ((length marks) == 4) where 
    converter (Black) = True
    converter (White) = False

gameUpdate :: Maybe Guess -> Either String Game -> Either String Game
gameUpdate _ (Left s) = Left s
gameUpdate _ (Right (Game _ _ (Success _))) = Left "Ezt a jatekot mar korabban megnyerted!"
gameUpdate _ (Right (Game _ _ (Failure _))) = Left "Ezt a jatekot mar korabban elvesztetted!"
gameUpdate Nothing (Right (Game colors s _)) = Right (Game colors s (Failure "Feladtad a jatekot!"))
gameUpdate (Just guess) (Right (Game colors (ava, resps) comp))
    | Just (a, g) <- resp, isRespsSuccess g = Right (Game colors (a, resps ++ [g]) (Success ((length resps) + 1)))
    | Just (a, g) <- resp, a <= 0 = Right (Game colors (a, resps ++ [g]) (Failure "Elfogytak a tippek!"))
    | Just (a, g) <- resp = Right (Game colors (a, resps ++ [g]) Ongoing)
    | otherwise = Left "A tippeles nem sikerult!"
    where resp = guessOnce guess colors ava

-- Game state
gameState :: Either String Game -> String
gameState (Left []) = "HIBA"
gameState (Left s) = "HIBA: " ++ s
gameState (Right (Game _ _ (Success x))) = "A jatekot megnyerted " ++ (show x) ++ " tippbol."
gameState (Right (Game _ _ (Failure e))) = "A jatekot elvesztetted. " ++ e
gameState (Right (Game _ (ava, _) _)) = "A jatek meg folyamatban van, meg " ++ (show ava) ++ " tipped van hatra."

-- Read colors
stringToLower :: String -> String
stringToLower = map toLower

colorNames :: [(String, Color)]
colorNames = map (\color -> (stringToLower (show color), color)) [Purple, DarkGreen, Orange, Pink, Yellow, Red, Gray, DarkBlue, Green, Blue]

stringToColor :: String -> Maybe Color
stringToColor s = wrapOut $ find (\(name, color) -> name == (stringToLower s)) colorNames where
    wrapOut (Just (name, color)) = Just color
    wrapOut _ = Nothing

-- String to guess
splitBy :: Eq a => a -> [a] -> [[a]]
splitBy delimiter = groupBy (\x y -> y /= delimiter)

stringToGuess :: String -> Maybe Guess
stringToGuess s = foldl (\s c -> summarize s c) (Just []) $ map (\w -> stringToColor $ (filter (\c -> c /= ',') w)) $ splitBy ',' $ filter (\c -> not $ isSpace c) s where
    summarize Nothing _ = Nothing
    summarize _ Nothing = Nothing
    summarize (Just colors) (Just color) = Just (colors ++ [color])

gameUpdateFromString :: String -> Either String Game -> Either String Game
gameUpdateFromString s = gameUpdate (stringToGuess s)