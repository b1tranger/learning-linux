



printf "\n\n\n[ Assignment: Menu-Driven bash script ]\n\n\n"

read -p "Enter First Variable: " A
read -p "Enter Second Variable: " B

n=-1

count=0

while ((n!=0))
do

if ((count==0));
then
printf "\n\n<<<<<<<<<< Available Operations >>>>>>>>>>
\n
[ 0 ] Exit\n
[ 1 ] Addition\n
[ 2 ] Subtraction\n
[ 3 ] Multiplication\n
[ 4 ] Division\n
[ 5 ] Modulus\n
[ 6 ] Check whether the two numbers are equal or not\n
[ 7 ] Determine which number is greater\n
[ 8 ] Check if both numbers are positive\n
[ 9 ] Check if at least one number is zero\n
[ 10 ] Bitwise AND\n
[ 11 ] Bitwise OR\n
[ 12 ] Bitwise XOR\n\n\t( invalid options: <0 && >12)\n\n\n"
fi

((count++))

printf "\n\n<<<<<<<<<< Input your choice >>>>>>>>>>\n\n\tINPUT --> "

read n

if (($n==1)); # [ 1 ] Addition\n
then
printf "\nAddition: %d" "$((A+B))"

elif (($n==2)); # [ 2 ] Subtraction\n
then 
printf "\nSubtraction: %d" "$((A-B))"
elif (($n==3)); # [ 3 ] Multiplication\n
then

printf "\nMultiplication: %d" "$((A*B))"
elif (($n==4)); # [ 4 ] Division\n
then

printf "\nDivision: %d" "$((A/B))"
elif (($n==5)); # [ 5 ] Modulus\n
then

printf "\nModulus: %d" "$((A%B))"
elif (($n==6)); # [ 6 ] Check whether the two numbers are equal or not\n
then
if ((A==B));
then
printf "\nEQUAL NUM"

else
printf "\nNOT EQUAL NUM"

fi

elif (($n==7)); # [ 7 ] Determine which number is greater\n
then
if ((A>B));
then
printf "\nFIRST NUM GREATER"

elif ((A<B))
then
printf "\nSECOND NUM GREATER"

else
printf "\nINVALID OPERATION"

fi


elif (($n==8)); # [ 8 ] Check if both numbers are positive\n
then
if ((A>0&&B>0));
then
printf "\nBOTH POSITIVE"

elif ((A<0))
then
printf "\nBOTH NOT POSITIVE. FIRST NEGATIVE"

elif ((B<0))
then
printf "\nBOTH NOT POSITIVE. SECOND NEGATIVE"

fi

elif (($n==9)); # [ 9 ] Check if at least one number is zero\n
then
if ((A==0||B==0));
then
printf "\nZERO IS THERE"

else
printf "\nNO ZERO HERE"

fi

elif (($n==10)); # [ 10 ] Bitwise AND\n
then
printf "\nAND: %d" "$((A&B))"

elif (($n==11)); # [ 11 ] Bitwise OR\n
then
printf "\nOR: %d" "$((A|B))"

elif (($n==12)); # [ 12 ] Bitwise XOR\n
then
printf "\nXOR: %d" "$((A^B))"

elif (($n==0)); # [ 0 ] Exit\n
then
printf "\n\n\t[ Program Terminated ]\n\n"

else
printf "\n<<<<<<<<<< INVALID CHOICE >>>>>>>>>>"

fi
done