# 🔄 Automated Backup & Cleanup Script

A robust shell script for automated data backup and retention management, designed for production environments and daily operations.

## 🚀 Features

- **Automated Backup Creation**: Creates timestamped compressed backups using tar.gz
- **Intelligent Cleanup**: Automatically removes backups older than configurable retention period
- **Comprehensive Logging**: Detailed logging with timestamps for audit trails
- **Error Handling**: Proper exit codes and error reporting
- **Configurable Parameters**: Easy customization of source, destination, and retention settings

## 📋 Prerequisites

- Bash shell environment
- `tar` command availability
- Write permissions to backup directory
- Sufficient disk space for backups

## ⚙️ Configuration

The script uses the following default configuration:

```bash
SOURCE_DIR="$HOME/testdata"      # Directory to backup
BACKUP_DIR="$HOME/backups"       # Backup destination
LOG_FILE="logs/script.log"       # Log file location
RETENTION_DAYS=7                 # Backup retention period
```

## 🔧 Installation & Usage

1. **Clone or download the script**:
   ```bash
   wget https://raw.githubusercontent.com/yourusername/repo/main/backup_cleanup.sh
   chmod +x backup_cleanup.sh
   ```

2. **Customize configuration** (optional):
   Edit the configuration variables at the top of the script

3. **Run the script**:
   ```bash
   ./backup_cleanup.sh
   ```

4. **Schedule with cron** (recommended):
   ```bash
   # Add to crontab for daily execution at 2 AM
   0 2 * * * /path/to/backup_cleanup.sh
   ```

## 📁 Directory Structure

```
project/
├── backup_cleanup.sh          # Main script
├── logs/
│   └── script.log            # Execution logs
└── backups/
    ├── backup_2024-01-15_02-00-01.tar.gz
    ├── backup_2024-01-16_02-00-01.tar.gz
    └── ...
```

## 📊 Sample Output

```
2024-01-16 02:00:01 - Backup process started
2024-01-16 02:00:15 - Backup created successfully: /home/user/backups/backup_2024-01-16_02-00-01.tar.gz
2024-01-16 02:00:16 - Old backups cleaned up (older than 7 days)
2024-01-16 02:00:16 - Backup and cleanup completed successfully
```

## 🛡️ Error Handling

- **Directory Creation**: Automatically creates backup and log directories if they don't exist
- **Backup Validation**: Verifies backup creation success before proceeding
- **Exit Codes**: Returns appropriate exit codes for monitoring systems
- **Logging**: All operations are logged with timestamps for troubleshooting

## 🔍 Monitoring & Alerts

The script can be integrated with monitoring systems:

```bash
# Check last backup status
if [ $? -eq 0 ]; then
    echo "Backup completed successfully"
else
    echo "Backup failed - check logs"
    # Send alert notification
fi
```

## 🎯 Use Cases

- **Development Environments**: Regular code and data backups
- **Production Systems**: Automated data protection
- **CI/CD Pipelines**: Backup artifacts and configurations
- **Personal Projects**: Automated file protection

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**DevOps Engineer** | Automation Enthusiast  
📧 rohanmakwana09101991@gmail.com

---

*Part of my DevOps automation toolkit - building reliable, scalable infrastructure solutions.*