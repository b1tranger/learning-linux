read -p "Enter A: " A
read -p "Enter B: " B
if(($A>$B)); then
echo "$A is greater"
elif(($B>$A)); then
echo "$B is greater"
fi
