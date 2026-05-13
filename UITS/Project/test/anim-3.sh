#!/bin/bash

# Map Settings
WIDTH=60
HEIGHT=20
SPAWN_X=5; SPAWN_Y=5
EXIT_X=50; EXIT_Y=15
x=$SPAWN_X; y=$SPAWN_Y
frame=0  # Tracks steps taken for animation
has_realization=false  

# --- Humanoid Sprite Definitions ---
H_HEAD=" (o-o) "
H_BODY="/[###]\\"
H_LEGS_A="_|   |_" # Wide stance
H_LEGS_B="  | |  "   # Narrow stance

# --- Terminal Settings ---
stty -echo  # Silences input "leaks" and artifacts [5, 6]
tput civis  # Hides the cursor [7]

close_game() {
    stty echo    # Restore terminal on exit [5, 6]
    tput cnorm   
    clear
    echo "The tavern fades into memory. Game Closed."; exit 0
}
trap close_game SIGINT SIGTERM

show_dialogue() {
    whiptail --title "Tavern of Life" --msgbox "$1" 10 50 [8, 9]
    draw_map 
    draw_humanoid
}

draw_map() {
    clear
    tput civis
    # Draw Borders using Unicode characters for retro feel [10, 11]
    for ((i=1; i<$WIDTH; i++)); do tput cup 0 $i; echo "═"; tput cup $HEIGHT $i; echo "═"; done
    for ((i=1; i<$HEIGHT; i++)); do tput cup $i 0; echo "║"; tput cup $i $WIDTH; echo "║"; done
    tput cup 0 0; echo "╔"; tput cup 0 $WIDTH; echo "╗"; tput cup $HEIGHT 0; echo "╚"; tput cup $HEIGHT $WIDTH; echo "╝"
    tput cup $((HEIGHT + 1)) 2; echo "Use Arrows/WASD to move | 'q' to Quit"
}

draw_humanoid() {
    tput setaf 2 # Green character [12, 13]
    tput cup $y $x; echo "$H_HEAD"
    tput cup $((y+1)) $x; echo "$H_BODY"
    # Legs toggle based on frame (steps taken) [14, 15]
    tput cup $((y+2)) $x
    if [[ $((frame % 2)) -eq 0 ]]; then
        echo "$H_LEGS_A"
    else
        echo "$H_LEGS_B"
    fi
    tput sgr0
}

# --- NEW: Expanded Clear Logic for 7-wide Sprite ---
clear_humanoid() {
    for i in {0..2}; do
        tput cup $((y+i)) $x; echo "       " # 7 spaces to clear the width
    done
}

# Loading Screen [16, 17]
clear
tput setaf 3
tput cup $((HEIGHT / 2)) $((WIDTH / 4))
echo "GAМE LOADING..."
sleep 3

# Initial Setup
draw_map
draw_humanoid

while true; do
    # 1. Capture Input (The Frame Pause) [1, 2]
    read -rsn1 -t 0.05 input
    if [[ $input == $'\e' ]]; then
        read -rsn2 -t 0.001 input 
    fi

    # 2. Process Input and Flush Buffer [1, 2]
    if [[ -n $input ]]; then
        while read -rsn1 -t 0 flush; do :; done [18]

        # Clear OLD position
        clear_humanoid

        # Move Logic (Adjusted boundaries for 7-wide sprite)
        case $input in
            "[A"|w) [[ $y -gt 1 ]] && ((y--)) && ((frame++)) ;;
            "[B"|s) [[ $y -lt $((HEIGHT-3)) ]] && ((y++)) && ((frame++)) ;;
            "[C"|d) [[ $x -lt $((WIDTH-7)) ]] && ((x++)) && ((frame++)) ;;
            "[D"|a) [[ $x -gt 1 ]] && ((x--)) && ((frame++)) ;;
            q) close_game ;;
            k) has_realization=true; show_dialogue "Key Obtained!" ;; 
        esac
    fi

    # 3. Triggers [9, 19]
    if [[ $x -le 8 && $y -eq $SPAWN_Y ]]; then
        if whiptail --title "The Old Man" --yesno "Exit anyway?" 10 60; then close_game; else x=9; draw_map; fi
    fi

    if [[ $x -ge $((EXIT_X-1)) && $x -le $((EXIT_X+7)) && $y -ge $((EXIT_Y-1)) && $y -le $((EXIT_Y+1)) ]]; then
        if [ "$has_realization" = true ]; then tput cnorm; clear; echo "YOU WIN!"; exit 0; 
        else show_dialogue "The door is locked."; x=$((EXIT_X - 10)); draw_map; fi
    fi

    # 4. Final Draw (Refreshes positions and animations)
    tput cup $SPAWN_Y 1; echo "🚪(IN)"
    tput cup $EXIT_Y $EXIT_X; echo "🚪[EXIT]"
    draw_humanoid

    # Delayed Hint Logic [16, 17]
    if [[ $frame -ge 50 ]]; then
        tput cup $((HEIGHT + 2)) 2; tput setaf 6; echo "A wise one becomes wise when he wants to. 'k'"; tput sgr0
    fi
done