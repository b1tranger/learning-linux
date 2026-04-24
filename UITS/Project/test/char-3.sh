#!/bin/bash

# Map Settings
WIDTH=40
HEIGHT=15
SPAWN_X=5; SPAWN_Y=5
EXIT_X=35; EXIT_Y=10
x=$SPAWN_X; y=$SPAWN_Y
frame=0

# Clean cleanup
close_game() {
    tput cnorm; clear
    echo "Game Closed."; exit 0
}
trap close_game SIGINT SIGTERM

# Draw static map once
clear
tput civis
for ((i=0; i<=$WIDTH; i++)); do tput cup 0 $i; echo "-"; tput cup $HEIGHT $i; echo "-"; done
for ((i=0; i<=$HEIGHT; i++)); do tput cup $i 0; echo "|"; tput cup $i $WIDTH; echo "|"; done

draw_char() {
    # Set color for character (optional but looks better)
    tput setaf 2
    tput cup $y $x; echo " o "
    tput cup $((y+1)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/|\\" || echo "/|\\"
    tput cup $((y+2)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/ \\" || echo " | "
    tput sgr0
}

while true; do
    # 1. Check Win Condition
    if [[ $x -ge $((EXIT_X-1)) && $x -le $((EXIT_X+3)) && $y -ge $((EXIT_Y-1)) && $y -le $((EXIT_Y+1)) ]]; then
        tput cnorm; clear; echo "YOU WIN!"; exit 0
    fi

    # 2. Draw everything
    tput cup $SPAWN_Y $SPAWN_X; echo "(S)"
    tput cup $EXIT_Y $EXIT_X; echo "[EXIT]"
    draw_char

    # 3. Capture input (Wait for key)
    read -rsn1 input
    # Handle escape sequences for arrows
    if [[ $input == $'\e' ]]; then
        read -rsn2 -t 0.01 input 
    fi

    # 4. Clear ONLY the character's 3x3 footprint before moving
    for i in {0..2}; do tput cup $((y+i)) $x; echo "   "; done

    # 5. Move Logic
    case $input in
        "[A"|w) [[ $y -gt 1 ]] && ((y--)) ;;
        "[B"|s) [[ $y -lt $((HEIGHT-3)) ]] && ((y++)) ;;
        "[C"|d) [[ $x -lt $((WIDTH-3)) ]] && ((x++)) ;;
        "[D"|a) [[ $x -gt 1 ]] && ((x--)) ;;
        q) close_game ;;
    esac

    ((frame++))
done
