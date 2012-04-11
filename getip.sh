#!/bin/sh
# shared by Jay Rishel @jrishel rishel.org

IFCONFIG_PATH=/sbin

$IFCONFIG_PATH/ifconfig $1 |grep -E "addr:[0-9]" |awk '{print $2}' |colrm 1 5
