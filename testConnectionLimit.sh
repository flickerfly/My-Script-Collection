#!/bin/bash
# Syntax: scriptname hostname port

ip=$1
port=$2

for ((i=1; i<=100; i++))
do
  # do nothing just connect and exit
  echo "exit" | nc ${ip} ${port};
done
