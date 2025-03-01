#!/bin/bash
# Select Records Script

clear
echo "========================================="
echo "           Select Records              "
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
    log_message "WARNING" "Attempted to select from non-existent table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 1
fi

# Create temporary file for SQL
temp_file=$(get_temp_file)

# Start building SELECT statement
echo "SELECT " > "$temp_file"

# Get columns to select
echo -n "Enter column names separated by commas (or '*' for all columns): "
read -r columns
echo "$columns" >> "$temp_file"

# Add FROM clause
echo "FROM $table_name" >> "$temp_file"

# Ask for WHERE clause
echo -n "Add WHERE clause? (y/n): "
read -r add_where
if [[ $add_where =~ ^[Yy]$ ]]; then
    echo -n "Enter WHERE condition (e.g., id = 1): "
    read -r where_condition
    echo "WHERE $where_condition" >> "$temp_file"
fi

# Ask for ORDER BY clause
echo -n "Add ORDER BY clause? (y/n): "
read -r add_order
if [[ $add_order =~ ^[Yy]$ ]]; then
    echo -n "Enter ORDER BY column and direction (e.g., id DESC): "
    read -r order_by
    echo "ORDER BY $order_by" >> "$temp_file"
fi

# Ask for LIMIT clause
echo -n "Add LIMIT clause? (y/n): "
read -r add_limit
if [[ $add_limit =~ ^[Yy]$ ]]; then
    echo -n "Enter LIMIT value: "
    read -r limit_value
    echo "LIMIT $limit_value" >> "$temp_file"
fi

# Add semicolon to end statement
echo ";" >> "$temp_file"

# Display SQL to user
echo "SQL to be executed:"
cat "$temp_file"

# Confirm before selecting
if ! confirm_action "Do you want to execute this query?"; then
    echo "Operation cancelled."
    remove_temp_file "$temp_file"
    log_message "INFO" "Select query cancelled for table: $table_name"
    read -n 1 -s -r -p "Press any key to continue..."
    exit 0
fi

# Execute the query
echo "Executing query..."
result=$(run_psql_db "$CURRENT_DB" "$(cat "$temp_file")")
exit_code=$?

# Clean up temporary file
remove_temp_file "$temp_file"

if [ $exit_code -eq 0 ]; then
    echo "Query executed successfully:"
    echo "$result" | format_sql_results
    log_message "INFO" "Select query executed on table: $table_name in database $CURRENT_DB"
else
    echo "Failed to execute query. Error: $result"
    log_message "ERROR" "Failed to execute select query on table $table_name: $result"
fi

read -n 1 -s -r -p "Press any key to continue..."