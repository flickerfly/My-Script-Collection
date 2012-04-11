#!/bin/sh
# based on Jay Rishel's getip script (@jrishel rishel.org)

IFCONFIG_PATH=/sbin

$IFCONFIG_PATH/ifconfig $1 |grep -E "inet6 addr" |awk '{print $3}'
