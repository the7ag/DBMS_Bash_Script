#!/bin/bash
source utils/helpers.sh

if [ -z "$CURRENT_DB" ]; then
    echo "No database selected. Connect to a database first."
    exit 1
fi

read -p "Enter table name: " table_name
read -p "Enter column name for condition: " column
read -p "Enter value to match: " value

psql -d "$CURRENT_DB" -c "DELETE FROM $table_name WHERE $column='$value';"
echo "Record deleted."
log_message "Deleted record from $table_name in $CURRENT_DB"
