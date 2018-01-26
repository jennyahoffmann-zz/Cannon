module Util where

--- utils (NICHT AENDERN!)
isPrefixOf :: Eq a => [a] -> [a] -> Bool
isPrefixOf [] = \_ -> True 
isPrefixOf pre = (==pre) . (take (length pre))

stripPrefix :: Eq a => [a] -> [a] -> [a]
stripPrefix pre txt
    | isPrefixOf pre txt = drop (length pre) txt
    | otherwise = txt

splitOn :: Eq a => [a] -> [a] -> [[a]]
splitOn c = (\(y,z) -> [y]++z) . foldr (\x (y,z) -> if isPrefixOf c (x:y) then ([],[stripPrefix c (x:y)]++z) else (x:y,z)) ([],[])