!/bin/bash

EMP_FILE="../data/employees.csv"
LOG_FILE="../logs/edit.log"

# Check if run with sudo
if [[ $EUID -ne 0 ]]; then
  echo "Please run with sudo."
  exit 1
fi

read -p "Enter Username to edit: " username
if ! id "$username" &>/dev/null; then
  echo "User '$username' does not exist."
  exit 1
fi

# Get line from CSV
record=$(grep ",$username," "$EMP_FILE")
if [[ -z "$record" ]]; then
  echo "User not found in employee file."
  exit 1
fi

IFS=',' read -r id dept name  user home <<< "$record"

echo "Current Name: $name"
read -p "Enter New Name (or press Enter to keep): " new_name
new_name=${new_name:-$name}

echo "Current Department: $dept"
read -p "Enter New Department (or press Enter to keep): " new_dept
new_dept=${new_dept:-$dept}

# Optionally update secondary group
if ! getent group "$new_dept" &>/dev/null; then
  groupadd "$new_dept"
fi

usermod -aG "$new_dept" "$username"

# Optionally reset password
read -p "Do you want to reset password? (y/n): " reset
if [[ "$reset" == "y" ]]; then
  passwd "$username"
fi

# Update CSV
temp_file=$(mktemp)
while IFS= read -r line; do
  if [[ "$line" == *",$username,"* ]]; then
    echo "$id,$new_name,$new_dept,$username,$home" >> "$temp_file"
  else
    echo "$line" >> "$temp_file"
  fi
done < "$EMP_FILE"
mv "$temp_file" "$EMP_FILE"

# Log
echo "$(date):  Updated user '$username': name='$new_name', dept='$new_dept'" >> "$LOG_FILE"

echo " User '$username' updated successfully."

