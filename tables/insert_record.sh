#!/bin/bash
# Insert Record Script

clear
echo "========================================="
echo "           Insert Record               "
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
    log_message "WARNING" "Attempted to insert into non-existent table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Get table column information
echo "Retrieving table structure..."
columns_result=$(run_psql_db "$CURRENT_DB" "\d $table_name")
echo "$columns_result"

# Create temporary file for SQL
temp_file=$(get_temp_file)

# Start building INSERT statement
echo "INSERT INTO $table_name (" > "$temp_file"

# Get column names
echo -n "Enter column names separated by commas (or 'all' for all columns): "
read -r column_input

if [ "$column_input" = "all" ]; then
    # Get all column names from the database
    column_list=$(run_psql_db "$CURRENT_DB" "SELECT string_agg(column_name, ',') FROM information_schema.columns WHERE table_name = '$table_name' AND table_schema = 'public';")
    # Extract just the column names from the result
    column_input=$(echo "$column_list" | grep -v "string_agg" | grep -v "\-\-\-\-" | grep -v "^$" | tr -d ' ')
fi

# Add columns to SQL
echo "$column_input" >> "$temp_file"
echo ") VALUES (" >> "$temp_file"

# Get values for each column
IFS=',' read -ra COLUMNS <<< "$column_input"
values=""

for column in "${COLUMNS[@]}"; do
    column=$(echo "$column" | tr -d ' ')  # Remove any spaces
    echo -n "Enter value for $column: "
    read -r value
    
    # Add quotes if not NULL or a number
    if [ "$value" = "NULL" ] || [[ $value =~ ^[0-9]+$ ]]; then
        value_part="$value"
    else
        # Sanitize the input to prevent SQL injection
        sanitized_value=$(sanitize_sql_input "$value")
        value_part="'$sanitized_value'"
    fi
    
    if [ -z "$values" ]; then
        values="$value_part"
    else
        values="$values, $value_part"
    fi
done

# Add values to SQL
echo "$values" >> "$temp_file"
echo ");" >> "$temp_file"

# Display SQL to user
echo "SQL to be executed:"
cat "$temp_file"

# Confirm before inserting
if ! confirm_action "Do you want to insert this record?"; then
    echo "Operation cancelled."
    remove_temp_file "$temp_file"
    log_message "INFO" "Record insertion cancelled for table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 0
fi

# Insert the record
echo "Inserting record into '$table_name'..."
result=$(run_psql_db "$CURRENT_DB" "$(cat "$temp_file")")
exit_code=$?

# Clean up temporary file
remove_temp_file "$temp_file"

if [ $exit_code -eq 0 ]; then
    echo "Record inserted successfully."
    log_message "INFO" "Record inserted into table: $table_name in database $CURRENT_DB"
else
    echo "Failed to insert record. Error: $result"
    log_message "ERROR" "Failed to insert record into table $table_name: $result"
fi

read -n 1 -s -r -p "Press any key to continue..."