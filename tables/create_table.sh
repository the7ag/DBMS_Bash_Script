#!/bin/bash
# Create Table Script

clear
echo "========================================="
echo "           Create New Table             "
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

# Check if table already exists
if table_exists "$table_name"; then
    echo "Table '$table_name' already exists in database '$CURRENT_DB'."
    log_message "WARNING" "Attempted to create existing table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Create temporary file for SQL
temp_file=$(get_temp_file)

# Start SQL command
echo "CREATE TABLE $table_name (" > "$temp_file"

# Build columns
echo "Enter column details (enter 'done' when finished):"
column_count=0

while true; do
    echo -n "Column name (or 'done' to finish): "
    read -r column_name
    
    if [ "$column_name" = "done" ]; then
        if [ "$column_count" -eq 0 ]; then
            echo "Error: Table must have at least one column."
            continue
        else
            break
        fi
    fi
    
    # Validate column name
    if ! [[ $column_name =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid column name. Use only letters, numbers, and underscores, starting with a letter."
        continue
    fi
    
    echo -n "Data type (e.g., INTEGER, TEXT, VARCHAR, TIMESTAMP, etc.): "
    read -r data_type
    
    echo -n "Constraints (e.g., NOT NULL, PRIMARY KEY, etc.) or leave empty: "
    read -r constraints
    
    # Add column to SQL
    if [ "$column_count" -gt 0 ]; then
        echo "," >> "$temp_file"
    fi
    
    if [ -z "$constraints" ]; then
        echo "    $column_name $data_type" >> "$temp_file"
    else
        echo "    $column_name $data_type $constraints" >> "$temp_file"
    fi
    
    column_count=$((column_count + 1))
done

# Close SQL statement
echo ");" >> "$temp_file"

# Display SQL to user
echo "SQL to be executed:"
cat "$temp_file"

# Confirm before creating table
if ! confirm_action "Do you want to create this table?"; then
    echo "Operation cancelled."
    remove_temp_file "$temp_file"
    log_message "INFO" "Table creation cancelled for: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 0
fi

# Create the table
echo "Creating table '$table_name'..."
result=$(run_psql_db "$CURRENT_DB" "$(cat "$temp_file")")
exit_code=$?

# Clean up temporary file
remove_temp_file "$temp_file"

if [ $exit_code -eq 0 ]; then
    echo "Table '$table_name' created successfully."
    log_message "INFO" "Table created: $table_name in database $CURRENT_DB"
else
    echo "Failed to create table. Error: $result"
    log_message "ERROR" "Failed to create table $table_name: $result"
fi

read -n 1 -s -r -p "Press any key to continue..."