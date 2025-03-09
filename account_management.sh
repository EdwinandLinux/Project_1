#!/bin/bash

USER=$1
ACTION=$2
BACKUP_DIR="/backup/home/"
#TIMESTAMP=$(data +%Y-%m-%d_%H-%M-%S)
# Check if both arguments are given at the run time
if [[ -z "$USER" || -z "$ACTION" ]]; then
    echo "Usage: $0 <username> <disable|delete>"
    exit 1
fi
# Check if the user exists and hides stdout and stderr
if ! id "$USER" &>/dev/null; then
echo "Error: User: $USER  does not exist."
exit 2
fi
# Create a backup directory if it does not exist
sudo mkdir -p "$BACKUP_DIR"
# backup user's home directory
echo "Backing up /home/$USER to $BACKUP_DIR$USER.tar.gz...."
sudo tar -cvzf "$BACKUP_DIR$USER.tar.gz" -C "/home" "$USER"
if [[ "$ACTION" == "disable" ]]; then
    echo "Disabling user '$USER'..."
    sudo usermod -L "$USER" # Lock the account
    sudo chage -E 0 "$USER" # Expire the account immediately
elif [[ "$ACTION" == "delete" ]]; then
  echo "Deleting user '$USER' while preserving home directoty"
  sudo userdel -r "$USER" # Remove user's home directory
else
  echo "Invalid action: Use 'disable' or 'delete'"
  exit 3
fi
echo "Operation completed successfully...."