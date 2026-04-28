#!/bin/bash
# Prime Number Checker [cite: 15]

# echo "Enter a positive integer:" [cite: 16]
# read num

# if [ $num -lt 2 ]; then
#     echo "Not Prime" [cite: 17]
#     exit
# fi

# for ((i=2; i*i<=num; i++))
# do
#     if [ $((num % i)) -eq 0 ]; then
#         echo "Not Prime" [cite: 17]
#         exit
#     fi
# done

# echo "Prime" [cite: 17]

read -p "Enter number: " A

if [ $A -lt 2 ]; then
echo "Not Prime"
exit 
fi

for ((i=2;i<=$A;i++))
do
if [ $((A%i)) == 0 ]; then
echo "Not Prime"
else 
echo "Prime"
fi 
done