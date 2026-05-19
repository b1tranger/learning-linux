#!/bin/bash

# Tavern of Life - Final Project
# A 2D Terminal Platformer with NPCs and Conversations

# Map Settings
WIDTH=60
HEIGHT=20

# Player Start
SPAWN_X=6; SPAWN_Y=10
EXIT_X=55; EXIT_Y=17
x=$SPAWN_X; y=$SPAWN_Y
frame=0
idle_frame=0
has_realization=false

# NPC Coordinates

BARTENDER_X=18; BARTENDER_Y=2
PATRON_X=34; PATRON_Y=6
DRUNK_X=42; DRUNK_Y=6
OLDMAN_X=52; OLDMAN_Y=14

# Conversation tracking 
# (0 = not talked, 1 = intro done, 2 = QnA done)
BARTENDER_STATE=0
PATRON_STATE=0
DRUNK_STATE=0
OLDMAN_STATE=0
KEY_STAGE=0


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
    # $1 = title, $2 = message body
    whiptail --title "$1" --msgbox "$2" 12 55
    tput civis  # Re-hide cursor after whiptail restores it
    draw_map 
    draw_all
}

ask_yesno() {
    # $1 = title, $2 = question. Returns 0 for Yes, 1 for No.
    whiptail --title "$1" --yesno "$2" 10 55
    local result=$?
    tput civis  # Re-hide cursor after whiptail restores it
    return $result
}


# QnA CONVERSATION SYSTEM
# Each NPC has an array of questions and corresponding answers.
# To add more questions, simply append to the arrays below.
# Format: QUESTIONS[index]="Question text"
#         ANSWERS[index]="Answer text"


# --- Bartender QnA (3 questions) ---
BARTENDER_Q=()
BARTENDER_A=()
BARTENDER_Q[0]="What is this place?"
BARTENDER_A[0]="This is the Tavern of Life. A place where lost souls come to rest before moving on."
BARTENDER_Q[1]="Who are those two at the table?"
BARTENDER_A[1]="The sober one's been waiting for someone. The drunk one? He's been here longer than me."
BARTENDER_Q[2]="How do I get out of here?"
BARTENDER_A[2]="You'll need the key. But you only earn it by asking the right questions... like you just did."

# --- Sober Patron QnA (1 question) ---
PATRON_Q=()
PATRON_A=()
PATRON_Q[0]="Are you waiting for someone?"
PATRON_A[0]="...Maybe. Maybe I'm waiting for myself to finally leave."

# --- Drunk Patron QnA (1 question) ---
DRUNK_Q=()
DRUNK_A=()
DRUNK_Q[0]="How long have you been here?"
DRUNK_A[0]="*hic* Long enough to forget... and short enough to remember too much."

# --- Old Man QnA (1 question) ---
OLDMAN_Q=()
OLDMAN_A=()
OLDMAN_Q[0]="What's beyond the exit?"
OLDMAN_A[0]="The same thing that was before the entrance. Only you'll be different."

# --- QnA Runner ---
# Runs through all questions for a given NPC.
# Usage: run_qna "NPC Name" QUESTIONS_ARRAY ANSWERS_ARRAY
run_qna() {
    local npc_name="$1"
    shift
    # We receive the questions and answers as positional args: Q1 A1 Q2 A2 ...
    local pairs=("$@")
    local count=$(( ${#pairs[@]} / 2 ))

    for ((i=0; i<count; i++)); do
        local q="${pairs[$((i*2))]}"
        local a="${pairs[$((i*2+1))]}"

        if ask_yesno "$npc_name" "Ask: \"$q\""; then
            show_dialogue "$npc_name" "$a"
        else
            show_dialogue "$npc_name" "Maybe another time then."
            return 1  # Player skipped, conversation incomplete
        fi
    done
    return 0  # All questions asked
}


# MAP DRAWING


draw_map() {
    clear
    tput civis

    # --- Border (using -n to prevent newline artifacts) ---
    for ((i=1; i<$WIDTH; i++)); do tput cup 0 $i; echo -n "═"; tput cup $HEIGHT $i; echo -n "═"; done
    for ((i=1; i<$HEIGHT; i++)); do tput cup $i 0; echo -n "║"; tput cup $i $WIDTH; echo -n "║"; done
    tput cup 0 0; echo -n "╔"; tput cup 0 $WIDTH; echo -n "╗"
    tput cup $HEIGHT 0; echo -n "╚"; tput cup $HEIGHT $WIDTH; echo -n "╝"

    # --- Extended Bartender's Counter / Table ---
    tput setaf 3
    # Long counter top (bartender on left, gap, then patrons on right)
    tput cup 4 10; echo -n "╔════════════════════════════════════════╗"
    tput cup 5 10; echo -n "║  ☕     🍺        🍺     ☕     🍺  ║"
    tput cup 6 10; echo -n "╚════════════════════════════════════════╝"
    # Chair legs / stools in front of the patron seats
    tput cup 7 32; echo -n "╥"
    tput cup 7 40; echo -n "╥"
    tput sgr0

    # --- Doors ---
    tput cup $SPAWN_Y 1; echo -n "🚪(IN)"
    tput cup $EXIT_Y $EXIT_X; echo -n "🚪[EXIT]"

    # --- Floor decoration ---
    tput setaf 8
    tput cup 12 10; echo -n "~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~"
    tput cup 16 5; echo -n ". . . . . . . . . . . . . . . ."
    tput sgr0

    # --- Help bar ---
    tput cup $((HEIGHT + 1)) 2
    echo -n "Use Arrows/WASD to move | 't' to Talk | 'q' to Quit"
}


# CHARACTER DRAWING (Detailed designs, 4 rows each)


draw_player() {
    tput setaf 2
    # Row 0: Hat
    tput cup $y $x;       echo -n "  ▄  "
    # Row 1: Head
    tput cup $((y+1)) $x; echo -n " (o) "
    # Row 2: Torso + arms
    if [[ $((idle_frame % 20)) -lt 10 && $frame -eq $last_frame ]]; then
        tput cup $((y+2)) $x; echo -n "─┤├─"
    else
        tput cup $((y+2)) $x; echo -n "╶┤├╴"
    fi
    # Row 3: Legs
    if [[ $frame -eq $last_frame ]]; then
        tput cup $((y+3)) $x; echo -n " ┘└ "
    else
        if [[ $((frame % 2)) -eq 0 ]]; then
            tput cup $((y+3)) $x; echo -n " ╱╲ "
        else
            tput cup $((y+3)) $x; echo -n " ┘└ "
        fi
    fi
    tput sgr0
}

draw_bartender() {
    local bx=${1:-$BARTENDER_X}
    local by=${2:-$BARTENDER_Y}
    tput setaf 6
    # Row 0: Head with bandana
    tput cup $by $bx;       echo -n " ≡▓≡ "
    # Row 1: Face
    tput cup $((by+1)) $bx; echo -n " (‿) "
    # Row 2: Torso (apron) + arms (wiping motion)
    if [[ $((idle_frame % 16)) -lt 8 ]]; then
        tput cup $((by+2)) $bx; echo -n "─╣╠~'"
    else
        tput cup $((by+2)) $bx; echo -n "'~╣╠─"
    fi
    tput sgr0
}

draw_patron() {
    local px=${1:-$PATRON_X}
    local py=${2:-$PATRON_Y}
    tput setaf 5
    # Row 0: Head
    tput cup $py $px;       echo -n "  ◉  "
    # Row 1: Face
    tput cup $((py+1)) $px; echo -n " (─) "
    # Row 2: Torso (seated, leaning on table)
    if [[ $((idle_frame % 24)) -lt 12 ]]; then
        tput cup $((py+2)) $px; echo -n " /█\\ "
    else
        tput cup $((py+2)) $px; echo -n " /█_▌"
    fi
    # Row 3: Seated legs
    tput cup $((py+3)) $px;  echo -n "  ╨╨ "
    tput sgr0
}

draw_drunk() {
    local dx=${1:-$DRUNK_X}
    local dy=${2:-$DRUNK_Y}
    tput setaf 1
    # Clear previous sway position to avoid ghost artifacts
    tput cup $dy $((dx-1));     echo -n "      "
    tput cup $((dy+1)) $((dx-1)); echo -n "      "
    tput cup $((dy+2)) $((dx-1)); echo -n "      "
    tput cup $((dy+3)) $((dx-1)); echo -n "      "
    tput cup $dy $((dx+1));     echo -n "      "
    tput cup $((dy+1)) $((dx+1)); echo -n "      "
    tput cup $((dy+2)) $((dx+1)); echo -n "      "
    tput cup $((dy+3)) $((dx+1)); echo -n "      "
    # Swaying animation shifts entire character
    if [[ $((idle_frame % 10)) -lt 5 ]]; then
        # Leaning left
        tput cup $dy $((dx-1));     echo -n "  ◎  "
        tput cup $((dy+1)) $((dx-1)); echo -n " (≈) "
        tput cup $((dy+2)) $((dx-1)); echo -n "\\▓█/ "
        tput cup $((dy+3)) $((dx-1)); echo -n "  └┘ "
    else
        # Leaning right
        tput cup $dy $((dx+1));     echo -n "  ◎  "
        tput cup $((dy+1)) $((dx+1)); echo -n " (≈) "
        tput cup $((dy+2)) $((dx+1)); echo -n " \\█▓/"
        tput cup $((dy+3)) $((dx+1)); echo -n "  └┘ "
    fi
    tput sgr0
}

draw_oldman() {
    local ox=${1:-$OLDMAN_X}
    local oy=${2:-$OLDMAN_Y}
    tput setaf 7
    # Row 0: Bald head
    tput cup $oy $ox;       echo -n "  █  "
    # Row 1: Face (beard)
    tput cup $((oy+1)) $ox; echo -n " {_} "
    # Row 2: Hunched torso + cane
    if [[ $((idle_frame % 30)) -lt 15 ]]; then
        tput cup $((oy+2)) $ox; echo -n " /▓│/"
    else
        tput cup $((oy+2)) $ox; echo -n " /▓│|"
    fi
    # Row 3: Legs (slow shuffle)
    if [[ $((idle_frame % 40)) -lt 20 ]]; then
        tput cup $((oy+3)) $ox; echo -n "  ╨╨ "
    else
        tput cup $((oy+3)) $ox; echo -n "  ╨ ╨"
    fi
    tput sgr0
}

# --- Legend Drawing ---
draw_legend() {
    # Draw characters and roles on the right side of the screen
    local lx=63
    draw_bartender $lx 2
    tput cup 3 $((lx+8)); tput setaf 6; echo -n "Bartender"; tput sgr0
    
    draw_patron $lx 6
    tput cup 7 $((lx+8)); tput setaf 5; echo -n "Sober Patron"; tput sgr0
    
    draw_drunk $lx 10
    tput cup 11 $((lx+8)); tput setaf 1; echo -n "Drunk Patron"; tput sgr0
    
    draw_oldman $lx 15
    tput cup 16 $((lx+8)); tput setaf 7; echo -n "Old Man"; tput sgr0
}

# --- Draw All ---
draw_all() {
    draw_bartender
    draw_patron
    draw_drunk
    draw_oldman
    draw_player
    draw_legend
}

# --- Clear player footprints (4 rows now) ---
clear_footprints() {
    for i in {0..3}; do tput cup $((y+i)) $x; echo -n "     "; done
}


# CONVERSATION / TALK SYSTEM


check_talk() {
    local talked=0

    # --- Bartender ---
    if [[ $(( (x-BARTENDER_X)*(x-BARTENDER_X) + (y-BARTENDER_Y)*(y-BARTENDER_Y) )) -le 36 ]]; then
        if [[ $KEY_STAGE -lt 3 ]]; then
            show_dialogue "Bartender" "Welcome to the Tavern of Life! Speak with the patrons before coming to me."
        elif [[ $KEY_STAGE -eq 3 ]]; then
            if [[ $BARTENDER_STATE -eq 0 || $BARTENDER_STATE -eq 1 ]]; then
                show_dialogue "Bartender" "You've spoken with everyone. I have the final key."
                BARTENDER_STATE=1
                if ask_yesno "Bartender" "Got a moment? I could use someone to talk to."; then
                    local pairs=()
                    for ((i=0; i<${#BARTENDER_Q[@]}; i++)); do
                        pairs+=("${BARTENDER_Q[$i]}" "${BARTENDER_A[$i]}")
                    done
                    run_qna "Bartender" "${pairs[@]}"
                    if [[ $? -eq 0 ]]; then
                        BARTENDER_STATE=2
                        KEY_STAGE=4
                        has_realization=true
                        show_dialogue "System" "🔑 The Bartender slides you the Final Key. \"You've earned your way out.\""
                    fi
                fi
            else
                show_dialogue "Bartender" "You already have the key. Go on now, the exit awaits."
            fi
        else
            show_dialogue "Bartender" "You already have the key. Go on now, the exit awaits."
        fi
        talked=1

    # --- Sober Patron ---
    elif [[ $(( (x-PATRON_X)*(x-PATRON_X) + (y-PATRON_Y)*(y-PATRON_Y) )) -le 25 ]]; then
        if [[ $KEY_STAGE -eq 0 ]]; then
            if [[ $PATRON_STATE -eq 0 || $PATRON_STATE -eq 1 ]]; then
                if [[ $PATRON_STATE -eq 0 ]]; then
                    show_dialogue "Patron" "...Don't look at me like that. I chose to sit here."
                    PATRON_STATE=1
                fi
                if ask_yesno "Patron" "Mind if I ask you something?"; then
                    local pairs=()
                    for ((i=0; i<${#PATRON_Q[@]}; i++)); do
                        pairs+=("${PATRON_Q[$i]}" "${PATRON_A[$i]}")
                    done
                    run_qna "Patron" "${pairs[@]}"
                    if [[ $? -eq 0 ]]; then 
                        PATRON_STATE=2
                        KEY_STAGE=1
                        show_dialogue "System" "🔑 You received Key 1 from the Sober Patron."
                    fi
                fi
            fi
        else
            show_dialogue "Patron" "*stares into the distance*"
        fi
        talked=1

    # --- Drunk Patron ---
    elif [[ $(( (x-DRUNK_X)*(x-DRUNK_X) + (y-DRUNK_Y)*(y-DRUNK_Y) )) -le 25 ]]; then
        if [[ $KEY_STAGE -lt 1 ]]; then
            show_dialogue "Drunk Patron" "*hic* Talk to my sober friend over there first..."
        elif [[ $KEY_STAGE -eq 1 ]]; then
            if [[ $DRUNK_STATE -eq 0 || $DRUNK_STATE -eq 1 ]]; then
                if [[ $DRUNK_STATE -eq 0 ]]; then
                    show_dialogue "Drunk Patron" "*hic* Hey! Are you... passing my line? Get back! *hic*"
                    DRUNK_STATE=1
                fi
                if ask_yesno "Drunk Patron" "*hic* ...You still here? Fine. Ask me something."; then
                    local pairs=()
                    for ((i=0; i<${#DRUNK_Q[@]}; i++)); do
                        pairs+=("${DRUNK_Q[$i]}" "${DRUNK_A[$i]}")
                    done
                    run_qna "Drunk Patron" "${pairs[@]}"
                    if [[ $? -eq 0 ]]; then 
                        DRUNK_STATE=2
                        KEY_STAGE=2
                        show_dialogue "System" "🔑 You received Key 2 from the Drunk Patron."
                    fi
                fi
            fi
        else
            show_dialogue "Drunk Patron" "*hic* ...zzz..."
        fi
        talked=1

    # --- Old Man ---
    elif [[ $(( (x-OLDMAN_X)*(x-OLDMAN_X) + (y-OLDMAN_Y)*(y-OLDMAN_Y) )) -le 25 ]]; then
        if [[ $KEY_STAGE -lt 2 ]]; then
            show_dialogue "Old Man" "You lack the wisdom of the patrons. Seek them first."
        elif [[ $KEY_STAGE -eq 2 ]]; then
            if [[ $OLDMAN_STATE -eq 0 || $OLDMAN_STATE -eq 1 ]]; then
                if [[ $OLDMAN_STATE -eq 0 ]]; then
                    show_dialogue "Old Man" "The exit is near, but are you truly ready to leave?"
                    OLDMAN_STATE=1
                fi
                if ask_yesno "Old Man" "One question. That's all I'll give you."; then
                    local pairs=()
                    for ((i=0; i<${#OLDMAN_Q[@]}; i++)); do
                        pairs+=("${OLDMAN_Q[$i]}" "${OLDMAN_A[$i]}")
                    done
                    run_qna "Old Man" "${pairs[@]}"
                    if [[ $? -eq 0 ]]; then 
                        OLDMAN_STATE=2
                        KEY_STAGE=3
                        show_dialogue "System" "🔑 You received Key 3 from the Old Man."
                    fi
                fi
            fi
        elif [[ $KEY_STAGE -ge 4 || $has_realization == true ]]; then
            show_dialogue "Old Man" "Ah, you found the final key. A reward for clearing the game:\n\n'The road is long, the night is dark...\nBut every soul must leave a mark.'\n\nFarewell."
        else
            show_dialogue "Old Man" "*nods quietly toward the exit*"
        fi
        talked=1
    fi

    if [[ $talked -eq 0 ]]; then
        tput cup $((HEIGHT + 2)) 2
        echo -n "No one is nearby to talk to.                                    "
    else
        tput cup $((HEIGHT + 2)) 2
        echo -n "                                                                "
    fi
}


# MAIN GAME LOOP


# Loading Screen
clear
tput setaf 3
tput cup $((HEIGHT / 2)) $((WIDTH / 4))
echo "GAМE LOADING..."
tput cup $((HEIGHT / 2 + 1)) $((WIDTH / 4))
echo "Entering the Tavern of Life..."
sleep 2

# Story Briefing Screen
whiptail --title "Tavern of Life" --msgbox \
"A sad man enters a tavern of life.\n\nHere, no man leaves without realizing something." 10 55
tput civis

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
            "[A"|w) [[ $y -gt 1 ]] && ((y=y-2)) && ((frame++)) ;;
            "[B"|s) [[ $y -lt $((HEIGHT-4)) ]] && ((y=y+2)) && ((frame++)) ;;
            "[C"|d) [[ $x -lt $((WIDTH-5)) ]] && ((x=x+2)) && ((frame++)) ;;
            "[D"|a) [[ $x -gt 1 ]] && ((x=x-2)) && ((frame++)) ;;
            t) check_talk ;;
            q) close_game ;;
            k) has_realization=true; show_dialogue "System" "🔑 Key Obtained!" ;; 
        esac
    fi

    # 1. Logic: Check for Interaction at Entry Gate
    if [[ $x -le 2 && $y -eq $SPAWN_Y ]]; then
        if whiptail --title "The Old Man" --yesno "Young man, if you get out from where you got in being sad, you will remain sad. Exit anyway?" 10 60; then
            tput cnorm; stty echo; clear; echo "You left the tavern, still sad. The cycle continues."; exit 0
        else
            tput civis
            x=3
            draw_map
            draw_all
        fi
    fi

    # 2. Logic: Win Condition at Final Exit
    if [[ $x -ge $((EXIT_X-1)) && $x -le $((EXIT_X+3)) && $y -ge $((EXIT_Y-1)) && $y -le $((EXIT_Y+1)) ]]; then
        if [ "$has_realization" = true ]; then
            tput cnorm; stty echo; clear; echo "You step out into the light, finally at peace. YOU WIN!"; exit 0
        else
            show_dialogue "Old Man" "The door is locked. You haven't found the 'key' to your meaning of life yet."
            x=$((EXIT_X - 5))
            draw_map
            draw_all
        fi
    fi

    # Update drawing every few idle frames for NPC animations
    if [[ $((idle_frame % 5)) -eq 0 || $frame -ne $last_frame ]]; then
        draw_all
    fi

    # Hint for the shortcut key after enough walking
    if [[ $frame -ge 60 ]]; then
        tput cup $((HEIGHT + 2)) 2; tput setaf 6; echo -n "A wise one becomes wise when he wants to. press 'k'"; tput sgr0
    fi
done
