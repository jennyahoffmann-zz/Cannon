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
--getBoard = "1Wb7/ww1w1w1w1w/w1w7/b1bbw111ww/2w7/4w6/w2b6/bb1bw5/w9/1B5w2 b"
getBoard = "1W6bw/1w8///9w/9b//4bw4//3B4bw b"

listMoves :: String -> String
listMoves y =
    let player = last getBoard
        cBoard = removeSpace(splitOn "/" (convertBoardString (removeLastElement(removeLastElement getBoard)))) in
    "[" ++ removeLastElement(findMoves player cBoard) ++ "]"

findMoves :: Char -> [String] -> String
findMoves player board
    | isTownSet player board = findRetreats player board --findForwardMoves player board ++ findCaptures player board ++ findRetreats player board
    | otherwise              = setTown player board

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

findDiagonallyToLeftRretreats :: Char -> [String] -> Int -> Int -> String
findDiagonallyToLeftRretreats 'w' [row1, row2, row3, row4] startRow targetRow = findDiagonallyToLeftRetreatInRow 'w' row4 row3 row2 row1 2 startRow 0 targetRow  ++ findDiagonallyToLeftRetreatInRow 'w' "1111111111" row4 row3 row2 2 (startRow-1) 0 (targetRow-1)
findDiagonallyToLeftRretreats 'w' (row1:row2:row3:row4:restBoard) startRow targetRow = findDiagonallyToLeftRetreatInRow 'w' row4 row3 row2 row1 2 startRow 0 targetRow ++ findDiagonallyToLeftRretreats 'w' (row2:row3:row4:restBoard) (startRow-1) (targetRow-1)
findDiagonallyToLeftRretreats 'b' [row1, row2, row3, row4] startRow targetRow = findDiagonallyToLeftRetreatInRow 'b' row1 row2 row3 row4 2 startRow 0 targetRow ++ findDiagonallyToLeftRetreatInRow 'b' "1111111111" row1 row2 row3 2 (startRow+1) 0 (targetRow+1)
findDiagonallyToLeftRretreats 'b' board startRow targetRow = let (row1, row2, row3, row4) = getLatFourRows board in findDiagonallyToLeftRetreatInRow 'b' row1 row2 row3 row4 2 startRow 0 targetRow ++ findDiagonallyToLeftRretreats 'b' (init board) (startRow+1) (targetRow+1)

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
