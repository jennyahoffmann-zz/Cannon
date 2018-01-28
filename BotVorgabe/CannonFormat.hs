module Format where

import System.IO
import Util
import Data.List
import Control.Monad
import Test.HUnit

import CannonBot

isRow r = r `elem` ['0'..'9']
isCol c = c `elem` ['a'..'j']

formatMove (a:b:c:d:e:[])
    | (isCol a) && (isRow b) && c == '-' && (isCol d) && (isRow e) = True
formatMove _ = False

formatList s
    | (head s == '[') && (last s == ']') = foldr (\ sm y -> y && (formatMove sm)) True (Util.splitOn "," (init (tail s)) )
formatList _ = False

assertFormat :: String -> (String -> Bool) -> Assertion
assertFormat actual check =
    unless (check actual) (assertFailure msg)
    where msg = "Wrong format! Looks like: \"" ++ actual ++ "\""

--------------------------------------------------------------------------

format = TestList [  (TestLabel "MOVE FORMAT WRONG!" (TestCase (assertFormat (CannonBot.getMove "4W5/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/7B2 w") formatMove))),
    (TestLabel "LIST FORMAT WRONG!" (TestCase (assertFormat (CannonBot.listMoves "4W5/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/7B2 w") formatList))) ]

main :: IO (Counts, Int)
main =  runTestText (putTextToHandle stdout False) format
