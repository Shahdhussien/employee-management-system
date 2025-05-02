#!/bin/bash

# Define paths
EMP_FILE="../data/employees.csv"
LOG_FILE="../logs/add.log"

# Check if run with sudo
if [[ $EUID -ne 0 ]]; then
  echo " Please run this script with sudo."
  exit 1
fi

# Read and validate inputs
read -p "Enter Employee Name: " name
[[ -z "$name" ]] && echo " Name cannot be empty." && exit 1

read -p "Enter Department (used as group name): " dept
[[ -z "$dept" ]] && echo " Department cannot be empty." && exit 1

read -p "Enter Username: " username
[[ -z "$username" ]] && echo " Username cannot be empty." && exit 1

# Check if user already exists
if id "$username" &>/dev/null; then
  echo " User '$username' already exists."
  exit 1
fi

# Create group if it doesn't exist
if ! getent group "$dept" > /dev/null; then
  groupadd "$dept"
  echo " Created group '$dept'."
fi

# Create user and assign to department group as secondary group
useradd -m -G "$dept" "$username"
if [[ $? -ne 0 ]]; then
  echo " Failed to create user '$username'."
  exit 1
fi

# Set password
echo "Set password for $username:"
passwd "$username"
if [[ $? -ne 0 ]]; then
  echo " Failed to set password."
  userdel -r "$username"
  exit 1
fi

# Secure home directory
chmod 700 /home/"$username"

# Save to CSV (no ID)
echo "$name,$dept,$username,/home/$username" >> "$EMP_FILE"

# Log action
echo "$(date):  Added employee '$username' | Department: $dept" >> "$LOG_FILE"

echo " Employee '$username' added and added to group '$dept'."

