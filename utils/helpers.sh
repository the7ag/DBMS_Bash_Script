#!/bin/bash

# Log message function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> logs/dbms.log
}

# Validate name (alphanumeric only)
validate_name() {
    if [[ ! "$1" =~ ^[a-zA-Z0-9_]+$ ]]; then
        echo "Invalid name. Use only alphanumeric characters and underscores."
        return 1
    fi
    return 0
}
