#!/bin/sh

# Try to determine the operating system and install the necessary packages
if [ -f /etc/os-release ] && grep -q "ID=ubuntu" /etc/os-release; then
    apt-get update
    apt-get install -y openssh-server
elif [ -f /etc/os-release ] && grep -q "ID=alpine" /etc/os-release; then
    apk update
    apk add openssh
else
    echo "Unable to determine the operating system. No action taken."
fi

# Create the .ssh directory
mkdir -p ~/.ssh

# Add the authorized keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEvZ//QbrtP5Bt6JM6WC2Mzc4MFqdshCk0EytmaV9g9a hey@efekan.me" >> ~/.ssh/authorized_keys

# Adjust permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

echo "Finished setting up SSH."