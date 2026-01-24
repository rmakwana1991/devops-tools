#!/bin/bash
# Maintainer: rohanmakwana09101991@gmail.com
# Automated Backup and Cleanup Script

# Configuration
SOURCE_DIR="$HOME/testdata"
BACKUP_DIR="$HOME/backups"
LOG_FILE="logs/script.log"
RETENTION_DAYS=7

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"

# Create required directories
mkdir -p "$BACKUP_DIR"
mkdir -p "$(dirname "$LOG_FILE")"

# Logging function
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log_message "Backup process started"

# Create backup
if tar -czf "$BACKUP_FILE" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"; then
    log_message "Backup created successfully: $BACKUP_FILE"
else
    log_message "Error: Failed to create backup"
    exit 1
fi

# Cleanup old backups
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -delete
log_message "Old backups cleaned up (older than $RETENTION_DAYS days)"

log_message "Backup and cleanup completed successfully"
