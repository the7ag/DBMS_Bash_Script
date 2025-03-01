#!/bin/bash
# Drop Database Script

clear
echo "========================================="
echo "           Drop Database               "
echo "========================================="

# Get database name from user
echo -n "Enter database name to drop: "
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
    log_message "WARNING" "Attempted to drop non-existent database: $db_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Confirm before dropping
if ! confirm_action "Are you sure you want to drop database '$db_name'? This action cannot be undone."; then
    echo "Operation cancelled."
    log_message "INFO" "Database drop cancelled for: $db_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 0
fi

# Drop the database
echo "Dropping database '$db_name'..."

# If we're connected to this database, disconnect first
if [ "$CURRENT_DB" = "$db_name" ]; then
    CURRENT_DB=""
    log_message "INFO" "Disconnected from database: $db_name"
fi

result=$(run_psql_super "DROP DATABASE $db_name;")
exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "Database '$db_name' dropped successfully."
    log_message "INFO" "Database dropped: $db_name"
else
    echo "Failed to drop database. Error: $result"
    log_message "ERROR" "Failed to drop database $db_name: $result"
fi

read -n 1 -s -r -p "Press any key to continue..."