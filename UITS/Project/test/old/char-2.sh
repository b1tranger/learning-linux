#!/bin/bash

# Initial position
x=5
y=5
frame=0

# --- NEW: CLOSE FUNCTION ---
close_game() {
    clear
    tput cnorm # Restore the cursor so the terminal isn't "broken"
    echo "Thanks for playing!"
    exit 0
}

# --- NEW: TRAP ---
# If the user hits Ctrl+C, run the close_game function automatically
trap close_game SIGINT SIGTERM

# Clean screen and hide cursor
clear
tput civis 

draw_char() {
    tput cup $y $x
    if [ $((frame % 2)) -eq 0 ]; then
        echo -e " o "
        tput cup $((y+1)) $x; echo -e "/|\\"
        tput cup $((y+2)) $x; echo -e "/ \\"
    else
        echo -e " o "
        tput cup $((y+1)) $x; echo -e "/|\\"
        tput cup $((y+2)) $x; echo -e " | "
    fi
}

while true; do
    draw_char
    
    # Read one character
    read -rsn1 input
    
    # Clear old spot
    tput cup $y $x; echo "   "
    tput cup $((y+1)) $x; echo "   "
    tput cup $((y+2)) $x; echo "   "

    case $input in
        A) ((y--)) ;; 
        B) ((y++)) ;; 
        C) ((x++)) ;; 
        D) ((x--)) ;; 
        q|0) close_game ;; # Pressing 'q' or '0' calls the close function
        $'\e') close_game ;; # This detects the ESC key specifically
    esac
    
    ((frame++)) 
done
