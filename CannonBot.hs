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
listMoves s = listToString (getMovesList s)

listToString :: [String] -> String
listToString xs = "[" ++ (reduceToString xs) ++ "]"

reduceToString :: [String] -> String
reduceToString [] = undefined
reduceToString (x:[]) = x
reduceToString (x:xs) = x ++ "," ++ (reduceToString xs)

getMovesList :: String -> [String]
getMovesList s = ["b8-b4","f8-f5","g6-h5","g5-g2"]

-- forSoldiers :: String -> [String]
-- forSoldiers [] = undefined
-- forSoldiers (x:[]) =
-- forSoldiers (x:xs) = 

-- forSoldierMoves :: String -> [String]
