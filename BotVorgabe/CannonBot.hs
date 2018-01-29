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
convertBoardString s = convertChars(handleEmptyRows getBoard)

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
handleMiddleRows (c1:c2:[]) --don't change this, doesn't work with [c1, c2]
    | '/' == c1 && '/' == c2 = c1:"1111111111"
    | otherwise              = [c1]
handleMiddleRows (c1:c2:rest)
    | '/' == c1 && '/' == c2 = (c1:"1111111111") ++ handleMiddleRows (c2:rest)
    | otherwise              = c1:handleMiddleRows (c2:rest)

convertChars :: String -> String
convertChars [x] = convertChar x
convertChars (x:rest) = convertChar x ++ convertChars rest

convertChar :: Char -> String
convertChar x
    | x == 'w' || x == 'b' || x == 'W' || x == 'B' || x == '/' || x==' '  = [x]
    | otherwise                                                 = extendNumber(digitToInt x)

extendNumber :: Int -> String
extendNumber 1 = "1"
extendNumber x = "1" ++ extendNumber (x-1)

removeSpace :: [String] -> [String]
removeSpace [row] =  if last row == ' ' then [init row] else [row]
removeSpace (row:rest) = if last row == ' ' then init row:removeSpace rest else row:removeSpace rest

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
findDiagonallyToRightForwardMoves 'b' [row1, row2] startRow targetRow = findForwardMoveInRow 'b' row2 0 startRow (removeFirstElement row1) 1 targetRow
findDiagonallyToRightForwardMoves 'w' [row1, row2] targetRow startRow = findForwardMoveInRow 'w' row1 0 startRow (removeFirstElement row2) 1 targetRow
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
findCaptures player board = findStraightForwardCaptures player board 8 9 ++ findDiagonallyToLeftForwardCaptures player board 8 9 ++ findDiagonallyToRightForwardCaptures player board 8 9
                            ++ findSidewaysToLeftCaptures player board 9 9 ++ findSidewaysToRightCaptures player board 9 9

-- player board (startColumn=0) startRow (targetColumn=0) targetRow
findStraightForwardCaptures :: Char -> [String] -> Int -> Int -> String
findStraightForwardCaptures 'b' [row1, row2] startRow targetRow = findCaptureInRow 'b' row2 0 startRow row1 0 targetRow
findStraightForwardCaptures 'w' [row1, row2] targetRow startRow = findCaptureInRow 'w' row1 0 startRow row2 0 targetRow
findStraightForwardCaptures 'b' (row1:row2:rest) startRow targetRow = findCaptureInRow 'b' row2 0 startRow row1 0 targetRow ++ findStraightForwardCaptures 'b' (row2:rest) (startRow-1) (targetRow-1)
findStraightForwardCaptures 'w' (row1:row2:rest) targetRow startRow = findCaptureInRow 'w' row1 0 startRow row2 0 targetRow ++ findStraightForwardCaptures 'w' (row2:rest) (targetRow-1) (startRow-1)

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

findRetreats :: Char -> [String] -> String
findRetreats player board = findRetreatsBlack player board ++ findRetreatsWhite player board

-- player board startRow targetRow
findRetreatsBlack :: Char -> [String] -> String
findRetreatsBlack 'w' _ = ""
findRetreatsBlack 'b' board = findStraightRetreats 'b' board 2 0 ++ findDiagonallyToLeftRretreats 'b' board 2 0 ++ findDiagonallyToRightRretreats 'b' board 2 0

findRetreatsWhite :: Char -> [String] -> String
findRetreatsWhite 'b' _ = ""
findRetreatsWhite 'w' board = findStraightRetreats 'w' board 7 9  ++ findDiagonallyToLeftRretreats 'w' board 7 9 ++ findDiagonallyToRightRretreats 'w' board 7 9

findStraightRetreats :: Char -> [String] -> Int -> Int -> String
findStraightRetreats 'w' [row1, row2, row3, row4] startRow targetRow = findStraightRetreatInRow 'w' row4 row3 row2 row1 0 startRow 0 targetRow  ++ findStraightRetreatInRow 'w' "1111111111" row4 row3 row2 0 (startRow-1) 0 (targetRow-1)
findStraightRetreats 'w' (row1:row2:row3:row4:restBoard) startRow targetRow = findStraightRetreatInRow 'w' row4 row3 row2 row1 0 startRow 0 targetRow ++ findStraightRetreats 'w' (row2:row3:row4:restBoard) (startRow-1) (targetRow-1)
findStraightRetreats 'b' [row1, row2, row3, row4] startRow targetRow = findStraightRetreatInRow 'b' row1 row2 row3 row4 0 startRow 0 targetRow ++ findStraightRetreatInRow 'b' "1111111111" row1 row2 row3 0 (startRow+1) 0 (targetRow+1)
findStraightRetreats 'b' board startRow targetRow = let (row1, row2, row3, row4) = getLatFourRows board in findStraightRetreatInRow 'b' row1 row2 row3 row4 0 startRow 0 targetRow ++ findStraightRetreats 'b' (init board) (startRow+1) (targetRow+1)

findStraightRetreatInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findStraightRetreatInRow player (a1:a2:row1) (b1:b2:row2) (c1:c2:row3) (d1:row4) startColumn startRow targetColumn targetRow
    | b1 == player && isSurroundedBy (getOpponent player) a1 a2 b2 c1 c2 '1' '1' '1' && isFieldEmpty d1 && isFieldEmpty c1 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findStraightRetreatInRowLoop player (a1:a2:row1) (b1:b2:row2) (c1:c2:row3) (d1:row4) (startColumn+1) startRow (targetColumn+1) targetRow
    | otherwise = "" ++ findStraightRetreatInRowLoop player (a1:a2:row1) (b1:b2:row2) (c1:c2:row3) (d1:row4) (startColumn+1) startRow (targetColumn+1) targetRow

findStraightRetreatInRowLoop :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findStraightRetreatInRowLoop _ [x] _ _ _ _ _ _ _ = ""
findStraightRetreatInRowLoop _ _ [x] _ _ _ _ _ _ = ""
findStraightRetreatInRowLoop _ _ _ [x] _ _ _ _ _ = ""
findStraightRetreatInRowLoop _ _ _ _ [x] _ _ _ _ = ""
findStraightRetreatInRowLoop player [a1,a2] [b1,b2] [c1,c2] [d1,d2] startColumn startRow targetColumn targetRow
    | b2 == player && isSurroundedBy (getOpponent player) a1 a2 '1' b1 '1' c1 c2 '1' && isFieldEmpty c2 && isFieldEmpty d2 = convertMove(startColumn, startRow, targetColumn, targetRow)
    | otherwise = ""
findStraightRetreatInRowLoop player (a1:a2:a3:row1) (b1:b2:b3:row2) (c1:c2:c3:row3) (d1:d2:row4) startColumn startRow targetColumn targetRow
    | b2 == player && isSurroundedBy (getOpponent player) a1 a2 a3 b1 b3 c1 c2 c3 && isFieldEmpty c2 && isFieldEmpty d2 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findStraightRetreatInRowLoop player (a2:a3:row1) (b2:b3:row2) (c2:c3:row3) (d2:row4) (startColumn+1) startRow (targetColumn+1) targetRow
    | otherwise = "" ++ findStraightRetreatInRowLoop player (a2:a3:row1) (b2:b3:row2) (c2:c3:row3) (d2:row4) (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToLeftRretreats :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftRretreats 'w' [row1, row2, row3, row4] startRow targetRow = findDiagonallyToLeftRetreatInRow 'w' row4 row3 row2 row1 2 startRow 0 targetRow  ++ findDiagonallyToLeftRetreatInRow 'w' "1111111111" row4 row3 row2 2 (startRow-1) 0 (targetRow-1)
findDiagonallyToLeftRretreats 'w' (row1:row2:row3:row4:restBoard) startRow targetRow = findDiagonallyToLeftRetreatInRow 'w' row4 row3 row2 row1 2 startRow 0 targetRow ++ findDiagonallyToLeftRretreats 'w' (row2:row3:row4:restBoard) (startRow-1) (targetRow-1)
findDiagonallyToLeftRretreats 'b' [row1, row2, row3, row4] startRow targetRow = findDiagonallyToLeftRetreatInRow 'b' row1 row2 row3 row4 2 startRow 0 targetRow ++ findDiagonallyToLeftRetreatInRow 'b' "1111111111" row1 row2 row3 2 (startRow+1) 0 (targetRow+1)
findDiagonallyToLeftRretreats 'b' board startRow targetRow = let (row1, row2, row3, row4) = getLatFourRows board in findDiagonallyToLeftRetreatInRow 'b' row1 row2 row3 row4 2 startRow 0 targetRow ++ findDiagonallyToLeftRretreats 'b' (init board) (startRow+1) (targetRow+1)

findDiagonallyToLeftRetreatInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToLeftRetreatInRow _ [x,y] _ _ _ _ _ _ _ = ""
findDiagonallyToLeftRetreatInRow _ _ [x,y] _ _ _ _ _ _ = ""
findDiagonallyToLeftRetreatInRow _ _ _ [x,y] _ _ _ _ _ = ""
findDiagonallyToLeftRetreatInRow _ _ _ _ [x,y] _ _ _ _ = ""
findDiagonallyToLeftRetreatInRow player [a1,a2,a3] [b1,b2,b3] [c1,c2,c3] [d1,d2,d3] startColumn startRow targetColumn targetRow
    | b3 == player && isSurroundedBy (getOpponent player) a2 a3 '1' b2 '1' c2 c3 '1' && isFieldEmpty d1 && isFieldEmpty c2 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ ""
    | otherwise = ""
findDiagonallyToLeftRetreatInRow player (a1:a2:a3:a4:row1) (b1:b2:b3:b4:row2) (c1:c2:c3:c4:row3) (d1:row4) startColumn startRow targetColumn targetRow
    | b3 == player && isSurroundedBy (getOpponent player) a2 a3 a4 b2 b4 c2 c3 c4 && isFieldEmpty d1 && isFieldEmpty c2 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToLeftRetreatInRow player (a2:a3:a4:row1) (b2:b3:b4:row2) (c2:c3:c4:row3) row4 (startColumn+1) startRow (targetColumn+1) targetRow
    | otherwise = "" ++ findDiagonallyToLeftRetreatInRow player (a2:a3:a4:row1) (b2:b3:b4:row2) (c2:c3:c4:row3) row4 (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToRightRretreats :: Char -> [String] -> Int -> Int -> String
findDiagonallyToRightRretreats 'w' [row1, row2, row3, row4] startRow targetRow = findDiagonallyToRightRretreatInRow 'w' row4 row3 row2 row1 0 startRow 2 targetRow  ++ findDiagonallyToRightRretreatInRow 'w' "1111111111" row4 row3 row2 0 (startRow-1) 2 (targetRow-1)
findDiagonallyToRightRretreats 'w' (row1:row2:row3:row4:restBoard) startRow targetRow = findDiagonallyToRightRretreatInRow 'w' row4 row3 row2 row1 0 startRow 2 targetRow ++ findDiagonallyToRightRretreats 'w' (row2:row3:row4:restBoard) (startRow-1) (targetRow-1)
findDiagonallyToRightRretreats 'b' [row1, row2, row3, row4] startRow targetRow = findDiagonallyToRightRretreatInRow 'b' row1 row2 row3 row4 0 startRow 2 targetRow ++ findDiagonallyToRightRretreatInRow 'b' "1111111111" row1 row2 row3 0 (startRow+1) 2 (targetRow+1)
findDiagonallyToRightRretreats 'b' board startRow targetRow = let (row1, row2, row3, row4) = getLatFourRows board in findDiagonallyToRightRretreatInRow 'b' row1 row2 row3 row4 0 startRow 2 targetRow ++ findDiagonallyToRightRretreats 'b' (init board) (startRow+1) (targetRow+1)

findDiagonallyToRightRretreatInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToRightRretreatInRow player (a1:a2:row1) (b1:b2:row2) (c1:c2:row3) (d1:d2:d3:row4) startColumn startRow targetColumn targetRow
    | b1 == player && isSurroundedBy (getOpponent player) a1 a2 b2 c1 c2 '1' '1' '1' && isFieldEmpty d3 && isFieldEmpty c2 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToRightRretreatInRowLoop player (a1:a2:row1) (b1:b2:row2) (c1:c2:row3) (d1:d2:d3:row4) (startColumn+1) startRow (targetColumn+1) targetRow
    | otherwise = "" ++ findDiagonallyToRightRretreatInRowLoop player (a1:a2:row1) (b1:b2:row2) (c1:c2:row3) (d1:d2:d3:row4) (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToRightRretreatInRowLoop :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToRightRretreatInRowLoop _ [_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToRightRretreatInRowLoop _ _ [_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToRightRretreatInRowLoop _ _ _ [_,_,_] _ _ _ _ _ = ""
findDiagonallyToRightRretreatInRowLoop _ _ _ _ [_,_,_] _ _ _ _ = ""
findDiagonallyToRightRretreatInRowLoop player [a1,a2,a3,a4] [b1,b2,b3,b4] [c1,c2,c3,c4] [d1,d2,d3,d4] startColumn startRow targetColumn targetRow
    | b2 == player && isSurroundedBy (getOpponent player) a1 a2 a3 b1 b3 c1 c2 c3 && isFieldEmpty c3 && isFieldEmpty d4 = convertMove(startColumn, startRow, targetColumn, targetRow)
    | otherwise = ""
findDiagonallyToRightRretreatInRowLoop player (a1:a2:a3:row1) (b1:b2:b3:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) startColumn startRow targetColumn targetRow
    | b2 == player && isSurroundedBy (getOpponent player) a1 a2 a3 b1 b3 c1 c2 c3 && isFieldEmpty c3 && isFieldEmpty d4 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToRightRretreatInRowLoop player (a2:a3:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow
    | otherwise = "" ++ findDiagonallyToRightRretreatInRowLoop player (a2:a3:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow

getLatFourRows :: [String] -> (String, String, String, String)
getLatFourRows board =
  let row1 = last(init(init(init board)))
      row2 = last(init(init board))
      row3 = last(init board)
      row4 = last board in (row1, row2, row3, row4)

isFieldEmpty :: Char -> Bool
isFieldEmpty '1' = True
isFieldEmpty _ = False

isSurroundedBy ::  Char -> Char -> Char -> Char -> Char -> Char -> Char -> Char -> Char -> Bool
isSurroundedBy opponent f1 f2 f3 f4 f5 f6 f7 f8
    | f1 == opponent || f2 == opponent || f3 == opponent || f4 == opponent || f5 == opponent || f6 == opponent || f7 == opponent || f8 == opponent = True
    | otherwise = False

getOpponent :: Char -> Char
getOpponent 'b' = 'w'
getOpponent 'w' = 'b'

-----------------------------------------------

findCannonMoves :: Char -> [String] -> String
findCannonMoves player board = findStraightUpwardsCannonMoves player board 6 9 ++ findStraightDownwardsCannonMoves player board 9 6 ++ findDiagonallyToLeftUpwardsCannonMoves player board 6 9
                               ++ findDiagonallyToRightUpwardsCannonMoves player board 6 9 ++ findDiagonallyToLeftDownwardsCannonMoves player board 9 6 ++ findDiagonallyToRightDownwardsCannonMoves player board 9 6

findStraightUpwardsCannonMoves :: Char -> [String] -> Int -> Int -> String
findStraightUpwardsCannonMoves player [row1,row2,row3,row4] startRow targetRow = findStraightUpwardsCannonMoveInRow player row1 row2 row3 row4 0 startRow 0 targetRow
findStraightUpwardsCannonMoves player (row1:row2:row3:row4:board) startRow targetRow = findStraightUpwardsCannonMoveInRow player row1 row2 row3 row4 0 startRow 0 targetRow ++ findStraightUpwardsCannonMoves player (row2:row3:row4:board) (startRow-1) (targetRow-1)

findStraightUpwardsCannonMoveInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findStraightUpwardsCannonMoveInRow player [a] [b] [c] [d] startColumn startRow targetColumn targetRow
  | b == player && c == player && d == player && isFieldEmpty a = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findStraightUpwardsCannonMoveInRow player (a:row1) (b:row2) (c:row3) (d:row4) startColumn startRow targetColumn targetRow
  | b == player && c == player && d == player && isFieldEmpty a = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findStraightUpwardsCannonMoveInRow player row1 row2 row3 row4 (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findStraightUpwardsCannonMoveInRow player row1 row2 row3 row4 (startColumn+1) startRow (targetColumn+1) targetRow

findStraightDownwardsCannonMoves :: Char -> [String] -> Int -> Int -> String
findStraightDownwardsCannonMoves player [row1,row2,row3,row4] startRow targetRow = findStraightDownwardsCannonMoveInRow player row1 row2 row3 row4 0 startRow 0 targetRow
findStraightDownwardsCannonMoves player (row1:row2:row3:row4:board) startRow targetRow = findStraightDownwardsCannonMoveInRow player row1 row2 row3 row4 0 startRow 0 targetRow ++ findStraightDownwardsCannonMoves player (row2:row3:row4:board) (startRow-1) (targetRow-1)

findStraightDownwardsCannonMoveInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findStraightDownwardsCannonMoveInRow player [a] [b] [c] [d] startColumn startRow targetColumn targetRow
  | a == player && b == player && c == player && isFieldEmpty d = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findStraightDownwardsCannonMoveInRow player (a:row1) (b:row2) (c:row3) (d:row4) startColumn startRow targetColumn targetRow
  | b == player && c == player && a == player && isFieldEmpty d = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findStraightDownwardsCannonMoveInRow player row1 row2 row3 row4 (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findStraightDownwardsCannonMoveInRow player row1 row2 row3 row4 (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToLeftUpwardsCannonMoves :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftUpwardsCannonMoves player [row1,row2,row3,row4] startRow targetRow = findDiagonallyToLeftUpwardsCannonMoveInRow player row1 row2 row3 row4 3 startRow 0 targetRow
findDiagonallyToLeftUpwardsCannonMoves player (row1:row2:row3:row4:board) startRow targetRow = findDiagonallyToLeftUpwardsCannonMoveInRow player row1 row2 row3 row4 3 startRow 0 targetRow ++ findDiagonallyToLeftUpwardsCannonMoves player (row2:row3:row4:board) (startRow-1) (targetRow-1)

findDiagonallyToLeftUpwardsCannonMoveInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToLeftUpwardsCannonMoveInRow _ [_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToLeftUpwardsCannonMoveInRow _ _ [_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToLeftUpwardsCannonMoveInRow _ _ _ [_,_,_] _ _ _ _ _ = ""
findDiagonallyToLeftUpwardsCannonMoveInRow _ _ _ _ [_,_,_] _ _ _ _ = ""
findDiagonallyToLeftUpwardsCannonMoveInRow player [a1,a2,a3,a4] [b1,b2,b3,b4] [c1,c2,c3,c4] [d1,d2,d3,d4] startColumn startRow targetColumn targetRow
  | b2 == player && c3 == player && d4 == player && isFieldEmpty a1 = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findDiagonallyToLeftUpwardsCannonMoveInRow player (a1:a2:a3:row1) (b1:b2:b3:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) startColumn startRow targetColumn targetRow
  | b2 == player && c3 == player && d4 == player && isFieldEmpty a1 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToLeftUpwardsCannonMoveInRow player (a2:a3:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findDiagonallyToLeftUpwardsCannonMoveInRow player (a2:a3:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToRightUpwardsCannonMoves :: Char -> [String] -> Int -> Int -> String
findDiagonallyToRightUpwardsCannonMoves player [row1,row2,row3,row4] startRow targetRow = findDiagonallyToRightUpwardsCannonMoveInRow player row1 row2 row3 row4 0 startRow 3 targetRow
findDiagonallyToRightUpwardsCannonMoves player (row1:row2:row3:row4:board) startRow targetRow = findDiagonallyToRightUpwardsCannonMoveInRow player row1 row2 row3 row4 0 startRow 3 targetRow ++ findDiagonallyToRightUpwardsCannonMoves player (row2:row3:row4:board) (startRow-1) (targetRow-1)

findDiagonallyToRightUpwardsCannonMoveInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToRightUpwardsCannonMoveInRow _ [_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToRightUpwardsCannonMoveInRow _ _ [_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToRightUpwardsCannonMoveInRow _ _ _ [_,_,_] _ _ _ _ _ = ""
findDiagonallyToRightUpwardsCannonMoveInRow _ _ _ _ [_,_,_] _ _ _ _ = ""
findDiagonallyToRightUpwardsCannonMoveInRow player [a1,a2,a3,a4] [b1,b2,b3,b4] [c1,c2,c3,c4] [d1,d2,d3,d4] startColumn startRow targetColumn targetRow
  | d1 == player && c2 == player && b3 == player && isFieldEmpty a4 = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findDiagonallyToRightUpwardsCannonMoveInRow player (a1:a2:a3:a4:row1) (b1:b2:b3:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) startColumn startRow targetColumn targetRow
  | d1 == player && c2 == player && b3 == player && isFieldEmpty a4 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToRightUpwardsCannonMoveInRow player (a2:a3:a4:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findDiagonallyToRightUpwardsCannonMoveInRow player (a2:a3:a4:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToLeftDownwardsCannonMoves :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftDownwardsCannonMoves player [row1,row2,row3,row4] startRow targetRow = findDiagonallyToLeftDownwardsCannonMoveInRow player row1 row2 row3 row4 3 startRow 0 targetRow
findDiagonallyToLeftDownwardsCannonMoves player (row1:row2:row3:row4:board) startRow targetRow = findDiagonallyToLeftDownwardsCannonMoveInRow player row1 row2 row3 row4 3 startRow 0 targetRow ++ findDiagonallyToLeftDownwardsCannonMoves player (row2:row3:row4:board) (startRow-1) (targetRow-1)

findDiagonallyToLeftDownwardsCannonMoveInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToLeftDownwardsCannonMoveInRow _ [_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToLeftDownwardsCannonMoveInRow _ _ [_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToLeftDownwardsCannonMoveInRow _ _ _ [_,_,_] _ _ _ _ _ = ""
findDiagonallyToLeftDownwardsCannonMoveInRow _ _ _ _ [_,_,_] _ _ _ _ = ""
findDiagonallyToLeftDownwardsCannonMoveInRow player [a1,a2,a3,a4] [b1,b2,b3,b4] [c1,c2,c3,c4] [d1,d2,d3,d4] startColumn startRow targetColumn targetRow
  | a4 == player && c2 == player && b3 == player && isFieldEmpty d1 = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findDiagonallyToLeftDownwardsCannonMoveInRow player (a1:a2:a3:a4:row1) (b1:b2:b3:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) startColumn startRow targetColumn targetRow
  | a4 == player && c2 == player && b3 == player && isFieldEmpty d1 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToLeftDownwardsCannonMoveInRow player (a2:a3:a4:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findDiagonallyToLeftDownwardsCannonMoveInRow player (a2:a3:a4:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToRightDownwardsCannonMoves :: Char -> [String] -> Int -> Int -> String
findDiagonallyToRightDownwardsCannonMoves player [row1,row2,row3,row4] startRow targetRow = findDiagonallyToRightDownwardsCannonMoveInRow player row1 row2 row3 row4 0 startRow 3 targetRow
findDiagonallyToRightDownwardsCannonMoves player (row1:row2:row3:row4:board) startRow targetRow = findDiagonallyToRightDownwardsCannonMoveInRow player row1 row2 row3 row4 0 startRow 3 targetRow ++ findDiagonallyToRightDownwardsCannonMoves player (row2:row3:row4:board) (startRow-1) (targetRow-1)

findDiagonallyToRightDownwardsCannonMoveInRow :: Char -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToRightDownwardsCannonMoveInRow _ [_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToRightDownwardsCannonMoveInRow _ _ [_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToRightDownwardsCannonMoveInRow _ _ _ [_,_,_] _ _ _ _ _ = ""
findDiagonallyToRightDownwardsCannonMoveInRow _ _ _ _ [_,_,_] _ _ _ _ = ""
findDiagonallyToRightDownwardsCannonMoveInRow player [a1,a2,a3,a4] [b1,b2,b3,b4] [c1,c2,c3,c4] [d1,d2,d3,d4] startColumn startRow targetColumn targetRow
  | a1 == player && b2 == player && c3 == player && isFieldEmpty d4 = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findDiagonallyToRightDownwardsCannonMoveInRow player (a1:a2:a3:a4:row1) (b1:b2:b3:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) startColumn startRow targetColumn targetRow
  | a1 == player && b2 == player && c3 == player && isFieldEmpty d4 = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToRightDownwardsCannonMoveInRow player (a2:a3:a4:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findDiagonallyToRightDownwardsCannonMoveInRow player (a2:a3:a4:row1) (b2:b3:row2) (c2:c3:row3) (d2:d3:d4:row4) (startColumn+1) startRow (targetColumn+1) targetRow

-----------------------------------------------

indStraightUpwardsShortCannonShots :: Char -> [String] -> Int -> Int -> String
findStraightUpwardsShortCannonShots player [row1,row2,row3,row4,row5] startRow targetRow = findStraightUpwardsShortCannonShotInRow player row1 row2 row3 row4 row5 0 startRow 0 targetRow
findStraightUpwardsShortCannonShots player (row1:row2:row3:row4:row5:board) startRow targetRow = findStraightUpwardsShortCannonShotInRow player row1 row2 row3 row4 row5 0 startRow 0 targetRow ++ findStraightUpwardsShortCannonShots player (row2:row3:row4:row5:board) (startRow-1) (targetRow-1)

findStraightUpwardsShortCannonShotInRow :: Char -> String -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findStraightUpwardsShortCannonShotInRow player [a] [b] [c] [d] [e] startColumn startRow targetColumn targetRow
  | e == player && c == player && d == player && isFieldEmpty b && a == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findStraightUpwardsShortCannonShotInRow player (a:row1) (b:row2) (c:row3) (d:row4) (e:row5) startColumn startRow targetColumn targetRow
  | e == player && c == player && d == player && isFieldEmpty b && a == getOpponent player  = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findStraightUpwardsShortCannonShotInRow player row1 row2 row3 row4 row5 (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findStraightUpwardsShortCannonShotInRow player row1 row2 row3 row4 row5 (startColumn+1) startRow (targetColumn+1) targetRow

findStraightDownwardsShortCannonShots :: Char -> [String] -> Int -> Int -> String
findStraightDownwardsShortCannonShots player [row1,row2,row3,row4,row5] startRow targetRow = findStraightDownwardsShortCannonShotInRow player row1 row2 row3 row4 row5 0 startRow 0 targetRow
findStraightDownwardsShortCannonShots player (row1:row2:row3:row4:row5:board) startRow targetRow = findStraightDownwardsShortCannonShotInRow player row1 row2 row3 row4 row5 0 startRow 0 targetRow ++ findStraightDownwardsShortCannonShots player (row2:row3:row4:row5:board) (startRow-1) (targetRow-1)

findStraightDownwardsShortCannonShotInRow :: Char -> String -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findStraightDownwardsShortCannonShotInRow player [a] [b] [c] [d] [e] startColumn startRow targetColumn targetRow
  | a == player && b == player && c == player && isFieldEmpty d && e == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findStraightDownwardsShortCannonShotInRow player (a:row1) (b:row2) (c:row3) (d:row4) (e:row5) startColumn startRow targetColumn targetRow
  | a == player && b == player && c == player && isFieldEmpty d && e == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findStraightDownwardsShortCannonShotInRow player row1 row2 row3 row4 row5 (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findStraightDownwardsShortCannonShotInRow player row1 row2 row3 row4 row5 (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToLeftUpwardsShortCannonShots :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftUpwardsShortCannonShots player [row1,row2,row3,row4,row5] startRow targetRow = findDiagonallyToLeftUpwardsShortCannonShotInRow player row1 row2 row3 row4 row5 4 startRow 0 targetRow
findDiagonallyToLeftUpwardsShortCannonShots player (row1:row2:row3:row4:row5:board) startRow targetRow = findDiagonallyToLeftUpwardsShortCannonShotInRow player row1 row2 row3 row4 row5 4 startRow 0 targetRow ++ findDiagonallyToLeftUpwardsShortCannonShots player (row2:row3:row4:row5:board) (startRow-1) (targetRow-1)

findDiagonallyToLeftUpwardsShortCannonShotInRow :: Char -> String -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToLeftUpwardsShortCannonShotInRow _ [_,_,_,_] _ _ _ _ _ _ _ _ = ""
findDiagonallyToLeftUpwardsShortCannonShotInRow _ _ [_,_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToLeftUpwardsShortCannonShotInRow _ _ _ [_,_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToLeftUpwardsShortCannonShotInRow _ _ _ _ [_,_,_,_] _ _ _ _ _ = ""
findDiagonallyToLeftUpwardsShortCannonShotInRow _ _ _ _ _ [_,_,_,_] _ _ _ _ = ""
findDiagonallyToLeftUpwardsShortCannonShotInRow player [a1,a2,a3,a4,a5] [b1,b2,b3,b4,b5] [c1,c2,c3,c4,c5] [d1,d2,d3,d4,d5] [e1,e2,e3,e4,e5] startColumn startRow targetColumn targetRow
  | e5 == player && d4 == player && c3 == player && isFieldEmpty b2 && a1 == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findDiagonallyToLeftUpwardsShortCannonShotInRow player (a1:a2:a3:a4:a5:row1) (b1:b2:b3:b4:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) (e1:e2:e3:e4:e5:row5) startColumn startRow targetColumn targetRow
  | e5 == player && d4 == player && c3 == player && isFieldEmpty b2 && a1 == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToLeftUpwardsShortCannonShotInRow player (a2:a3:a4:a5:row1) (b2:b3:b4:row2) (c2:c3:row3) (d2:d3:d4:row4) (e2:e3:e4:e5:row5) (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findDiagonallyToLeftUpwardsShortCannonShotInRow player (a2:a3:a4:a5:row1) (b2:b3:b4:row2) (c2:c3:row3) (d2:d3:d4:row4) (e2:e3:e4:e5:row5) (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToRightUpwardsShortCannonShots :: Char -> [String] -> Int -> Int -> String
findDiagonallyToRightUpwardsShortCannonShots player [row1,row2,row3,row4,row5] startRow targetRow = findDiagonallyToRightUpwardsShortCannonShotInRow player row1 row2 row3 row4 row5 0 startRow 4 targetRow
findDiagonallyToRightUpwardsShortCannonShots player (row1:row2:row3:row4:row5:board) startRow targetRow = findDiagonallyToRightUpwardsShortCannonShotInRow player row1 row2 row3 row4 row5 0 startRow 4 targetRow ++ findDiagonallyToRightUpwardsShortCannonShots player (row2:row3:row4:row5:board) (startRow-1) (targetRow-1)

findDiagonallyToRightUpwardsShortCannonShotInRow :: Char -> String -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToRightUpwardsShortCannonShotInRow _ [_,_,_,_] _ _ _ _ _ _ _ _ = ""
findDiagonallyToRightUpwardsShortCannonShotInRow _ _ [_,_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToRightUpwardsShortCannonShotInRow _ _ _ [_,_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToRightUpwardsShortCannonShotInRow _ _ _ _ [_,_,_,_] _ _ _ _ _ = ""
findDiagonallyToRightUpwardsShortCannonShotInRow _ _ _ _ _ [_,_,_,_] _ _ _ _ = ""
findDiagonallyToRightUpwardsShortCannonShotInRow player [a1,a2,a3,a4,a5] [b1,b2,b3,b4,b5] [c1,c2,c3,c4,c5] [d1,d2,d3,d4,d5] [e1,e2,e3,e4,e5] startColumn startRow targetColumn targetRow
  | e1 == player && d2 == player && c3 == player && isFieldEmpty b4 && a5 == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findDiagonallyToRightUpwardsShortCannonShotInRow player (a1:a2:a3:a4:a5:row1) (b1:b2:b3:b4:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) (e1:e2:e3:e4:e5:row5) startColumn startRow targetColumn targetRow
  | e1 == player && d2 == player && c3 == player && isFieldEmpty b4 && a5 == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToRightUpwardsShortCannonShotInRow player (a2:a3:a4:a5:row1) (b2:b3:b4:row2) (c2:c3:row3) (d2:d3:d4:row4) (e2:e3:e4:e5:row5) (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findDiagonallyToRightUpwardsShortCannonShotInRow player (a2:a3:a4:a5:row1) (b2:b3:b4:row2) (c2:c3:row3) (d2:d3:d4:row4) (e2:e3:e4:e5:row5) (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToLeftDownwardsShortCannonShots :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftDownwardsShortCannonShots player [row1,row2,row3,row4,row5] startRow targetRow = findDiagonallyToLeftDownwardsShortCannonShotInRow player row1 row2 row3 row4 row5 4 startRow 0 targetRow
findDiagonallyToLeftDownwardsShortCannonShots player (row1:row2:row3:row4:row5:board) startRow targetRow = findDiagonallyToLeftDownwardsShortCannonShotInRow player row1 row2 row3 row4 row5 4 startRow 0 targetRow ++ findDiagonallyToLeftDownwardsShortCannonShots player (row2:row3:row4:row5:board) (startRow-1) (targetRow-1)

findDiagonallyToLeftDownwardsShortCannonShotInRow :: Char -> String -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToLeftDownwardsShortCannonShotInRow _ [_,_,_,_] _ _ _ _ _ _ _ _ = ""
findDiagonallyToLeftDownwardsShortCannonShotInRow _ _ [_,_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToLeftDownwardsShortCannonShotInRow _ _ _ [_,_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToLeftDownwardsShortCannonShotInRow _ _ _ _ [_,_,_,_] _ _ _ _ _ = ""
findDiagonallyToLeftDownwardsShortCannonShotInRow _ _ _ _ _ [_,_,_,_] _ _ _ _ = ""
findDiagonallyToLeftDownwardsShortCannonShotInRow player [a1,a2,a3,a4,a5] [b1,b2,b3,b4,b5] [c1,c2,c3,c4,c5] [d1,d2,d3,d4,d5] [e1,e2,e3,e4,e5] startColumn startRow targetColumn targetRow
  | a5 == player && b4 == player && c3 == player && isFieldEmpty d2 && e1 == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findDiagonallyToLeftDownwardsShortCannonShotInRow player (a1:a2:a3:a4:a5:row1) (b1:b2:b3:b4:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) (e1:e2:e3:e4:e5:row5) startColumn startRow targetColumn targetRow
  | a5 == player && b4 == player && c3 == player && isFieldEmpty d2 && e1 == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToLeftDownwardsShortCannonShotInRow player (a2:a3:a4:a5:row1) (b2:b3:b4:row2) (c2:c3:row3) (d2:d3:d4:row4) (e2:e3:e4:e5:row5) (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findDiagonallyToLeftDownwardsShortCannonShotInRow player (a2:a3:a4:a5:row1) (b2:b3:b4:row2) (c2:c3:row3) (d2:d3:d4:row4) (e2:e3:e4:e5:row5) (startColumn+1) startRow (targetColumn+1) targetRow

findDiagonallyToRightDownwardsShortCannonShots :: Char -> [String] -> Int -> Int -> String
findDiagonallyToRightDownwardsShortCannonShots player [row1,row2,row3,row4,row5] startRow targetRow = findDiagonallyToRightDownwardsShortCannonShotInRow player row1 row2 row3 row4 row5 0 startRow 4 targetRow
findDiagonallyToRightDownwardsShortCannonShots player (row1:row2:row3:row4:row5:board) startRow targetRow = findDiagonallyToRightDownwardsShortCannonShotInRow player row1 row2 row3 row4 row5 0 startRow 4 targetRow ++ findDiagonallyToRightDownwardsShortCannonShots player (row2:row3:row4:row5:board) (startRow-1) (targetRow-1)

findDiagonallyToRightDownwardsShortCannonShotInRow :: Char -> String -> String -> String -> String -> String -> Int -> Int -> Int -> Int -> String
findDiagonallyToRightDownwardsShortCannonShotInRow _ [_,_,_,_] _ _ _ _ _ _ _ _ = ""
findDiagonallyToRightDownwardsShortCannonShotInRow _ _ [_,_,_,_] _ _ _ _ _ _ _ = ""
findDiagonallyToRightDownwardsShortCannonShotInRow _ _ _ [_,_,_,_] _ _ _ _ _ _ = ""
findDiagonallyToRightDownwardsShortCannonShotInRow _ _ _ _ [_,_,_,_] _ _ _ _ _ = ""
findDiagonallyToRightDownwardsShortCannonShotInRow _ _ _ _ _ [_,_,_,_] _ _ _ _ = ""
findDiagonallyToRightDownwardsShortCannonShotInRow player [a1,a2,a3,a4,a5] [b1,b2,b3,b4,b5] [c1,c2,c3,c4,c5] [d1,d2,d3,d4,d5] [e1,e2,e3,e4,e5] startColumn startRow targetColumn targetRow
  | a1 == player && b2 == player && c3 == player && isFieldEmpty d4 && e5 == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow)
  | otherwise = ""
findDiagonallyToRightDownwardsShortCannonShotInRow player (a1:a2:a3:a4:a5:row1) (b1:b2:b3:b4:row2) (c1:c2:c3:row3) (d1:d2:d3:d4:row4) (e1:e2:e3:e4:e5:row5) startColumn startRow targetColumn targetRow
  | a1 == player && b2 == player && c3 == player && isFieldEmpty d4 && e5 == getOpponent player = convertMove(startColumn, startRow, targetColumn, targetRow) ++ findDiagonallyToRightDownwardsShortCannonShotInRow player (a2:a3:a4:a5:row1) (b2:b3:b4:row2) (c2:c3:row3) (d2:d3:d4:row4) (e2:e3:e4:e5:row5) (startColumn+1) startRow (targetColumn+1) targetRow
  | otherwise = "" ++ findDiagonallyToRightDownwardsShortCannonShotInRow player (a2:a3:a4:a5:row1) (b2:b3:b4:row2) (c2:c3:row3) (d2:d3:d4:row4) (e2:e3:e4:e5:row5) (startColumn+1) startRow (targetColumn+1) targetRow

-----------------------------------------------

getBoard :: String
--getBoard = "111111111w/9W w"
--getBoard = "ww1w1w1w1w/4W5/1111w1111w/9B w"
--getBoard = "1Wb7/ww1w1w1w1w/w1w7/b1bbw111ww/2w7/4w6/w2b6/bb1bw5/w9/1B5w2 b"
--getBoard = "1W1w5w/1w7b/5b1b2/6b2w/5b1b1w/9w/4w5/4wb4/4w4b/3B4bw b"
getBoard = "1W1w11111w/" --9
        ++ "1w1111111b/" --8
        ++ "11111b1b11/" --7
        ++ "111111b11w/" --6
        ++ "1111wb1b1w/" --5
        ++ "111111111w/" --4
        ++ "11bww1111w/" --3
        ++ "1b11wb1111/" --2
        ++ "b111w1111b/" --1
        ++ "111B1111bw b"--0
        --  abcdefghij

listMoves :: String -> String
listMoves y =
    let player = last getBoard
        cBoard = removeSpace(splitOn "/" (convertBoardString (removeLastElement(removeLastElement getBoard)))) in
    "[" ++ removeLastElement(findMoves player cBoard) ++ "]"

findMoves :: Char -> [String] -> String
findMoves player board
    | isTownSet player board = findCannonShots player board --findForwardMoves player board ++ findCaptures player board ++ findRetreats player board ++ findCannonMoves player board
    | otherwise              = setTown player board

findCannonShots ::  Char -> [String] -> String
findCannonShots player board = findDiagonallyToLeftUpwardsShortCannonShots player board 5 9 ++ findDiagonallyToRightUpwardsShortCannonShots player board 5 9 ++ findDiagonallyToLeftDownwardsShortCannonShots player board 9 5 ++ findDiagonallyToRightDownwardsShortCannonShots player board 9 5
--findStraightUpwardsShortCannonShots player board 5 9 ++ findStraightDownwardsShortCannonShots player board 9 5 ++ findDiagonallyToLeftUpwardsShortCannonShots player board 5 9 ++ findDiagonallyToRightUpwardsShortCannonShots player board 5 9 ++ findDiagonallyToLeftDownwardsShortCannonShots player board 9 5 ++ findDiagonallyToRightDownwardsShortCannonShots player board 9 5

f
