> I want a file structure and core function examples for a project where I want to implement an age-based browsing experience for the user. It should be able to login and show browsing history (the links that were opened from the .sh), age-verification, searching the list of links and opening the browser tab with that link. The terminal should not close yet and another option will let the user end the browser session to continue or logout from the project, which will close the .sh

This is a clever pivot! You're essentially building a **"Parental Control & Browser Hub"** inside the terminal. It’s perfect for a Linux lab because it utilizes file handling, user permissions, and process management. 

Project Structure 

text

```
browser_hub/
├── main.sh                 # Main entry point (Login & Menu)
├── users.db                # Plain text "database" (Username:Age:Password)
├── session/
│   └── current_user.tmp    # Temporary file to track who is logged in
├── logs/
│   └── history.log         # Global history (User:URL:Timestamp)
├── data/
│   └── links.txt           # curated links (Category:Min_Age:URL)
└── scripts/
    ├── auth.sh             # Login and Age-Verification logic
    ├── browser_ops.sh      # Searching and xdg-open logic
    └── logger.sh           # History recording logic
```

Use code with caution.

Copied to clipboard

Core Function Examples 

1\. Age-Verified Search & Open (`scripts/browser_ops.sh`) 

This function filters the `links.txt` based on the logged-in user's age. 

bash

```
# links.txt format: Social:13:https://facebook.com
open_link() {
    local user_age=$1
    local search_query=$2

    echo "Searching for '$search_query' available for age $user_age..."
    
    # 1. Filter by keyword and Age (Column 2 must be <= user_age)
    # 2. Use awk to show only matches the user is allowed to see
    match=$(awk -F: -v age="$user_age" -v query="$search_query" \
        '$1 ~ query && $2 <= age { print $3 }' ./data/links.txt | head -n 1)

    if [[ -n "$match" ]]; then
        echo "Opening: $match"
        xdg-open "$match"
        # Log the visit
        log_history "$USER_NAME" "$match"
    else
        echo "No restricted matches found for your age group."
    fi
}
```

Use code with caution.

Copied to clipboard

2\. The Login System (`scripts/auth.sh`) 

Verification ensures the user exists and captures their age for the session. 

bash

```
login_user() {
    read -p "Username: " uname
    read -sp "Password: " upass
    echo ""

    # Check users.db for a match (Format: user:age:pass)
    user_data=$(grep "^$uname:" ./users.db)
    
    db_pass=$(echo "$user_data" | cut -d: -f3)
    db_age=$(echo "$user_data" | cut -d: -f2)

    if [[ "$upass" == "$db_pass" && -n "$user_data" ]]; then
        echo "Welcome, $uname!"
        echo "$uname:$db_age" > ./session/current_user.tmp
        return 0
    else
        echo "Access Denied."
        return 1
    fi
}
```

Use code with caution.

Copied to clipboard

3\. Persistent Session Loop (`main.sh`) 

This keeps the terminal open while the browser is running and handles the "Logout" or "End Session" logic. 

bash

```
while true; do
    echo "--- BROWSER HUB MENU ---"
    echo "1. Search & Open Link"
    echo "2. View My History"
    echo "3. Logout & Close"
    read -p "Selection: " opt

    case $opt in
        1) 
            read -p "Search for: " query
            age=$(cut -d: -f2 ./session/current_user.tmp)
            open_link "$age" "$query"
            ;;
        2)
            uname=$(cut -d: -f1 ./session/current_user.tmp)
            grep "^$uname:" ./logs/history.log || echo "No history yet."
            ;;
        3)
            rm ./session/current_user.tmp
            echo "Session ended. Goodbye!"
            exit 0
            ;;
    esac
    echo -e "\nPress Enter to return to menu..."
    read # This keeps the menu from disappearing immediately
done
```

Use code with caution.

Copied to clipboard

Key Logic for your Lab: 

-   **Process Persistence:** The `read` command at the end of the loop is vital; it prevents the script from looping or closing until the user explicitly interacts with the terminal again after the browser opens.
-   **Data Isolation:** Using `awk` and `cut` demonstrates your ability to parse system files, which is a core skill in Linux programming. 

Would you like me to show you how to write the **`logger.sh`** so it records the exact time and date each link was opened?