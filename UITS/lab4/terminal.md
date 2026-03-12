labex:project/ $ mkdir
mkdir: missing operand
Try 'mkdir --help' for more information.
labex:project/ $ mkdir lab4
labex:project/ $ cd lab4
labex:lab4/ $ touch lab4.sh
labex:lab4/ $ cat > lab4.sh
read -p "Enter first variable: " A
read -p "Enter second variabl: " B
Add=$((A+B))
Sub=$((A-B))
Mul=$((A*B))
Div=$((A/B))
echo "Addition $Add"
echo "Subtraction $Sub"
echo "Multiplication $Mul"
echo "Division $Div"
labex:lab4/ $ bash lab4.sh
Enter first variable: 4
Enter second variabl: 3
Addition 7
Subtraction 1
Multiplication 12
Division 1
labex:lab4/ $ bash lab4.sh
Enter first variable: 5
Enter second variabl: 6
Addition 11
Subtraction -1
Multiplication 30
Division 0
labex:lab4/ $ bash lab4.sh
Enter first variable: 5
Enter second variabl: 4
Addition 9
Subtraction 1
Multiplication 20
Division 1
labex:lab4/ $ 

---


