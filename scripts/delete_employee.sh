!/bin/bash

DATA_FILE="../data/employees.csv"
LOG_FILE="../logs/delete.log"
BACKUP_DIR="../backup"

# Ensure directories exist
mkdir -p ../data ../logs ../backup
touch "$DATA_FILE" "$LOG_FILE"

# Ensure run as root
if [[ $EUID -ne 0 ]]; then
  echo " Please run with sudo."
  exit 1
fi

read -p "Enter Username to delete: " username
[[ -z "$username" ]] && echo " Username required." && exit 1

# Check if user exists
if ! id "$username" &>/dev/null; then
  echo "User '$username' does not exist."
  exit 1
fi

# Backup home directory if exists
home_dir="/home/$username"
if [[ -d "$home_dir" ]]; then
  tar -czf "$BACKUP_DIR/${username}_$(date +%F).tar.gz" -C / "home/$username"
  echo " Home directory backed up."
fi

# Delete user
userdel -r "$username"
if [[ $? -ne 0 ]]; then
  echo " Failed to delete user."
  exit 1
fi

# Remove from CSV
sed -i "/,$username,/d" "$DATA_FILE"

# Log deletion
echo "$(date):  Deleted user '$username'" >> "$LOG_FILE"

echo " User '$username' deleted successfully."

