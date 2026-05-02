#!/bin/bash

# Initial position
x=5
y=5
frame=0

# Clean screen and hide cursor
clear
tput civis 

draw_char() {
    # Move cursor to position (y, x)
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
    
    # Read one character (arrow keys send escape sequences like ^[[A)
    read -rsn1 input
    
    # Simple interaction: clear old spot
    tput cup $y $x; echo "   "
    tput cup $((y+1)) $x; echo "   "
    tput cup $((y+2)) $x; echo "   "

    case $input in
        A) ((y--)) ;; # Up (Standard ANSI escape)
        B) ((y++)) ;; # Down
        C) ((x++)) ;; # Right
        D) ((x--)) ;; # Left
        q) break ;;
    esac
    
    ((frame++)) # Toggle walking frame
done

tput cnorm # Restore cursor
