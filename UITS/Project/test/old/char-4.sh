# using whiptail

#!/bin/bash

# Map Settings
WIDTH=45
HEIGHT=15
SPAWN_X=5; SPAWN_Y=5
EXIT_X=38; EXIT_Y=12
x=$SPAWN_X; y=$SPAWN_Y
frame=0
has_realization=false  # Story flag: has the player found the 'key'? [2]

# Clean cleanup
close_game() {
    tput cnorm; clear
    echo "The tavern fades into memory. Game Closed."; exit 0
}
trap close_game SIGINT SIGTERM

# Function to show story dialogues using whiptail [1]
show_dialogue() {
    whiptail --title "Tavern of Life" --msgbox "$1" 10 50
}

# Draw static map once using box-drawing characters for retro feel [4]
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
    
    # Legend/UI area [4]
    tput cup $((HEIGHT + 1)) 2; echo "Use Arrows/WASD to move | 'q' to Quit"
}

draw_char() {
    tput setaf 2 # Character color [2, 3]
    tput cup $y $x; echo " o "
    tput cup $((y+1)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/|\\" || echo "/|\\"
    tput cup $((y+2)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/ \\" || echo " | "
    tput sgr0
}

draw_map

while true; do
    # 1. Logic: Check for Interaction at Entry Gate [2]
    if [[ $x -le 2 && $y -eq $SPAWN_Y ]]; then
        if whiptail --title "The Old Man" --yesno "Young man, if you get out from where you got in being sad, you will remain sad. Exit anyway?" 10 60; then
            tput cnorm; clear; echo "You left the tavern, still sad. The cycle continues."; exit 0
        else
            # Player chooses to stay; move them slightly back into the room
            x=3
            draw_map
        fi
    fi

    # 2. Logic: Win Condition at Final Exit [2]
    if [[ $x -ge $((EXIT_X-1)) && $x -le $((EXIT_X+3)) && $y -ge $((EXIT_Y-1)) && $y -le $((EXIT_Y+1)) ]]; then
        if [ "$has_realization" = true ]; then
            tput cnorm; clear; echo "You step out into the light, finally at peace. YOU WIN!"; exit 0
        else
            show_dialogue "The door is locked. You haven't found the 'key' to your meaning of life yet."
            x=$((EXIT_X - 5)) # Push back from the exit
            draw_map
        fi
    fi

    # 3. Draw static elements and character
    tput cup $SPAWN_Y 1; echo "🚪(IN)"
    tput cup $EXIT_Y $EXIT_X; echo "🚪[EXIT]"
    draw_char

    # 4. Capture input with a timeout for animations (0.1s) [3]
    read -rsn1 -t 0.1 input
    if [[ $input == $'\e' ]]; then
        read -rsn2 -t 0.01 input 
    fi

    # 5. Clear footprints [2]
    for i in {0..2}; do tput cup $((y+i)) $x; echo "   "; done

    # 6. Move Logic [2]
    case $input in
        "[A"|w) [[ $y -gt 1 ]] && ((y--)) ;;
        "[B"|s) [[ $y -lt $((HEIGHT-3)) ]] && ((y++)) ;;
        "[C"|d) [[ $x -lt $((WIDTH-3)) ]] && ((x++)) ;;
        "[D"|a) [[ $x -gt 1 ]] && ((x--)) ;;
        q) close_game ;;
        k) has_realization=true; show_dialogue "You found a realization! (Debug: Key Obtained)" ;; # Debug key
    esac

    ((frame++))
done