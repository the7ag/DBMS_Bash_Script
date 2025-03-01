#!/bin/bash
source utils/helpers.sh

if [ -z "$CURRENT_DB" ]; then
    echo "No database selected. Connect to a database first."
    exit 1
fi

read -p "Enter table name: " table_name
read -p "Enter column name: " column
read -p "Enter old value: " old_value
read -p "Enter new value: " new_value

psql -d "$CURRENT_DB" -c "UPDATE $table_name SET $column='$new_value' WHERE $column='$old_value';"
echo "Record updated."
log_message "Updated record in $table_name in $CURRENT_DB"
