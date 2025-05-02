#!/bin/bash

SCRIPT_DIR=$(dirname "$(realpath "$0")")
LOG_FILE="$SCRIPT_DIR/../logs/monitor.log"

# Check if log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
ram=$(free | awk '/Mem:/ {printf("%.2f", $3/$2 * 100)}')
disk=$(df / | awk 'END {print $5}' | sed 's/%//')

timestamp=$(date)

echo "$timestamp: CPU=$cpu% | RAM=$ram% | Disk=$disk%" >> "$LOG_FILE"

if (( $(echo "$cpu > 80" | bc -l) )) || (( $(echo "$ram > 80" | bc -l) )) || (( $disk > 90 )); then
  echo "$timestamp:  High resource usage!" >> "$LOG_FILE"
fi

echo " System usage logged."

