#!/bin/bash
source config.sh
source utils/helpers.sh

read -p "Enter database name to connect: " db_name

if psql -lqt | cut -d \| -f 1 | grep -qw "$db_name"; then
    echo "Connected to database '$db_name'."
    log_message "Connected to database: $db_name"
    export CURRENT_DB="$db_name"
    source tables/table_menu.sh
else
    echo "Database not found."
fi
