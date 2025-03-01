#!/bin/bash
# Helper Functions for DBMS

# Log message to file with timestamp and level
log_message() {
    local level="$1"
    local message="$2"
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
}

# Check if PostgreSQL is installed and running
check_postgres_installation() {
    if ! command -v psql &> /dev/null; then
        echo "PostgreSQL client (psql) is not installed or not in PATH."
        echo "Please install PostgreSQL and try again."
        exit 1
    fi
    
    if ! pg_isready -h "$PG_HOST" -p "$PG_PORT" &> /dev/null; then
        echo "PostgreSQL server is not running at $PG_HOST:$PG_PORT."
        echo "Please start the PostgreSQL service and try again."
        exit 1
    fi
    
    log_message "INFO" "PostgreSQL installation check passed"
}

# Validate database name
validate_db_name() {
    local db_name="$1"
    # Check if name is valid (alphanumeric and underscore only, starting with letter)
    if ! [[ $db_name =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid database name. Use only letters, numbers, and underscores, starting with a letter."
        return 1
    fi
    return 0
}

# Validate table name
validate_table_name() {
    local table_name="$1"
    # Check if name is valid (alphanumeric and underscore only, starting with letter)
    if ! [[ $table_name =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
        echo "Invalid table name. Use only letters, numbers, and underscores, starting with a letter."
        return 1
    fi
    return 0
}

# Check if database exists
database_exists() {
    local db_name="$1"
    local result=$(run_psql_super "SELECT 1 FROM pg_database WHERE datname='$db_name';")
    if [[ $result == *"1 row"* ]]; then
        return 0  # Database exists
    else
        return 1  # Database does not exist
    fi
}

# Check if table exists
table_exists() {
    local table_name="$1"
    local db_name="$CURRENT_DB"
    local result=$(run_psql_db "$db_name" "SELECT 1 FROM information_schema.tables WHERE table_name='$table_name' AND table_schema='public';")
    if [[ $result == *"1 row"* ]]; then
        return 0  # Table exists
    else
        return 1  # Table does not exist
    fi
}

# Sanitize SQL input to prevent SQL injection
# Note: This is a basic sanitization and not foolproof
sanitize_sql_input() {
    local input="$1"
    # Replace single quotes with two single quotes (SQL escape)
    echo "${input//\'/\'\'}"
}

# Generate a unique temporary file
get_temp_file() {
    mktemp /tmp/dbms-XXXXXX
}

# Remove a temporary file with error checking
remove_temp_file() {
    local file="$1"
    if [ -f "$file" ]; then
        rm "$file"
    fi
}

# Confirm an action with the user
confirm_action() {
    local prompt="$1"
    echo -n "$prompt (y/n): "
    read -r answer
    if [[ $answer =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Format SQL results for better display
format_sql_results() {
    # This function could be expanded to better format results
    # Currently, it just passes through the input
    cat -
}