# Final Project Report: Tavern of Life

## 1. Game Story
**"Tavern of Life"** is a narrative-driven 2D terminal platformer where a sad man (the player) enters a mysterious tavern. The establishment operates on a singular rule: **no man leaves without a realization**. 

To succeed, the player must search for the "Key"—not a physical object, but a profound meaning of life that cures the protagonist's sadness. The player explores the tavern, speaks with other lost souls (NPCs), and gathers pieces of wisdom. The game ends successfully only when the player finds the final realization and exits through the final gate, leaving the tavern at peace.

## 2. Character Details
The tavern is inhabited by various characters, each serving a role in the story's progression:

- **The Player (Sad Man)**: Controlled by the user via WASD/Arrow keys. Their sprite's legs animate when moving.
- **Sober Patron**: Sits quietly at a table. He is waiting, perhaps for himself to finally leave. He holds the first piece of wisdom (Key 1).
- **Drunk Patron**: Sits near his sober friend, swaying continuously. He's been here long enough to forget but short enough to remember too much. He holds the second piece of wisdom (Key 2).
- **Old Man**: A hunched figure near the exit. He guards the exit gate and questions the player's readiness to leave. He holds the third piece of wisdom (Key 3) and recites a poem upon game completion.
- **The Bartender**: Positioned behind the counter, he welcomes the lost souls. He holds the **Final Key** to unlock the exit door.

## 3. Sequence of Winning Conditions
To win the game, the player must solve a sequential puzzle by interacting with the NPCs in a specific order. They cannot skip ahead.

1. **Obtain Key 1**: Talk to the **Sober Patron** and complete his dialogue/QnA.
2. **Obtain Key 2**: Talk to the **Drunk Patron** and complete his dialogue/QnA.
3. **Obtain Key 3**: Talk to the **Old Man** and complete his dialogue/QnA.
4. **Obtain the Final Key**: Talk to the **Bartender**. He will recognize your wisdom and slide you the final key, granting the "realization" (`has_realization=true`).
5. **(Optional) The Reward**: Speak to the **Old Man** again to hear his parting poem.
6. **Exit the Tavern**: Move the player to the exit gate on the right side of the map `[EXIT]`. The door will unlock, and the player will step into the light.

## 4. Code Structure & Architecture
The game uses standard Linux shell utilities to build a sophisticated 2D engine:
- `tput` (ncurses interface): Used for manipulating the cursor position, rendering characters and map borders, and setting text colors.
- `whiptail`: Handles interactive story dialogue and QnA menus, keeping the movement logic distinct from the interface.
- `stty -echo`: A stability tool to silence keyboard input "leaks" (like `^[[A`) from corrupting the screen rendering.
- **State Machines**: Tracks the progression of conversations (`BARTENDER_STATE`, `PATRON_STATE`) and the puzzle sequence (`KEY_STAGE`).

### The Game Loop Pattern
To prevent sprite flickering, the game follows a non-blocking `Read -> Clear -> Move -> Draw` loop:
1. **Read**: Captures input with a short timeout (`read -t`).
2. **Clear**: Erases the player's footprint at their old coordinates.
3. **Move & Logic**: Updates coordinates and evaluates interaction triggers.
4. **Draw**: Renders the game state.

## 5. Key Code Snippets

### Non-Blocking Input Loop
This ensures the game animates characters (like the Drunk Patron swaying) even when the player isn't pressing keys.
```bash
# Capture input with a timeout for animations (0.05s)
read -rsn1 -t 0.05 input
if [[ $input == $'\e' ]]; then
    read -rsn2 -t 0.001 input # Very fast timeout for sequences
fi

# Flush extra buffer instantly to handle input flooding
if [[ -n $input ]]; then
    while read -rsn1 -t 0 flush; do :; done
```

### Dynamic Character Rendering & Animation
Characters are drawn using `tput` to set coordinates and colors. We pass `$1` and `$2` as coordinate parameters so we can reuse the functions to render a Legend on the right side of the screen. The Drunk Patron's swaying is calculated via the `idle_frame` counter.
```bash
draw_drunk() {
    local dx=${1:-$DRUNK_X}
    local dy=${2:-$DRUNK_Y}
    tput setaf 1
    
    # Swaying animation shifts entire character
    if [[ $((idle_frame % 10)) -lt 5 ]]; then
        # Leaning left
        tput cup $dy $((dx-1));     echo -n "  ◎  "
        tput cup $((dy+1)) $((dx-1)); echo -n " (≈) "
    else
        # Leaning right
        tput cup $dy $((dx+1));     echo -n "  ◎  "
        tput cup $((dy+1)) $((dx+1)); echo -n " (≈) "
    fi
    tput sgr0
}
```

### Puzzle Logic (State Checks)
The `KEY_STAGE` variable forces the player to speak to characters in a specific order. If the player tries to speak to the Bartender too early, they are rejected.
```bash
if [[ $(( (x-BARTENDER_X)**2 + (y-BARTENDER_Y)**2 )) -le 36 ]]; then
    if [[ $KEY_STAGE -lt 3 ]]; then
        show_dialogue "Bartender" "Welcome to the Tavern of Life! Speak with the patrons before coming to me."
    elif [[ $KEY_STAGE -eq 3 ]]; then
        # Final interaction logic
        run_qna "Bartender" "${pairs[@]}"
        if [[ $? -eq 0 ]]; then
            KEY_STAGE=4
            has_realization=true
            show_dialogue "System" "🔑 The Bartender slides you the Final Key."
        fi
    fi
fi
```
