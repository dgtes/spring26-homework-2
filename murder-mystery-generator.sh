#!/bin/bash

killers=("Mr. Dosh" "The butler" "Profesor Plum" "The Gardener" "Lady Sterling" "Chef Remi" "Dosh JR.")
weapons=("an axe" "a candlestick" "a gun" "a dagger" "poison" "a shovel" "a pipe" "a golden trophy" "a silver spoon")
places=("in the kitchen" "in the bathroom" "on the balcony" "in the garden" "in the library" "in the wine cellar" "in the basement")
reasons=("they cheated" "they were rude" "of a disputed inheritence" "they knew too much" "of blackmail" "of a mistake")

killer=${killers[$RANDOM % ${#killers[@]}]}
weapon=${weapons[$RANDOM % ${#weapons[@]}]}
place=${places[$RANDOM % ${#places[@]}]}
reason=${reasons[$RANDOM % ${#reasons[@]}]}

echo "$killer with $weapon $place because $reason."
