# Wrong
# arr = ( 1 2 3 4 ) 

# Correct
arr=(1 2 3 4)

echo " Length: ${#arr[@]}"
echo "elements: ${arr[@]}"


# Iterating over elements
for item in "${arr[@]}"; do
    echo "$item"
done
