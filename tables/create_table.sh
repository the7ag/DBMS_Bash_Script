#!/bin/bash
source utils/helpers.sh

if [ -z "$CURRENT_DB" ]; then
    echo "No database selected. Connect to a database first."
    exit 1
fi

read -p "Enter table name: " table_name
validate_name "$table_name" || exit 1

read -p "Enter column names and types (e.g., id SERIAL PRIMARY KEY, name TEXT): " columns

psql -d "$CURRENT_DB" -c "CREATE TABLE $table_name ($columns);"
echo "Table '$table_name' created successfully."
log_message "Table created: $table_name in $CURRENT_DB"
