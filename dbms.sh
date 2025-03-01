#!/bin/bash
# Main DBMS Script - Entry point for the database management system

# Source configuration and helper scripts
source "$(dirname "$0")/config.sh"
source "$(dirname "$0")/utils/helpers.sh"

# Function to display the main menu
display_menu() {
    clear
    echo "========================================"
    echo "      PostgreSQL Database Manager       "
    echo "========================================"
    echo "1. Database Operations"
    echo "2. Table Operations"
    echo "3. View Logs"
    echo "4. Exit"
    echo "========================================"
    echo -n "Enter your choice [1-4]: "
}

# Function to display database operations menu
display_db_menu() {
    clear
    echo "========================================"
    echo "        Database Operations Menu        "
    echo "========================================"
    echo "1. Create Database"
    echo "2. List Databases"
    echo "3. Drop Database"
    echo "4. Connect to Database"
    echo "5. Return to Main Menu"
    echo "========================================"
    echo -n "Enter your choice [1-5]: "
}

# Function to display table operations menu
display_table_menu() {
    clear
    echo "========================================"
    echo "         Table Operations Menu          "
    echo "========================================"
    echo "1. Create Table"
    echo "2. Insert Record"
    echo "3. Select Records"
    echo "4. Update Record"
    echo "5. Delete Record"
    echo "6. Return to Main Menu"
    echo "========================================"
    echo -n "Enter your choice [1-6]: "
}

# Handle database operations
handle_db_operations() {
    while true; do
        display_db_menu
        read -r choice

        case $choice in
            1) source "$(dirname "$0")/database/create_db.sh" ;;
            2) source "$(dirname "$0")/database/list_db.sh" ;;
            3) source "$(dirname "$0")/database/drop_db.sh" ;;
            4) source "$(dirname "$0")/database/connect_db.sh" ;;
            5) return ;;
            *) log_message "ERROR" "Invalid choice: $choice" 
               echo "Invalid choice. Press Enter to continue..."
               read -r ;;
        esac
    done
}

# Handle table operations
handle_table_operations() {
    if [ -z "$CURRENT_DB" ]; then
        echo "You must connect to a database first."
        log_message "WARNING" "Attempted to perform table operations without connecting to a database"
        read -n 1 -s -r -p "Press any key to continue..."
        return
    fi
    
    while true; do
        display_table_menu
        read -r choice

        case $choice in
            1) source "$(dirname "$0")/tables/create_table.sh" ;;
            2) source "$(dirname "$0")/tables/insert_record.sh" ;;
            3) source "$(dirname "$0")/tables/select_records.sh" ;;
            4) source "$(dirname "$0")/tables/update_record.sh" ;;
            5) source "$(dirname "$0")/tables/delete_record.sh" ;;
            6) return ;;
            *) log_message "ERROR" "Invalid choice: $choice"
               echo "Invalid choice. Press Enter to continue..."
               read -r ;;
        esac
    done
}

# View logs
view_logs() {
    clear
    echo "========================================"
    echo "               Log Viewer              "
    echo "========================================"
    
    if [ -f "$LOG_FILE" ]; then
        echo "Last 10 log entries:"
        tail -n 10 "$LOG_FILE"
    else
        echo "No logs found."
    fi
    
    read -n 1 -s -r -p "Press any key to continue..."
}

# Check PostgreSQL installation
check_postgres_installation

# Main program loop
while true; do
    display_menu
    read -r choice

    case $choice in
        1) handle_db_operations ;;
        2) handle_table_operations ;;
        3) view_logs ;;
        4) echo "Exiting DBMS. Goodbye!"
           log_message "INFO" "User exited the application"
           exit 0 ;;
        *) log_message "ERROR" "Invalid choice: $choice"
           echo "Invalid choice. Press Enter to continue..."
           read -r ;;
    esac
done