# Cannon Bot in Haskell

## Cannon
nestorgames

A strategy board game for 2 players by David E. Whitcher

#### Compile and Run
```
$ ghc -o cannonbot CannonBot.hs
$ ./cannonbot "4W5/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/7B2 w"
```

#### Dev
```
$ ghci CannonBot.hs
*CannonBot> getMove "4W5/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/7B2 w"
*CannonBot> listMoves "4W5/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/7B2 w"
```

Reload new code
```
*CannonBot> :r
```

#### Testing
```
$ ghci CannonFormat.hs
*Format> main
```
