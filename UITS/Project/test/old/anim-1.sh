# while true; do
#   tput cup $((RANDOM%LINES)) $((RANDOM%COLUMNS))
#   printf "*"
#   sleep 0.1
# done

while true; do
  # Get current screen size
  L=$(tput lines)
  C=$(tput cols)
  
  # Pick a random spot
  tput cup $((RANDOM % L)) $((RANDOM % C))
  
  # Print a character (e.g., a green dot)
  echo -ne "\e[32m*\e[0m"
  
  sleep 0.1
done

