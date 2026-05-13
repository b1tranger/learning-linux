#!/bin/bash

# --- Configuration ---
CANDLE_X=20
CANDLE_Y=10
frame=0

# --- Terminal Settings ---
# Silence terminal echo and hide the cursor for a clean look [7, 8]
stty -echo
tput civis

# Cleanup function to restore terminal settings on exit [7, 8]
close_animation() {
    stty echo
    tput cnorm
    clear
    echo "The light goes out."; exit 0
}
trap close_animation SIGINT SIGTERM

clear
echo "Press 'q' to stop the animation."

while true; do
    # 1. Capture Input with non-blocking timeout [3, 4]
    # 0.1s allows for smooth flickering (~10 FPS)
    read -rsn1 -t 0.1 input
    [[ $input == "q" ]] && close_animation

    # 2. Drawing Logic using tput [1, 2]
    # Draw the Candle Base
    tput setaf 7 # White color
    tput cup $CANDLE_Y $CANDLE_X; echo "[|||]"
    tput cup $((CANDLE_Y + 1)) $CANDLE_X; echo "[|||]"
    
    # Draw the Flickering Flame using modulo logic [5, 6]
    tput setaf 3 # Yellow/Orange color
    tput cup $((CANDLE_Y - 1)) $((CANDLE_X + 2))
    
    # Alternate flame shapes based on the frame count [3, 4]
    if [[ $((frame % 4)) -eq 0 ]]; then
        echo "*"   # Small flicker
    elif [[ $((frame % 4)) -eq 1 ]]; then
        echo "^"   # Tall flicker
    elif [[ $((frame % 4)) -eq 2 ]]; then
        echo "i"   # Narrow flicker
    else
        echo " "   # Brief dimming
    fi
    
    tput sgr0 # Reset colors

    ((frame++))
done