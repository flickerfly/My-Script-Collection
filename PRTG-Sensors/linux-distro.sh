#!/bin/sh
# This script is intended to output PRTG compliant information
# for a sensor to report the Linux distrobution in use.
# It is released to the public for use however desired.
# I take no responsibility for its use or misuse.
#
# Josiah Ritchie <josiah@josiahritchie.com>

# Set distro to...
if which lsb_release > /dev/null; then
  # the LSB description field, removing surrounding quotes if they exist
  distro=`lsb_release -s | sed -e 's/^\"//'  -e 's/\"$//'`
  version=`lsb_releas -r`
elif [ -a /etc/debian_version ]; then
  distro="Debian"
  version=`cat /etc/debian_version`
elif [ -a /etc/centos-release ]; then
  distro=`cat /etc/centos-release`
elif [ -a /etc/redhat-release ]; then
  distro=`cat /etc/redhat-release`
elif [ -a /etc/SUSE-release ]; then
  distro=`cat /etc/SUSE-release`
elif [ -a /proc/version ]; then
  # the output of /proc/version (messy & long)
  distro=`cat /proc/version`
fi

# Report the findings to PRTG (as output of script)
 
# Advanced PRTG type sensor output (XML)
# Needs more work before it can be usedi
#if [ -n "no error" ]; then
#<prtg>
#  <result>
#    <channel>Distribution</channel>
#    <value>$distro</value>
#  </result>
#  <result>
#     <channel>Version</channel>
#     <value>$version</value>
#  </result>
#</prtg>
#else
#<prtg>
#  <error>1</error>
#  <text>Couldn't retrieve info</text>
#</prtg>
#fi


# Standard PRTG type sensor output
if [ -n "$distro" ]; then 
  echo "0:0:$distro" 
else 
  echo "0:4:unknown"
fi

# Standard PRTG SSH Sensors look for this output
# (Details are at https://your.prtgserver.com/api.htm?tabid=7)
#
# returncode:value:message
#
# This chart shows the valid return codes.
#
# Value	Description
# 0	OK
# 1	WARNING
# 2	System Error (e.g. a network/socket error)
# 3	Protocol Error (e.g. web server returns a 404)
# 4	Content Error (e.g. a web page does not contain a required word)

