#!/bin/bash

mkdir -p scripts logs data backup

touch logs/{add.log,delete.log,monitor.log,backup.log}
touch data/employees.csv

echo "Project directories initialized."            
