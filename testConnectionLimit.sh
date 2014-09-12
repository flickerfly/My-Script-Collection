#!/bin/bash
# Syntax: scriptname hostname port

ip=$1
port=$2

for i in {1..100}
do
  # do nothing just connect and exit
  echo "exit" | nc ${ip} ${port};
done
