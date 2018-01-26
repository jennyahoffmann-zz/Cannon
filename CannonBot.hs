--- module (NICHT AENDERN!)
module CannonBot where
--- imports (NICHT AENDERN!)
import Data.Char
import Util

--- external signatures (NICHT AENDERN!)
getMove :: String -> String
listMoves :: String -> String

--- YOUR IMPLEMENTATION STARTS HERE ---
getMove s = head (getMovesList s)
-- listMoves s = listToString (getMovesList s)
listMoves s = listToString (sort (uniquify (getMovesList s)))

listToString :: [String] -> String
listToString xs = "[" ++ reduceToString xs ++ "]"

reduceToString :: [String] -> String
reduceToString [] = undefined
-- reduceToString (x:[]) = x
reduceToString [x] = x
reduceToString (x:xs) = x ++ "," ++ reduceToString xs

uniquify :: [String] -> [String]
uniquify = foldl (\seen x -> if x `elem` seen then seen else seen ++ [x]) []

sort :: Ord a => [a] -> [a]
sort []     = []
sort (s:xs) = sort l ++ [s] ++ sort r
    where
        l = filter (< s) xs
        r = filter (>= s) xs

getMovesList :: String -> [String]
getMovesList s = forwardMoves s ++ captureMoves s ++ retreatMoves s ++ cannonMoves s ++ shotMoves s
-- getMovesList s = ["f8-f5","g6-h5","g5-g2","b8-b4"]

-- forSoldiers :: String -> [String]
-- forSoldiers s =
-- forSoldiers [] = undefined
-- forSoldiers (x:[]) =
-- forSoldiers (x:xs) =

-- forSoldierMoves :: String -> [String]

getCurrentPlayer :: String -> Char
-- getCurrentPlayer s = last s
getCurrentPlayer = last

isCurrentPlayer :: Char -> String -> Bool
isCurrentPlayer p s = p == getCurrentPlayer s

forwardMoves :: String -> [String]
forwardMoves s = [s]

captureMoves :: String -> [String]
captureMoves s = [s]

retreatMoves :: String -> [String]
retreatMoves s = [s]

cannonMoves :: String -> [String]
cannonMoves s = [s]

shotMoves :: String -> [String]
shotMoves s = [s]
