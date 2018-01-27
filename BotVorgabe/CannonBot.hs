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
    | x == 'w' || x == 'b' || x == 'W' || x == 'B' || x == '/' || x==' '  = [x]
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
--getBoard = "111111111w/9W w"
--getBoard = "ww1w1w1w1w/4W5/1111w1111w/9W w"
getBoard = "ww1w1w1w1w/4W5/11bbw111ww/9W w"

listMoves :: String -> String
listMoves y =
    let player = last getBoard
        cBoard = splitOn "/" (convertBoardString (removeLastElement(removeLastElement getBoard))) in
    "[" ++ removeLastElement(findMoves player cBoard) ++ "]"

findMoves :: Char -> [String] -> String
findMoves = findForwardMoves

findForwardMoves :: Char -> [String] -> String
findForwardMoves player board = findStraightForwardMoves player board 8 9

-- player board (startColumn=0) startRow (targetColumn=0) targetRow
findStraightForwardMoves :: Char -> [String] -> Int -> Int -> String
findStraightForwardMoves 'b' [row1, row2] startRow targetRow = findForwardMoveInRow 'b' row2 0 startRow row1 0 targetRow
findStraightForwardMoves 'w' [row1, row2] targetRow startRow = findForwardMoveInRow 'w' row1 0 startRow row2 0 targetRow
findStraightForwardMoves 'b' (row1:row2:rest) startRow targetRow = findForwardMoveInRow 'b' row2 0 startRow row1 0 targetRow ++ findStraightForwardMoves 'b' (row2:rest) (startRow-1) (targetRow-1)
findStraightForwardMoves 'w' (row1:row2:rest) targetRow startRow = findForwardMoveInRow 'w' row1 0 startRow row2 0 targetRow ++ findStraightForwardMoves 'w' (row2:rest) (targetRow-1) (startRow-1)

-- player row1 startColumn startRow row2 targetColumn targetRow
findForwardMoveInRow :: Char -> String -> Int -> Int -> String -> Int -> Int -> String
findForwardMoveInRow _ "" _ _ _ _ _ = ""
findForwardMoveInRow _ _ _ _ "" _ _ = ""
findForwardMoveInRow player (start:restRow1) startColumn startRow (target:restRow2) targetColumn targetRow =
  if start == player then convertMove (targetEmpty start startColumn startRow target targetColumn targetRow) ++ findForwardMoveInRow player restRow1 (startColumn+1) startRow restRow2 (targetColumn+1) targetRow
  else "" ++ findForwardMoveInRow player restRow1 (startColumn+1) startRow restRow2 (targetColumn+1) targetRow

targetEmpty :: Char -> Int -> Int -> Char -> Int -> Int -> (Int, Int, Int, Int)
targetEmpty 'w' startColumn startRow '1' targetColumn targetRow = (startColumn, startRow, targetColumn, targetRow)
targetEmpty 'b' startColumn startRow '1' targetColumn targetRow = (startColumn, startRow, targetColumn, targetRow)
targetEmpty _ _ _ _ _ _ = (20,20,20,20)
