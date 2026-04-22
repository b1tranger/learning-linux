read -p "Enter ID: " id
read -p "Enter name: " name
read -p "Enter units consumed: " units

# bill=0
# sur=0

if [ $units -lt 200 ]; then
bill=$( echo "$units*1.20" | bc)
mul=1.20
elif [ $units -ge 200 ] && [ $units -lt 400 ]; then
bill=$( echo "$units*1.50" | bc)
mul=1.50
elif [ $units -ge 400 ] && [ $units -lt 600 ]; then
bill=$( echo "$units*1.80" | bc)
mul=1.80
else
bill=$( echo "$units*2.00" | bc)
mul=2.00
fi

# since min bill 100
if (( $(echo "$bill < 100" | bc ) )); then
net=100
elif (( $(echo "$bill > 400" | bc) )); then
sur=$( echo "$bill * 0.15" | bc)
net=$( echo "$bill + $sur" | bc)
fi

printf "\n\n"
echo "Customer ID no. : $id"
echo "Customer Name : $name"
echo "Units Consumed : $units"
echo "Amount Charges @$mul per unit: $bill"
echo "Surcharge Amount: $sur"
echo "Net Amount Paid by the Customer: $net"