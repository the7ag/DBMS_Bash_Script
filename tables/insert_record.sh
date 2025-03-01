#!/bin/bash
source utils/helpers.sh

if [ -z "$CURRENT_DB" ]; then
    echo "No database selected. Connect to a database first."
    exit 1
fi

read -p "Enter table name: " table_name
read -p "Enter column names (comma-separated): " columns
read -p "Enter values (comma-separated, matching columns): " values

psql -d "$CURRENT_DB" -c "INSERT INTO $table_name ($columns) VALUES ($values);"
echo "Record inserted successfully."
log_message "Inserted record into $table_name in $CURRENT_DB"
