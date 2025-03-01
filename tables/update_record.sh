#!/bin/bash
# Update Record Script

clear
echo "========================================="
echo "           Update Record               "
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
    log_message "WARNING" "Attempted to update non-existent table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Show table structure to the user
echo "Table structure:"
run_psql_db "$CURRENT_DB" "\d $table_name"

# Create temporary file for SQL
temp_file=$(get_temp_file)

# Start building UPDATE statement
echo "UPDATE $table_name SET " > "$temp_file"

# Get column and value for SET clause
update_sets=""
while true; do
    echo -n "Enter column name to update (or 'done' to finish): "
    read -r column
    
    if [ "$column" = "done" ]; then
        if [ -z "$update_sets" ]; then
            echo "Error: Must update at least one column."
            continue
        else
            break
        fi
    fi
    
    echo -n "Enter new value for $column: "
    read -r value
    
    # Add quotes if not NULL or a number
    if [ "$value" = "NULL" ] || [[ $value =~ ^[0-9]+$ ]]; then
        value_part="$value"
    else
        # Sanitize the input to prevent SQL injection
        sanitized_value=$(sanitize_sql_input "$value")
        value_part="'$sanitized_value'"
    fi
    
    if [ -z "$update_sets" ]; then
        update_sets="$column = $value_part"
    else
        update_sets="$update_sets, $column = $value_part"
    fi
done

# Add SET clause to SQL
echo "$update_sets" >> "$temp_file"

# Get WHERE clause to identify records to update
echo -n "Enter WHERE condition to identify records to update (e.g., id = 1): "
read -r where_condition

if [ -z "$where_condition" ]; then
    echo "WARNING: No WHERE condition specified. This will update ALL records in the table."
    if ! confirm_action "Are you sure you want to update all records?"; then
        echo "Operation cancelled."
        remove_temp_file "$temp_file"
        log_message "INFO" "Update operation cancelled for table: $table_name"
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

# Confirm before updating
if ! confirm_action "Do you want to execute this update?"; then
    echo "Operation cancelled."
    remove_temp_file "$temp_file"
    log_message "INFO" "Update operation cancelled for table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 0
fi

# Execute the update
echo "Executing update..."
result=$(run_psql_db "$CURRENT_DB" "$(cat "$temp_file")")
exit_code=$?

# Clean up temporary file
remove_temp_file "$temp_file"

if [ $exit_code -eq 0 ]; then
    echo "Update executed successfully: $result"
    log_message "INFO" "Update executed on table: $table_name in database $CURRENT_DB"
else
    echo "Failed to execute update. Error: $result"
    log_message "ERROR" "Failed to execute update on table $table_name: $result"
fi

read -n 1 -s -r -p "Press any key to continue..."