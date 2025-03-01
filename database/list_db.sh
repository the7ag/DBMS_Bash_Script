#!/bin/bash
# List Databases Script

clear
echo "========================================="
echo "           Database List                "
echo "========================================="

# Get list of databases
echo "Retrieving list of databases..."
result=$(run_psql_super "\l")
exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo "$result" | format_sql_results
    log_message "INFO" "Listed databases successfully"
else
    echo "Failed to retrieve database list. Error: $result"
    log_message "ERROR" "Failed to list databases: $result"
fi

echo ""
read -n 1 -s -r -p "Press any key to continue..."