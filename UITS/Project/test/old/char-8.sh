#!/bin/bash

# Map Settings
WIDTH=45
HEIGHT=15
SPAWN_X=5; SPAWN_Y=5
EXIT_X=38; EXIT_Y=12
x=$SPAWN_X; y=$SPAWN_Y
frame=0
has_realization=false  

# --- Terminal Settings ---
stty -echo  # Silences input "leaks" [4]
tput civis  # Hides the cursor [5]

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
    draw_char # Ensure character is redrawn after whiptail closes
}

draw_map() {
    clear
    tput civis
    for ((i=1; i<$WIDTH; i++)); do tput cup 0 $i; echo "═"; tput cup $HEIGHT $i; echo "═"; done
    for ((i=1; i<$HEIGHT; i++)); do tput cup $i 0; echo "║"; tput cup $i $WIDTH; echo "║"; done
    tput cup 0 0; echo "╔"; tput cup 0 $WIDTH; echo "╗"; tput cup $HEIGHT 0; echo "╚"; tput cup $HEIGHT $WIDTH; echo "╝"
    tput cup $((HEIGHT + 1)) 2; echo "Use Arrows/WASD to move | 'q' to Quit"
}

draw_char() {
    tput setaf 2
    tput cup $y $x; echo " o "
    tput cup $((y+1)) $x; echo "/|\\"
    tput cup $((y+2)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/ \\" || echo " | "
    tput sgr0
}

# Initial Draw
draw_map
draw_char

while true; do
    # 1. Capture Input (The Frame Pause)
    # The character drawn at the end of the PREVIOUS loop stays visible during this 0.1s [2, 6]
    read -rsn1 -t 0.1 input
    if [[ $input == $'\e' ]]; then
        read -rsn2 -t 0.001 input 
    fi

    # 2. Logic: Flush Buffer IMMEDIATELY after reading
    # This prevents extra "held" keys from stacking up and causing lag [4]
    while read -rsn1 -t 0 flush; do :; done

    # 3. Clear footprints at the OLD position
    for i in {0..2}; do tput cup $((y+i)) $x; echo "   "; done

    # 4. Move Logic (Update coordinates)
    case $input in
        "[A"|w) [[ $y -gt 1 ]] && ((y--)) ;;
        "[B"|s) [[ $y -lt $((HEIGHT-3)) ]] && ((y++)) ;;
        "[C"|d) [[ $x -lt $((WIDTH-3)) ]] && ((x++)) ;;
        "[D"|a) [[ $x -gt 1 ]] && ((x--)) ;;
        q) close_game ;;
        k) has_realization=true; show_dialogue "Key Obtained!" ;; 
    esac

    # 5. Check Triggers (Checks new coordinates)
    if [[ $x -le 2 && $y -eq $SPAWN_Y ]]; then
        if whiptail --title "The Old Man" --yesno "Exit anyway?" 10 60; then close_game; else x=3; draw_map; fi
    fi

    if [[ $x -ge $((EXIT_X-1)) && $x -le $((EXIT_X+3)) && $y -ge $((EXIT_Y-1)) && $y -le $((EXIT_Y+1)) ]]; then
        if [ "$has_realization" = true ]; then tput cnorm; clear; echo "YOU WIN!"; exit 0; 
        else show_dialogue "The door is locked."; x=$((EXIT_X - 5)); draw_map; fi
    fi

    # 6. Final Draw (Character is now at NEW position)
    tput cup $SPAWN_Y 1; echo "🚪(IN)"
    tput cup $EXIT_Y $EXIT_X; echo "🚪[EXIT]"
    draw_char

    if [[ $frame -ge 100 ]]; then
        tput cup $((HEIGHT + 2)) 2; tput setaf 6; echo "A wise one becomes wise when he wants to. 'k'"; tput sgr0
    fi

    ((frame++))
done