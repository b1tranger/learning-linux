#!/bin/bash
# Sum of Digits [cite: 19]

# echo "Enter a positive integer:" 
# read num

# sum=0
# temp=$num

# while [ $temp -gt 0 ]
# do
#     digit=$((temp % 10))
#     sum=$((sum + digit))
#     temp=$((temp / 10))
# done

# echo "Output: $sum"

read -p "Enter a number: " A

sum=0
temp=$A 

while [ $temp -gt 0 ]
do 
digit=$((temp%10))