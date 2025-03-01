#!/bin/bash
# Create Database Script

clear
echo "========================================="
echo "          Create New Database           "
echo "========================================="

# Get database name from user
echo -n "Enter database name: "
read -r db_name

# Validate database name
if ! validate_db_name "$db_name"; then
    log_message "ERROR" "Invalid database name: $db_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Check if database already exists
if database_exists "$db_name"; then
    echo "Database '$db_name' already exists."
    log_message "WARNING" "Attempted to create existing database: $db_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Create the database
echo "Creating database '$db_name'..."
result=$(run_psql_super "CREATE DATABASE $db_name;")
exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "Database '$db_name' created successfully."
    log_message "INFO" "Database created: $db_name"
    
    # Ask if user wants to connect to the new database
    if confirm_action "Do you want to connect to the new database?"; then
        CURRENT_DB="$db_name"
        echo "Connected to database: $CURRENT_DB"
        log_message "INFO" "Connected to database: $CURRENT_DB"
    fi
else
    echo "Failed to create database. Error: $result"
    log_message "ERROR" "Failed to create database $db_name: $result"
fi

read -n 1 -s -r -p "Press any key to continue..."