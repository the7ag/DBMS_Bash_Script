#!/bin/bash
# Connect to Database Script

clear
echo "========================================="
echo "         Connect to Database           "
echo "========================================="

# Get database name from user
echo -n "Enter database name to connect to: "
read -r db_name

# Validate database name
if ! validate_db_name "$db_name"; then
    log_message "ERROR" "Invalid database name: $db_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Check if database exists
if ! database_exists "$db_name"; then
    echo "Database '$db_name' does not exist."
    log_message "WARNING" "Attempted to connect to non-existent database: $db_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Test connection to the database
echo "Testing connection to '$db_name'..."
result=$(run_psql_db "$db_name" "SELECT 1;")
exit_code=$?

if [ $exit_code -eq 0 ]; then
    CURRENT_DB="$db_name"
    echo "Connected to database: $CURRENT_DB"
    log_message "INFO" "Connected to database: $CURRENT_DB"
    
    # Ask if user wants to open interactive shell
    if confirm_action "Do you want to open an interactive psql shell?"; then
        echo "Opening psql shell. Type \q to exit."
        log_message "INFO" "Opening interactive psql shell for database: $CURRENT_DB"
        get_psql_shell "$CURRENT_DB"
    fi
else
    echo "Failed to connect to database. Error: $result"
    log_message "ERROR" "Failed to connect to database $db_name: $result"
fi

read -n 1 -s -r -p "Press any key to continue..."