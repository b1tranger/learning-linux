#!/bin/bash

# A simple game where you must press 'k' to survive
lives=3
score=0

echo "Game Started! Press 'k' to score. Press 'q' to quit."

# This loop runs the game
while [ $lives -gt 0 ]; do
    read -n 1 -p "Action: " input  # Read 1 character without Enter
    echo ""

    if [[ "$input" == "k" ]]; then
        ((score++))
        echo "HIT! Score: $score"
    elif [[ "$input" == "q" ]]; then
        break
    else
        ((lives--))
        echo "MISS! Lives left: $lives"
    fi
done

echo "GAME OVER. Final Score: $score"
