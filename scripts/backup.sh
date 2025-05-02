#!/bin/bash

# Define variables
SRC_FILE="../data/employees.csv"
TMP_ARCHIVE="/tmp/employees_$(date +%F).tar.gz"
REMOTE_USER=yasmin
REMOTE_HOST=192.168.1.11
REMOTE_DIR="/home/yasmin/employee_backups"
LOG_FILE="../logs/backup.log"

# Create archive
tar -czf "$TMP_ARCHIVE" -C ../data employees.csv

# Send archive via SSH
scp "$TMP_ARCHIVE" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR"

# Check if transfer was successful
if [[ $? -eq 0 ]]; then
  echo "$(date):Backup sent to $REMOTE_HOST:$REMOTE_DIR" >> "$LOG_FILE"
  echo "Backup successful."
  rm "$TMP_ARCHIVE"
else
  echo "$(date): Failed to send backup." >> "$LOG_FILE"
  echo "Backup failed."
fi

