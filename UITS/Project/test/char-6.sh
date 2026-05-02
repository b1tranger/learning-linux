#!/bin/bash

# Map Settings
WIDTH=45
HEIGHT=15
SPAWN_X=5; SPAWN_Y=5
EXIT_X=38; EXIT_Y=12
x=$SPAWN_X; y=$SPAWN_Y
frame=0
has_realization=false  # Story flag

# Clean cleanup
close_game() {
    tput cnorm; clear
    echo "The tavern fades into memory. Game Closed."; exit 0
}
trap close_game SIGINT SIGTERM

# Function to show story dialogues using whiptail
show_dialogue() {
    whiptail --title "Tavern of Life" --msgbox "$1" 10 50
}

# Loading Screen Section
clear
tput civis # Hide cursor
tput setaf 3 # Yellow text for retro feel
tput cup $((HEIGHT / 2)) $((WIDTH / 4))
echo "GAМE LOADING..."
tput cup $((HEIGHT / 2 + 1)) $((WIDTH / 4))
echo "Entering the Tavern of Life..."
tput sgr0
sleep 3 # Display for 3 seconds before starting

# Draw static map once using box-drawing characters
draw_map() {
    clear
    tput civis
    # Top and Bottom borders
    for ((i=1; i<$WIDTH; i++)); do 
        tput cup 0 $i; echo "═"
        tput cup $HEIGHT $i; echo "═"
    done
    # Left and Right borders
    for ((i=1; i<$HEIGHT; i++)); do 
        tput cup $i 0; echo "║"
        tput cup $i $WIDTH; echo "║"
    done
    # Corners
    tput cup 0 0; echo "╔"; tput cup 0 $WIDTH; echo "╗"
    tput cup $HEIGHT 0; echo "╚"; tput cup $HEIGHT $WIDTH; echo "╝"
    
    # Legend/UI area
    tput cup $((HEIGHT + 1)) 2; echo "Use Arrows/WASD to move | 'q' to Quit"
}

draw_char() {
    tput setaf 2 # Character color
    tput cup $y $x; echo " o "
    tput cup $((y+1)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/|\\" || echo "/|\\"
    tput cup $((y+2)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/ \\" || echo " | "
    tput sgr0
}

draw_map

while true; do
    # 1. Logic: Check for Interaction at Entry Gate
    if [[ $x -le 2 && $y -eq $SPAWN_Y ]]; then
        if whiptail --title "The Old Man" --yesno "Young man, if you get out from where you got in being sad, you will remain sad. Exit anyway?" 10 60; then
            tput cnorm; clear; echo "You left the tavern, still sad. The cycle continues."; exit 0
        else
            x=3
            draw_map
        fi
    fi

    # 2. Logic: Win Condition at Final Exit
    if [[ $x -ge $((EXIT_X-1)) && $x -le $((EXIT_X+3)) && $y -ge $((EXIT_Y-1)) && $y -le $((EXIT_Y+1)) ]]; then
        if [ "$has_realization" = true ]; then
            tput cnorm; clear; echo "You step out into the light, finally at peace. YOU WIN!"; exit 0
        else
            show_dialogue "The door is locked. You haven't found the 'key' to your meaning of life yet."
            x=$((EXIT_X - 5)) 
            draw_map
        fi
    fi

    # 3. Draw static elements, character, and Hint logic
    tput cup $SPAWN_Y 1; echo "🚪(IN)"
    tput cup $EXIT_Y $EXIT_X; echo "🚪[EXIT]"
    draw_char

    # Delayed Hint Logic
    if [[ $frame -ge 100 ]]; then
        tput cup $((HEIGHT + 2)) 2
        tput setaf 6 # Cyan color for hints
        echo "A wise one becomes wise when he wants to. 'k' "
        tput sgr0
    fi

    # 4. Capture input with a timeout for animations (0.1s)
    read -rsn1 -t 0.1 input
    if [[ $input == $'\e' ]]; then
        read -rsn2 -t 0.01 input 
    fi

    # 5. Clear footprints
    for i in {0..2}; do tput cup $((y+i)) $x; echo "   "; done

    # 6. Move Logic
    case $input in
        "[A"|w) [[ $y -gt 1 ]] && ((y--)) ;;
        "[B"|s) [[ $y -lt $((HEIGHT-3)) ]] && ((y++)) ;;
        "[C"|d) [[ $x -lt $((WIDTH-3)) ]] && ((x++)) ;;
        "[D"|a) [[ $x -gt 1 ]] && ((x--)) ;;
        q) close_game ;;
        k) has_realization=true; show_dialogue "You found a realization! (Key Obtained)" ;; 
    esac

    # 7. FIX: Flush the input buffer to prevent artifacts from held keys
    # This loop clears out any extra arrow key codes (like ^[[A) that leaked through
    while read -rsn1 -t 0 input_garbage; do :; done

    ((frame++))
done