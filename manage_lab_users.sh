#!/bin/bash

# Ensure sudo privileges
if [ "$EUID" -ne 0 ]; then
  echo "Please run this command with sudo."
  exit 1
fi

# Loop the menu
while true; do
  echo ""
  echo "====================================="
  echo "  Rustin Systems - Lab User Manager  "
  echo "====================================="
  echo "1. Add a new student"
  echo "2. Remove a student"
  echo "3. List current students"
  echo "4. Exit"
  read -p "Select an option (1-4): " choice

  case $choice in
    1)
      read -p "Enter the new student's username (e.g., student3): " username
      if id "$username" &>/dev/null; then
        echo "Error: User $username already exists."
      else
        # Create user with home directory bash shell and the VirtualBox group
        if useradd -m -s /bin/bash -G vboxusers "$username"; then

          # Set the default password
          echo "$username:CputLab2026!" | chpasswd

          echo "------------------------------------------------"
          echo "Success! Student '$username' has been created."
          echo "Their desktop has been cloned from the Golden Image."
          echo "Default Password: CputLab2026!"
          echo "IMPORTANT: Tell the student to open the terminal"
          echo "and type 'passwd' to change this after they log in."
          echo "------------------------------------------------"
        else
          echo "------------------------------------------------"
          echo "Error: System failed to create user '$username'."
          echo "------------------------------------------------"
        fi
      fi
      ;;
    2)
      read -p "Enter the student's username to REMOVE: " username
      if id "$username" &>/dev/null; then
        # Remove the user and their home directory
        userdel -r "$username"
        echo "Success: User $username and all their files have been deleted."
      else
        echo "Error: User $username does not exist."
      fi
      ;;
    3)
      echo "------------------------------------------------"
      echo "Current Lab Students:"
      echo "------------------------------------------------"
      # List all standard users (UID >= 1000), excluding the admin who ran the script
      count=0
      for user in $(awk -F':' '$3 >= 1000 && $3 < 60000 {print $1}' /etc/passwd); do
        if [ "$user" != "$SUDO_USER" ]; then
          echo " - $user"
          ((count++))
        fi
      done

      if [ $count -eq 0 ]; then
        echo "No students currently assigned."
      fi
      echo "------------------------------------------------"
      ;;
    4)
      echo "Exiting."
      exit 0
      ;;
    *)
      echo "Invalid option. Please select a number between 1 and 4."
      ;;
  esac
done
