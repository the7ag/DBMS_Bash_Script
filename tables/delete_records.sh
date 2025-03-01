#!/bin/bash
# Delete Record Script

clear
echo "========================================="
echo "           Delete Record               "
echo "========================================="
echo "Current Database: $CURRENT_DB"
echo "========================================="

# Get table name from user
echo -n "Enter table name: "
read -r table_name

# Validate table name
if ! validate_table_name "$table_name"; then
    log_message "ERROR" "Invalid table name: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Check if table exists
if ! table_exists "$table_name"; then
    echo "Table '$table_name' does not exist in database '$CURRENT_DB'."
    log_message "WARNING" "Attempted to delete from non-existent table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Create temporary file for SQL
temp_file=$(get_temp_file)

# Start building DELETE statement
echo "DELETE FROM $table_name" > "$temp_file"

# Get WHERE clause to identify records to delete
echo -n "Enter WHERE condition to identify records to delete (e.g., id = 1): "
read -r where_condition

if [ -z "$where_condition" ]; then
    echo "WARNING: No WHERE condition specified. This will delete ALL records in the table."
    if ! confirm_action "Are you sure you want to delete all records?"; then
        echo "Operation cancelled."
        remove_temp_file "$temp_file"
        log_message "INFO" "Delete operation cancelled for table: $table_name"
        read -n 1 -s -r -p "Press any key to continue..."
        exit 0
    fi
else
    echo "WHERE $where_condition" >> "$temp_file"
fi

# Add semicolon to end statement
echo ";" >> "$temp_file"

# Display SQL to user
echo "SQL to be executed:"
cat "$temp_file"

# Confirm before deleting
if ! confirm_action "Do you want to execute this delete operation?"; then
    echo "Operation cancelled."
    remove_temp_file "$temp_file"
    log_message "INFO" "Delete operation cancelled for table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 0
fi

# Execute the delete
echo "Executing delete..."
result=$(run_psql_db "$CURRENT_DB" "$(cat "$temp_file")")
exit_code=$?

# Clean up temporary file
remove_temp_file "$temp_file"

if [ $exit_code -eq 0 ]; then
    echo "Delete executed successfully: $result"
    log_message "INFO" "Delete executed on table: $table_name in database $CURRENT_DB"
else
    echo "Failed to execute delete. Error: $result"
    log_message "ERROR" "Failed to execute delete on table $table_name: $result"
fi

read -n 1 -s -r -p "Press any key to continue..."