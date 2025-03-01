#!/bin/bash
# Configuration Settings for the DBMS

# PostgreSQL connection details
PG_HOST="localhost"
PG_PORT="5432"
PG_USER="postgres"
PG_PASSWORD="1234567"  
PG_SUPERUSER="postgres"

# Script settings
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/dbms.log"

# Ensure log directory exists
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

# Set permissions on log file
chmod 644 "$LOG_FILE"

# Global variable to track currently connected database
CURRENT_DB=""

# PSQL Command Base with common options
PSQL_CMD="psql"
PSQL_OPTS="-h $PG_HOST -p $PG_PORT"

# Function to execute psql commands as superuser
run_psql_super() {
    PGPASSWORD="$PG_PASSWORD" $PSQL_CMD $PSQL_OPTS -U "$PG_SUPERUSER" -c "$1"
    return $?
}

# Function to execute psql commands on a specific database
run_psql_db() {
    local db="$1"
    local cmd="$2"
    PGPASSWORD="$PG_PASSWORD" $PSQL_CMD $PSQL_OPTS -U "$PG_USER" -d "$db" -c "$cmd"
    return $?
}

# Function to get interactive psql shell on a database
get_psql_shell() {
    local db="$1"
    PGPASSWORD="$PG_PASSWORD" $PSQL_CMD $PSQL_OPTS -U "$PG_USER" -d "$db"
    return $?
}