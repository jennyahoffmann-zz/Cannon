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
convertBoardString s = convertChars(handleEmptyRows s)

handleEmptyRows :: String -> String
handleEmptyRows s = handleMiddleRows(handleLastRow(handleFirstRow s))

handleFirstRow :: String -> String
handleFirstRow s
    | '/' == head s = "1111111111" ++ s
    | otherwise     = s

handleLastRow :: String -> String
handleLastRow s
    | '/' == last s = s ++ "1111111111"
    | otherwise     = s

handleMiddleRows :: String -> String
handleMiddleRows (c1:c2:[]) --don't change this, doesb't work with [c1, c2]
    | '/' == c1 && '/' == c2 = c1:"1111111111"
    | otherwise              = [c1]
handleMiddleRows (c1:c2:rest)
    | '/' == c1 && '/' == c2 = (c1:"1111111111") ++ handleMiddleRows (c2:rest)
    | otherwise              = c1:handleMiddleRows (c2:rest)

convertChars :: String -> String
convertChars "" = ""
convertChars (x:rest) = convertChar x ++ convertChars rest

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

setTown :: Char -> [String] -> String
setTown 'b' board = findAllFreeFieldsInRow (removeFirstElement(removeLastElement(last board))) 1 0 --remove first and last field since we cannot put the town in the corners
setTown 'w' board = findAllFreeFieldsInRow (removeFirstElement(removeLastElement(head board))) 1 9

findAllFreeFieldsInRow :: String -> Int -> Int -> String
findAllFreeFieldsInRow [] column row = convertMove(column, row, column, row) -- sonst fehlt letztes feld; weiss aber nicht warum
findAllFreeFieldsInRow (x:restRow) column row
    | x == '1' = convertMove(column, row, column, row) ++ findAllFreeFieldsInRow restRow (column+1) row
    | otherwise = findAllFreeFieldsInRow restRow (column+1) row

isTownSet :: Char -> [String] -> Bool
isTownSet 'b' board = isTownInRow 'B' (last board)
isTownSet 'w' board = isTownInRow 'W' (head board)

isTownInRow :: Char -> String -> Bool
isTownInRow _ [] = False
isTownInRow c (x:restRow)
    | x == c    = True
    | otherwise = isTownInRow c restRow

-----------------------------------------------

findForwardMoves :: Char -> [String] -> String
findForwardMoves player board = findStraightForwardMoves player board 8 9 ++ findDiagonallyToLeftForwardMoves player board 8 9 ++ findDiagonallyToRightForwardMoves player board 8 9

-- player board (startColumn=0) startRow (targetColumn=0) targetRow
findStraightForwardMoves :: Char -> [String] -> Int -> Int -> String
findStraightForwardMoves 'b' [row1, row2] startRow targetRow = findForwardMoveInRow 'b' row2 0 startRow row1 0 targetRow
findStraightForwardMoves 'w' [row1, row2] targetRow startRow = findForwardMoveInRow 'w' row1 0 startRow row2 0 targetRow
findStraightForwardMoves 'b' (row1:row2:rest) startRow targetRow = findForwardMoveInRow 'b' row2 0 startRow row1 0 targetRow ++ findStraightForwardMoves 'b' (row2:rest) (startRow-1) (targetRow-1)
findStraightForwardMoves 'w' (row1:row2:rest) targetRow startRow = findForwardMoveInRow 'w' row1 0 startRow row2 0 targetRow ++ findStraightForwardMoves 'w' (row2:rest) (targetRow-1) (startRow-1)

findDiagonallyToLeftForwardMoves :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftForwardMoves 'b' [row1, row2] startRow targetRow = findForwardMoveInRow 'b' (removeFirstElement row2) 1 startRow row1 0 targetRow
findDiagonallyToLeftForwardMoves 'w' [row1, row2] targetRow startRow = findForwardMoveInRow 'w' (removeFirstElement row1) 1 startRow row2 0 targetRow
findDiagonallyToLeftForwardMoves 'b' (row1:row2:rest) startRow targetRow = findForwardMoveInRow 'b' (removeFirstElement row2) 1 startRow row1 0 targetRow ++ findDiagonallyToLeftForwardMoves 'b' (row2:rest) (startRow-1) (targetRow-1)
findDiagonallyToLeftForwardMoves 'w' (row1:row2:rest) targetRow startRow = findForwardMoveInRow 'w' (removeFirstElement row1) 1 startRow row2 0 targetRow ++ findDiagonallyToLeftForwardMoves 'w' (row2:rest) (targetRow-1) (startRow-1)

findDiagonallyToRightForwardMoves :: Char -> [String] -> Int -> Int -> String
findDiagonallyToRightForwardMoves 'b' [row1, row2] startRow targetRow = findForwardMoveInRow 'b' row2 1 startRow (removeFirstElement row1) 0 targetRow
findDiagonallyToRightForwardMoves 'w' [row1, row2] targetRow startRow = findForwardMoveInRow 'w' row1 1 startRow (removeFirstElement row2) 0 targetRow
findDiagonallyToRightForwardMoves 'b' (row1:row2:rest) startRow targetRow = findForwardMoveInRow 'b' row2 0 startRow (removeFirstElement row1) 1 targetRow ++ findDiagonallyToRightForwardMoves 'b' (row2:rest) (startRow-1) (targetRow-1)
findDiagonallyToRightForwardMoves 'w' (row1:row2:rest) targetRow startRow = findForwardMoveInRow 'w' row1 0 startRow (removeFirstElement row2) 1 targetRow ++ findDiagonallyToRightForwardMoves 'w' (row2:rest) (targetRow-1) (startRow-1)

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

-----------------------------------------------

targetEnemy :: Char -> Int -> Int -> Char -> Int -> Int -> (Int, Int, Int, Int)
targetEnemy 'w' startColumn startRow 'b' targetColumn targetRow = (startColumn, startRow, targetColumn, targetRow)
targetEnemy 'w' startColumn startRow 'B' targetColumn targetRow = (startColumn, startRow, targetColumn, targetRow)
targetEnemy 'b' startColumn startRow 'w' targetColumn targetRow = (startColumn, startRow, targetColumn, targetRow)
targetEnemy 'b' startColumn startRow 'W' targetColumn targetRow = (startColumn, startRow, targetColumn, targetRow)
targetEnemy _ _ _ _ _ _ = (20,20,20,20)

-----------------------------------------------

findCaptures :: Char -> [String] -> String
findCaptures player board = findStraightForwardCaptures player board 8 9 ++ findStraightBackwardCaptures player board 8 9
  ++ findDiagonallyToLeftForwardCaptures player board 8 9 ++ findDiagonallyToRightForwardCaptures player board 8 9 ++ findDiagonallyToRightBackwardCaptures player board 8 9
  ++ findDiagonallyToLeftBackwardCaptures player board 8 9 ++ findSidewaysToLeftCaptures player board 9 9 ++ findSidewaysToRightCaptures player board 9 9

-- player board (startColumn=0) startRow (targetColumn=0) targetRow
findStraightForwardCaptures :: Char -> [String] -> Int -> Int -> String
findStraightForwardCaptures 'b' [row1, row2] startRow targetRow = findCaptureInRow 'b' row2 0 startRow row1 0 targetRow
findStraightForwardCaptures 'w' [row1, row2] targetRow startRow = findCaptureInRow 'w' row1 0 startRow row2 0 targetRow
findStraightForwardCaptures 'b' (row1:row2:rest) startRow targetRow = findCaptureInRow 'b' row2 0 startRow row1 0 targetRow ++ findStraightForwardCaptures 'b' (row2:rest) (startRow-1) (targetRow-1)
findStraightForwardCaptures 'w' (row1:row2:rest) targetRow startRow = findCaptureInRow 'w' row1 0 startRow row2 0 targetRow ++ findStraightForwardCaptures 'w' (row2:rest) (targetRow-1) (startRow-1)

findStraightBackwardCaptures :: Char -> [String] -> Int -> Int -> String
findStraightBackwardCaptures 'b' [row1, row2] targetRow startRow = findCaptureInRow 'b' row1 0 startRow row2 0 targetRow
findStraightBackwardCaptures 'w' [row1, row2] startRow targetRow = findCaptureInRow 'w' row2 0 startRow row1 0 targetRow
findStraightBackwardCaptures 'b' (row1:row2:rest) targetRow startRow = findCaptureInRow 'b' row1 0 startRow row2 0 targetRow ++ findStraightBackwardCaptures 'b' (row2:rest) (targetRow-1) (startRow-1)
findStraightBackwardCaptures 'w' (row1:row2:rest) startRow targetRow = findCaptureInRow 'w' row2 0 startRow row1 0 targetRow ++ findStraightBackwardCaptures 'w' (row2:rest) (startRow-1) (targetRow-1)

findDiagonallyToLeftForwardCaptures :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftForwardCaptures 'b' [row1, row2] startRow targetRow = findCaptureInRow 'b' (removeFirstElement row2) 1 startRow row1 0 targetRow
findDiagonallyToLeftForwardCaptures 'w' [row1, row2] targetRow startRow = findCaptureInRow 'w' (removeFirstElement row1) 1 startRow row2 0 targetRow
findDiagonallyToLeftForwardCaptures 'b' (row1:row2:rest) startRow targetRow = findCaptureInRow 'b' (removeFirstElement row2) 1 startRow row1 0 targetRow ++ findDiagonallyToLeftForwardCaptures 'b' (row2:rest) (startRow-1) (targetRow-1)
findDiagonallyToLeftForwardCaptures 'w' (row1:row2:rest) targetRow startRow = findCaptureInRow 'w' (removeFirstElement row1) 1 startRow row2 0 targetRow ++ findDiagonallyToLeftForwardCaptures 'w' (row2:rest) (targetRow-1) (startRow-1)

findDiagonallyToRightForwardCaptures :: Char -> [String] -> Int -> Int -> String
findDiagonallyToRightForwardCaptures 'b' [row1, row2] startRow targetRow = findCaptureInRow 'b' (removeFirstElement row2) 1 startRow row1 0 targetRow
findDiagonallyToRightForwardCaptures 'w' [row1, row2] targetRow startRow = findCaptureInRow 'w' (removeFirstElement row1) 1 startRow row2 0 targetRow
findDiagonallyToRightForwardCaptures 'b' (row1:row2:rest) startRow targetRow = findCaptureInRow 'b' row2 0 startRow (removeFirstElement row1) 1 targetRow ++ findDiagonallyToRightForwardCaptures 'b' (row2:rest) (startRow-1) (targetRow-1)
findDiagonallyToRightForwardCaptures 'w' (row1:row2:rest) targetRow startRow = findCaptureInRow 'w' row1 0 startRow (removeFirstElement row2) 1 targetRow ++ findDiagonallyToRightForwardCaptures 'w' (row2:rest) (targetRow-1) (startRow-1)

findDiagonallyToRightBackwardCaptures :: Char -> [String] -> Int -> Int -> String
findDiagonallyToRightBackwardCaptures 'b' [row1, row2] targetRow startRow = findCaptureInRow 'b' row1 0 startRow (removeFirstElement row2) 1 targetRow
findDiagonallyToRightBackwardCaptures 'w' [row1, row2] startRow targetRow = findCaptureInRow 'w' row2 0 startRow (removeFirstElement row1) 1 targetRow
findDiagonallyToRightBackwardCaptures 'b' (row1:row2:rest) targetRow startRow = findCaptureInRow 'b' row1 0 startRow (removeFirstElement row2) 1 targetRow ++ findDiagonallyToRightBackwardCaptures 'b' (row2:rest) (targetRow-1) (startRow-1)
findDiagonallyToRightBackwardCaptures 'w' (row1:row2:rest) startRow targetRow = findCaptureInRow 'w' row2 0 startRow (removeFirstElement row1) 1 targetRow ++ findDiagonallyToRightBackwardCaptures 'w' (row2:rest) (startRow-1) (targetRow-1)

findDiagonallyToLeftBackwardCaptures :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftBackwardCaptures 'b' [row1, row2] targetRow startRow = findCaptureInRow 'b' (removeFirstElement row1) 1 startRow row2 0 targetRow
findDiagonallyToLeftBackwardCaptures 'w' [row1, row2] startRow targetRow = findCaptureInRow 'w' (removeFirstElement row2) 1 startRow row1 0 targetRow
findDiagonallyToLeftBackwardCaptures 'b' (row1:row2:rest) targetRow startRow = findCaptureInRow 'b' (removeFirstElement row1) 1 startRow row2 0 targetRow ++ findDiagonallyToLeftBackwardCaptures 'b' (row2:rest) (targetRow-1) (startRow-1)
findDiagonallyToLeftBackwardCaptures 'w' (row1:row2:rest) startRow targetRow = findCaptureInRow 'w' (removeFirstElement row2) 1 startRow row1 0 targetRow ++ findDiagonallyToLeftBackwardCaptures 'w' (row2:rest) (startRow-1) (targetRow-1)

findSidewaysToLeftCaptures :: Char -> [String] -> Int -> Int -> String
findSidewaysToLeftCaptures player [row] startRow targetRow = findCaptureInRow player (removeFirstElement row) 1 startRow row 0 targetRow
findSidewaysToLeftCaptures player (row:rest) startRow targetRow = findCaptureInRow player (removeFirstElement row) 1 startRow row 0 targetRow ++ findSidewaysToLeftCaptures player rest (startRow-1) (targetRow-1)

findSidewaysToRightCaptures :: Char -> [String] -> Int -> Int -> String
findSidewaysToRightCaptures player [row] startRow targetRow = findCaptureInRow player row 0 startRow (removeFirstElement row) 1 targetRow
findSidewaysToRightCaptures player (row:rest) startRow targetRow = findCaptureInRow player row 0 startRow (removeFirstElement row) 1 targetRow ++ findSidewaysToRightCaptures player rest (startRow-1) (targetRow-1)

-- player row1 startColumn startRow row2 targetColumn targetRow
findCaptureInRow :: Char -> String -> Int -> Int -> String -> Int -> Int -> String
findCaptureInRow _ "" _ _ _ _ _ = ""
findCaptureInRow _ _ _ _ "" _ _ = ""
findCaptureInRow player (start:restRow1) startColumn startRow (target:restRow2) targetColumn targetRow =
  if start == player then convertMove (targetEnemy start startColumn startRow target targetColumn targetRow) ++ findCaptureInRow player restRow1 (startColumn+1) startRow restRow2 (targetColumn+1) targetRow
  else "" ++ findCaptureInRow player restRow1 (startColumn+1) startRow restRow2 (targetColumn+1) targetRow

-----------------------------------------------

getBoard :: String
--getBoard = "111111111w/9W w"
--getBoard = "ww1w1w1w1w/4W5/1111w1111w/9B w"
getBoard = "1Wb7/ww1w1w1w1w/2w7/11bbw111ww/2w7/4w6/3b6/4w5//1B5w2 b"

listMoves :: String -> String
listMoves y =
    let player = last getBoard
        cBoard = splitOn "/" (convertBoardString (removeLastElement(removeLastElement getBoard))) in
    "[" ++ removeLastElement(findMoves player cBoard) ++ "]"

findMoves :: Char -> [String] -> String
findMoves player board
    | isTownSet player board = findForwardMoves player board ++ findCaptures player board
    | otherwise              = setTown player board
