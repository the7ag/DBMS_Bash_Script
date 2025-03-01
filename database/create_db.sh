#!/bin/bash
source config.sh
source utils/helpers.sh

read -p "Enter database name: " db_name
validate_name "$db_name" || exit 1

if psql -lqt | cut -d \| -f 1 | grep -qw "$db_name"; then
    echo "Database already exists."
else
    createdb "$db_name"
    echo "Database '$db_name' created successfully."
    log_message "Database created: $db_name"
fi
