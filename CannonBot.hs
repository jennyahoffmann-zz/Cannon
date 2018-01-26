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
listMoves s = listToString (uniquify (getMovesList s))

listToString :: [String] -> String
listToString xs = "[" ++ (reduceToString xs) ++ "]"

reduceToString :: [String] -> String
reduceToString [] = undefined
reduceToString (x:[]) = x
reduceToString (x:xs) = x ++ "," ++ (reduceToString xs)

uniquify :: [String] -> [String]
uniquify = foldl (\seen x -> if x `elem` seen then seen else seen ++ [x]) []

getMovesList :: String -> [String]
getMovesList s = forwardMoves s ++ captureMoves s ++ retreatMoves s ++ cannonMoves s
-- getMovesList s = ["b8-b4","f8-f5","g6-h5","g5-g2"]

-- forSoldiers :: String -> [String]
-- forSoldiers s =
-- forSoldiers [] = undefined
-- forSoldiers (x:[]) =
-- forSoldiers (x:xs) =

-- forSoldierMoves :: String -> [String]

getCurrentPlayer :: String -> Char
getCurrentPlayer s = last s

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
