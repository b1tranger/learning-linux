#!/bin/bash

# Tavern of Life - Final Project
# A 2D Terminal Platformer with NPCs

# Map Settings
WIDTH=60
HEIGHT=20

# Player Start
SPAWN_X=6; SPAWN_Y=6
EXIT_X=55; EXIT_Y=17
x=$SPAWN_X; y=$SPAWN_Y
frame=0
idle_frame=0
has_realization=false

# NPC Coordinates
# Bartender
BARTENDER_X=30; BARTENDER_Y=3
# Sober Patron
PATRON_X=26; PATRON_Y=6
# Drunk Patron
DRUNK_X=34; DRUNK_Y=6
# Old Man
OLDMAN_X=52; OLDMAN_Y=17

# --- Terminal Settings ---
stty -echo
tput civis

close_game() {
    stty echo    
    tput cnorm   
    clear
    echo "The tavern fades into memory. Game Closed."
    exit 0
}
trap close_game SIGINT SIGTERM

show_dialogue() {
    whiptail --title "$1" --msgbox "$2" 10 50
    draw_map 
    draw_all
}

draw_map() {
    clear
    tput civis
    # Borders
    for ((i=1; i<$WIDTH; i++)); do tput cup 0 $i; echo "═"; tput cup $HEIGHT $i; echo "═"; done
    for ((i=1; i<$HEIGHT; i++)); do tput cup $i 0; echo "║"; tput cup $i $WIDTH; echo "║"; done
    tput cup 0 0; echo "╔"; tput cup 0 $WIDTH; echo "╗"
    tput cup $HEIGHT 0; echo "╚"; tput cup $HEIGHT $WIDTH; echo "╝"
    
    # Table (Bartender's counter)
    tput setaf 3
    tput cup 4 20; echo "======================"
    tput cup 5 24; echo "[]"
    tput cup 5 36; echo "[]"
    tput sgr0

    # Doors
    tput cup $SPAWN_Y 1; echo "🚪(IN)"
    tput cup $EXIT_Y $EXIT_X; echo "🚪[EXIT]"

    # Help
    tput cup $((HEIGHT + 1)) 2
    echo "Use Arrows/WASD to move | 't' to Talk | 'q' to Quit"
}

# Drawing Functions
draw_player() {
    tput setaf 2
    tput cup $y $x; echo " o "
    tput cup $((y+1)) $x; echo "/|\\"
    # Legs toggle based on movement frame OR idle breath
    if [[ $((idle_frame % 20)) -lt 10 && $frame -eq $last_frame ]]; then
        tput cup $((y+2)) $x; echo " | "
    else
        tput cup $((y+2)) $x; [[ $((frame % 2)) -eq 0 ]] && echo "/ \\" || echo " | "
    fi
    tput sgr0
}

draw_bartender() {
    tput setaf 6
    tput cup $BARTENDER_Y $BARTENDER_X; echo " o "
    if [[ $((idle_frame % 16)) -lt 8 ]]; then
        tput cup $((BARTENDER_Y+1)) $((BARTENDER_X-1)); echo "/|\\"
    else
        tput cup $((BARTENDER_Y+1)) $((BARTENDER_X-1)); echo "\\|/"
    fi
    tput sgr0
}

draw_patron() {
    tput setaf 5
    tput cup $PATRON_Y $PATRON_X; echo " o "
    if [[ $((idle_frame % 24)) -lt 12 ]]; then
        tput cup $((PATRON_Y+1)) $((PATRON_X-1)); echo "/|_"
    else
        tput cup $((PATRON_Y+1)) $((PATRON_X-1)); echo "/|\\"
    fi
    tput sgr0
}

draw_drunk() {
    tput setaf 1
    # Swaying animation
    if [[ $((idle_frame % 10)) -lt 5 ]]; then
        tput cup $DRUNK_Y $((DRUNK_X-1)); echo " (o "
        tput cup $((DRUNK_Y+1)) $((DRUNK_X-1)); echo " /|\\"
    else
        tput cup $DRUNK_Y $DRUNK_X; echo " o) "
        tput cup $((DRUNK_Y+1)) $DRUNK_X; echo "/|\\ "
    fi
    tput sgr0
}

draw_oldman() {
    tput setaf 7
    tput cup $OLDMAN_Y $OLDMAN_X; echo " o "
    if [[ $((idle_frame % 30)) -lt 15 ]]; then
        tput cup $((OLDMAN_Y+1)) $((OLDMAN_X-1)); echo "/|/"
    else
        tput cup $((OLDMAN_Y+1)) $((OLDMAN_X-1)); echo "/||"
    fi
    tput sgr0
}

draw_all() {
    draw_bartender
    draw_patron
    draw_drunk
    draw_oldman
    draw_player
}

clear_footprints() {
    for i in {0..2}; do tput cup $((y+i)) $x; echo "   "; done
}

# Distance Function for Talk
check_talk() {
    local talked=0
    
    # Check distance to Bartender
    if [[ $(( (x-BARTENDER_X)*(x-BARTENDER_X) + (y-BARTENDER_Y)*(y-BARTENDER_Y) )) -le 25 ]]; then
        show_dialogue "Bartender" "Welcome to the Tavern of Life! Drink up, but don't mind the drunk."
        talked=1
    # Check distance to Sober Patron
    elif [[ $(( (x-PATRON_X)*(x-PATRON_X) + (y-PATRON_Y)*(y-PATRON_Y) )) -le 16 ]]; then
        show_dialogue "Patron" "Ignore him, he's had too much ale."
        talked=1
    # Check distance to Drunk Patron
    elif [[ $(( (x-DRUNK_X)*(x-DRUNK_X) + (y-DRUNK_Y)*(y-DRUNK_Y) )) -le 16 ]]; then
        show_dialogue "Drunk Patron" "*hic* Hey! Are you... are you passing my line? Get back! *hic*"
        talked=1
    # Check distance to Old Man
    elif [[ $(( (x-OLDMAN_X)*(x-OLDMAN_X) + (y-OLDMAN_Y)*(y-OLDMAN_Y) )) -le 16 ]]; then
        show_dialogue "Old Man" "The exit is near, but are you truly ready to leave? The door is locked anyway..."
        talked=1
    fi
    
    if [[ $talked -eq 0 ]]; then
        tput cup $((HEIGHT + 2)) 2
        echo "No one is nearby to talk to.                        "
    else
        # Clear the "no one nearby" message
        tput cup $((HEIGHT + 2)) 2
        echo "                                                    "
    fi
}

# Initial Draw
draw_map
draw_all

last_frame=$frame

while true; do
    # Loop timing and idle frame counter
    ((idle_frame++))
    last_frame=$frame

    read -rsn1 -t 0.05 input
    if [[ $input == $'\e' ]]; then
        read -rsn2 -t 0.001 input 
    fi

    if [[ -n $input ]]; then
        while read -rsn1 -t 0 flush; do :; done
        
        # Clear footprints before moving
        if [[ "$input" =~ ^(\[A|w|\[B|s|\[C|d|\[D|a)$ ]]; then
            clear_footprints
        fi

        case $input in
            "[A"|w) [[ $y -gt 1 ]] && ((y--)) && ((frame++)) ;;
            "[B"|s) [[ $y -lt $((HEIGHT-3)) ]] && ((y++)) && ((frame++)) ;;
            "[C"|d) [[ $x -lt $((WIDTH-3)) ]] && ((x++)) && ((frame++)) ;;
            "[D"|a) [[ $x -gt 1 ]] && ((x--)) && ((frame++)) ;;
            t) check_talk ;;
            q) close_game ;;
            k) has_realization=true; show_dialogue "System" "Key Obtained!" ;; 
        esac
    fi

    # Triggers
    if [[ $x -le 2 && $y -eq $SPAWN_Y ]]; then
        if whiptail --title "The Void" --yesno "Return to the outside?" 10 60; then close_game; else clear_footprints; x=3; draw_map; draw_all; fi
    fi

    if [[ $x -ge $((EXIT_X-1)) && $x -le $((EXIT_X+3)) && $y -ge $((EXIT_Y-1)) && $y -le $((EXIT_Y+1)) ]]; then
        if [ "$has_realization" = true ]; then tput cnorm; clear; echo "YOU WIN! You have exited the Tavern of Life."; exit 0; 
        else show_dialogue "System" "The door is locked."; clear_footprints; x=$((EXIT_X - 5)); draw_map; draw_all; fi
    fi

    # Update drawing every frame for idle animations
    if [[ $((idle_frame % 5)) -eq 0 || $frame -ne $last_frame ]]; then
        # Redraw all characters over the background
        draw_all
    fi

    if [[ $frame -ge 60 ]]; then
        # tput cup $((HEIGHT + 2)) 50; tput setaf 6; echo "Press 'k'"; tput sgr0
        tput cup $((HEIGHT + 2)) 2; tput setaf 6; echo "A wise one becomes wise when he wants to. press 'k'"; tput sgr0
    fi
done
