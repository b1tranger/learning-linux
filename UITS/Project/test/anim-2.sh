# Define the body parts as variables for easy editing
# Frame A: Wide stance
H_HEAD=" (o-o) "
H_BODY="/[###]\\"
H_LEGS_A="_|   |_"

# Frame B: Narrow stance
H_LEGS_B="  | |  "

draw_humanoid() {
    tput setaf 2 # Set to green [3]
    
    # Row 1: Head
    tput cup $y $x; echo "$H_HEAD"
    
    # Row 2: Torso/Arms
    tput cup $((y+1)) $x; echo "$H_BODY"
    
    # Row 3: Animated Legs
    # Toggle legs based on the frame (steps taken) [6, 7]
    tput cup $((y+2)) $x
    if [[ $((frame % 2)) -eq 0 ]]; then
        echo "$H_LEGS_A"
    else
        echo "$H_LEGS_B"
    fi
    tput sgr0
}

# IMPORTANT: You must update your clearing function 
# to match the 7-character width of the new sprite [5]
clear_humanoid() {
    for i in {0..2}; do
        tput cup $((y+i)) $x; echo "       " # 7 spaces to clear the width
    done
}