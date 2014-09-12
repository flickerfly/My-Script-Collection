#!/bin/sh

host=$1
user=$2

echo $user@$host

# Make directory as root user on remote system and give admin user permission
ssh -t $user@$host "sudo mkdir -p /var/prtg/scripts && sudo chown $user /var/prtg/scripts"

# Copy over relevant scripts
scp ./*.sh $user@$host:/var/prtg/scripts
