#!/bin/bash

while true; do
  echo ""
  echo "Employee Management Menu"
  echo "1. Add Employee"
  echo "2. Edit Employee"
  echo "3. Delete Employee"
  echo "4. Monitor System"
  echo "5. Backup Employee File"
  echo "6. Exit"
  read -p "Enter your choice: " choice

  case $choice in
    1) sudo bash scripts/add_employee.sh ;;
    2) bash scripts/edit_employee.sh ;;
    3) sudo bash scripts/delete_employee.sh ;;
    4) bash scripts/monitor.sh ;;
    5) bash scripts/backup.sh ;;
    6) echo "Goodbye!"; exit ;;
    *) echo "Invalid option." ;;
  esac
done

