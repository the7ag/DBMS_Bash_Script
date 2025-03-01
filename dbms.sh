#!/bin/bash

# Load configurations and utilities
source config.sh
source utils/helpers.sh

# Main Menu Function
main_menu() {
    while true; do
        clear
        echo "=============================="
        echo "  Bash DBMS - Main Menu"
        echo "=============================="
        echo "1) Create Database"
        echo "2) List Databases"
        echo "3) Drop Database"
        echo "4) Connect to Database"
        echo "5) Exit"
        echo "=============================="
        read -p "Enter your choice: " choice

        case $choice in
            1) source database/create_db.sh ;;
            2) source database/list_db.sh ;;
            3) source database/drop_db.sh ;;
            4) source database/connect_db.sh ;;
            5) echo "Exiting..."; exit 0 ;;
            *) echo "Invalid option. Please try again." ;;
        esac
    done
}

# Start the program
main_menu
