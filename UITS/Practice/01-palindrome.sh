read -p "Enter a number to check palindrome?" A

B=$(echo "$A" | rev)

if [ $A == $B ]; then
echo "Palindrome"
else 
echo "Not Palindrome"
fi


#!/bin/bash
# Palindrome Checker [cite: 11]

# echo "Enter a string:" [cite: 12]
# read input_string

# # Reverse the string
# reversed_string=$(echo "$input_string" | rev)

# if [ "$input_string" == "$reversed_string" ]; then
#     echo "Palindrome" [cite: 13]
# else
#     echo "Not Palindrome" [cite: 13]
# fi