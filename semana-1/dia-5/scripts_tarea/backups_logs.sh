#!/bin/bash

USER_HOME="$HOME"
BACKUP_DIR="$USER_HOME/backups"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/logs_$TIMESTAMP.tar.gz" /var/log

find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7 -delete
