# PostgreSQL Bash DBMS

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg)

A powerful, interactive command-line Database Management System for PostgreSQL built entirely in Bash. This tool provides a user-friendly interface to manage PostgreSQL databases and tables without writing raw SQL commands.

## 🌟 Features

- **Interactive Menu Interface**: Navigate through database operations with ease
- **Complete Database Management**: Create, list, connect to, and drop databases
- **Comprehensive Table Operations**: Create tables, insert records, query data, update and delete records
- **Robust Error Handling**: Input validation and error management to prevent mistakes
- **Detailed Logging**: All operations are logged for monitoring and debugging
- **SQL Preview**: See the generated SQL before executing operations
- **Interactive psql Shell**: Open a direct psql connection when needed

## 📋 Requirements

- PostgreSQL server (installed and running)
- PostgreSQL client (psql)
- Bash shell (version 4.0 or later)

## 🚀 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/the7ag/DBMS_Bash_Script.git
   ```

2. Navigate to the project directory:
   ```bash
   cd DBMS_Bash_Script
   ```

3. Make the main script executable:
   ```bash
   chmod +x dbms.sh
   ```

4. Update configuration settings:
   ```bash
   nano config.sh
   ```
   Edit the PostgreSQL connection details to match your environment.

## 💻 Usage

Start the application by running:
```bash
./dbms.sh
```

### Main Menu Options:
1. **Database Operations**: Manage your PostgreSQL databases
2. **Table Operations**: Work with tables in the connected database
3. **View Logs**: Check the most recent log entries
4. **Exit**: Close the application

## 📁 Project Structure

```
bash-dbms/
│── dbms.sh                 # Main entry point script
│── config.sh               # Configuration settings
│── utils/                  # Utility scripts
│   ├── helpers.sh          # Helper functions
│── database/               # Database operation scripts
│   ├── create_db.sh        # Create new database
│   ├── list_db.sh          # List all databases
│   ├── drop_db.sh          # Delete a database
│   ├── connect_db.sh       # Connect to a database
│── tables/                 # Table operation scripts
│   ├── create_table.sh     # Create new table
│   ├── insert_record.sh    # Insert data into table
│   ├── select_records.sh   # Query data from table
│   ├── update_record.sh    # Update existing records
│   ├── delete_record.sh    # Delete records from table
│── logs/                   # Log files
│   ├── dbms.log            # Operation logs
```

## 🔒 Security

- Input validation to prevent SQL injection
- Command sanitization
- Confirmation prompts for destructive operations

## 🛠️ Advanced Usage

### Customizing SQL Execution

Each operation script generates SQL commands based on user input. Before execution, the SQL is displayed for review, giving you the opportunity to understand the operations being performed.

### Logging System

All operations are logged to `logs/dbms.log` with timestamps and severity levels. This helps track changes and troubleshoot issues.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgements

- The PostgreSQL community
- Bash scripting enthusiasts
- Everyone who contributed to this project

---

Made with ❤️ by Mohamed Ali
