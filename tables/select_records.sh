#!/bin/bash

if [ -z "$CURRENT_DB" ]; then
    echo "No database selected. Connect to a database first."
    exit 1
fi

read -p "Enter table name: " table_name

psql -d "$CURRENT_DB" -c "SELECT * FROM $table_name;"
