#!/bin/bash
source config.sh
source utils/helpers.sh

read -p "Enter database name to drop: " db_name
validate_name "$db_name" || exit 1

if psql -lqt | cut -d \| -f 1 | grep -qw "$db_name"; then
    dropdb "$db_name"
    echo "Database '$db_name' deleted."
    log_message "Database deleted: $db_name"
else
    echo "Database not found."
fi
