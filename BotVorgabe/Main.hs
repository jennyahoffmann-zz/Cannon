{-# LANGUAGE DoAndIfThenElse #-}
module Main 
where

import CannonBot
import System.Environment

main :: IO ()
main = do 
	args <- getArgs
	let oneString = foldr (\x y -> if y == "" then x else x ++ " " ++ y) "" args in
		putStrLn ( getMove oneString )