--- module (NICHT AENDERN!)
module CannonBot where
--- imports (NICHT AENDERN!)
import Data.Char
import Util

--- external signatures (NICHT AENDERN!)
-- getMove :: String -> String
-- listMoves :: String -> String

--- YOUR IMPLEMENTATION STARTS HERE ---

-- listMoves
-- IN: "4W5/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/7B2 w"
-- OUT: "[g3-f4,...]"

-----------------------------------------------

getMove :: String -> String
getMove moves =
    let move:rest = splitOn "," (listMoves getBoard) in
    removeFirstElement move

-----------------------------------------------

removeFirstElement :: String -> String
removeFirstElement "" = ""
removeFirstElement (y:rest) = rest

removeLastElement :: String -> String
removeLastElement "" = ""
removeLastElement list = init list

-----------------------------------------------

convertBoardString :: String -> String
convertBoardString "" = ""
convertBoardString (x:rest) = convertChar x ++ convertBoardString rest

convertChar :: Char -> String
convertChar x
    | x == 'w' || x == 'b' || x == 'W' || x == 'B' || x == '/'  = [x]
    | otherwise                                                 = extendNumber(digitToInt x)

extendNumber :: Int -> String
extendNumber 0 = ""
extendNumber x = "1" ++ extendNumber (x-1)

-----------------------------------------------

convertMove :: (Int, Int, Int, Int) -> String
convertMove (startColumn, startRow, targetColumn, targetRow) = getValidMove (convertColumn startColumn ++ convertRow startRow ++ "-" ++ convertColumn targetColumn ++ convertRow targetRow ++ ",")

getValidMove :: String -> String
getValidMove "-," = ""
getValidMove s = s

convertRow :: Int -> String
convertRow 20 = ""
convertRow x = show x

convertColumn :: Int -> String
convertColumn 0 = "a"
convertColumn 1 = "b"
convertColumn 2 = "c"
convertColumn 3 = "d"
convertColumn 4 = "e"
convertColumn 5 = "f"
convertColumn 6 = "g"
convertColumn 7 = "h"
convertColumn 8 = "i"
convertColumn 9 = "j"
convertColumn 20 = ""
convertColumn _ = "column out of area"

-----------------------------------------------

getBoard :: String
--getBoard = "111111111w/9W"
getBoard = "ww1w1w1w1w/4W5"

listMoves :: String -> String
listMoves y =
    let cBoard = splitOn "/" (convertBoardString getBoard) in
    "[" ++ removeLastElement(findMoves cBoard) ++ "]"

findMoves :: [String] -> String
findMoves = findForwardMoves

findForwardMoves :: [String] -> String
findForwardMoves (row1:row2:rest) = findForwardMove row1 0 9 row2 0 8

-- row1 startColumn startRow row2 targetColumn targetRow
findForwardMove :: String -> Int -> Int -> String -> Int -> Int -> String
findForwardMove "" _ _ _ _ _ = ""
findForwardMove _ _ _ "" _ _ = ""
findForwardMove (start:restRow1) startColumn startRow (target:restRow2) targetColumn targetRow =
  convertMove (targetEmpty start startColumn startRow target targetColumn targetRow) ++ findForwardMove restRow1 (startColumn+1) startRow restRow2 (targetColumn+1) targetRow

targetEmpty :: Char -> Int -> Int -> Char -> Int -> Int -> (Int, Int, Int, Int)
targetEmpty 'w' startColumn startRow '1' targetColumn targetRow = (startColumn, startRow, targetColumn, targetRow)
targetEmpty _ _ _ _ _ _ = (20,20,20,20)
