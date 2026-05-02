#!/bin/bash

# Map Settings
WIDTH=45
HEIGHT=15
SPAWN_X=5; SPAWN_Y=5
EXIT_X=38; EXIT_Y=12
x=$SPAWN_X; y=$SPAWN_Y
frame=0  # This will now only track "steps taken"
has_realization=false  

# --- Terminal Settings ---
stty -echo  # Prevents artifacts like ^[[A from appearing on screen [3]
tput civis  # Hides the cursor for a cleaner look

close_game() {
    stty echo    
    tput cnorm   
    clear
    echo "The tavern fades into memory. Game Closed."; exit 0
}
trap close_game SIGINT SIGTERM

show_dialogue() {
    whiptail --title "Tavern of Life" --msgbox "$1" 10 50
    draw_map 
    draw_char
}

draw_map() {
    clear
    tput civis
    # Draw Borders using Unicode characters for retro feel [4, 5]
    for ((i=1; i<$WIDTH; i++)); do tput cup 0 $i; echo "═"; tput cup $HEIGHT $i; echo "═"; done
    for ((i=1; i<$HEIGHT; i++)); do tput cup $i 0; echo "║"; tput cup $i $WIDTH; echo "║"; done
    tput cup 0 0; echo "╔"; tput cup 0 $WIDTH; echo "╗"; tput cup $HEIGHT 0; echo "╚"; tput cup $HEIGHT $WIDTH; echo "╝"
    tput cup $((HEIGHT + 1)) 2; echo "Use Arrows/WASD to move | 'q' to Quit"
}

# --- UPDATED: Character Drawing Logic ---
draw_char() {
    tput setaf 2
    tput cup $y $x; echo " o "
    tput cup $((y+1)) $x; echo "/|\\"
    # Legs toggle between "/ \" and " | " based on frame count [2]
    tput cup $((y+2)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/ \\" || echo " | "
    tput sgr0
}

# Initial Screen Setup
draw_map
draw_char

while true; do
    # 1. Capture Input with Responsive Timeout [6]
    read -rsn1 -t 0.05 input
    if [[ $input == $'\e' ]]; then
        read -rsn2 -t 0.001 input 
    fi

    # 2. Logic: Process Movement and Animation
    if [[ -n $input ]]; then
        # Flush the buffer to handle input flooding and artifacts [3, 7]
        while read -rsn1 -t 0 flush; do :; done

        # Clear footprints before moving [1, 8]
        for i in {0..2}; do tput cup $((y+i)) $x; echo "   "; done

        case $input in
            "[A"|w) [[ $y -gt 1 ]] && ((y--)) && ((frame++)) ;;
            "[B"|s) [[ $y -lt $((HEIGHT-3)) ]] && ((y++)) && ((frame++)) ;;
            "[C"|d) [[ $x -lt $((WIDTH-3)) ]] && ((x++)) && ((frame++)) ;;
            "[D"|a) [[ $x -gt 1 ]] && ((x--)) && ((frame++)) ;;
            q) close_game ;;
            k) has_realization=true; show_dialogue "Key Obtained!" ;; 
        esac
    fi

    # 3. Logic: Triggers [4, 9]
    if [[ $x -le 2 && $y -eq $SPAWN_Y ]]; then
        if whiptail --title "The Old Man" --yesno "Exit anyway?" 10 60; then close_game; else x=3; draw_map; fi
    fi

    if [[ $x -ge $((EXIT_X-1)) && $x -le $((EXIT_X+3)) && $y -ge $((EXIT_Y-1)) && $y -le $((EXIT_Y+1)) ]]; then
        if [ "$has_realization" = true ]; then tput cnorm; clear; echo "YOU WIN!"; exit 0; 
        else show_dialogue "The door is locked."; x=$((EXIT_X - 5)); draw_map; fi
    fi

    # 4. Final Draw (Ensures correct sprite placement) [7]
    tput cup $SPAWN_Y 1; echo "🚪(IN)"
    tput cup $EXIT_Y $EXIT_X; echo "🚪[EXIT]"
    draw_char

    # Hint logic (uses a separate time counter if needed, or frame) [10]
    if [[ $frame -ge 50 ]]; then
        tput cup $((HEIGHT + 2)) 2; tput setaf 6; echo "A wise one becomes wise when he wants to. 'k'"; tput sgr0
    fi
done