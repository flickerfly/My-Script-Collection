#!/bin/sh

sudo grep "`date "+%b %d"`" /var/log/yum.log | awk '{print $5}' | tr "\n$" ' ' > `date "+%d%b"`.yum
