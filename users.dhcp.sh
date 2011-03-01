#!/bin/bash
# Depends on dhcp.awk in the scripts directory
gawk -f ~/bin/scripts/dhcp.awk /var/lib/dhcp/dhcpd.leases|column -t|sort|uniq -w 28|sort -r -k 6

# Previous works
#cat /var/lib/dhcp/dhcpd.leases|tr -d "\n"|tr "}" "\n"|tr -d "\""|tr -d ";"|grep -v '^#'|gawk '{print $25 " " $21 " " $2}'|sort -u|nl
#or more accurate, but less pretty...
#cat /var/lib/dhcp/dhcpd.leases|tr -d "\n"|tr "}" "\n"|tr -d "\""|tr -d ";"|grep -v '^#'|sort -u|gawk '{print $25 " ";{if ($21=="client-hostname"){print $22;exit}print $21;}; print " " $2}'


# Format I'm trying to pull data from... (several of these in one file)
# I want to grab the IP, client-hostname, and MAC and sort in this order
# hostname: IP = MAC

### Possible Improvements: 
#   A 	: report only the latest unique IP of the hostname. Currently is doable by piping to grep with 
#	some options, I think.
#   B	: put in a switch to turn on or off MAC address reporting
#   C   : switch to output in an HTML table

#lease 10.0.11.147 {
#  starts 4 2004/07/29 19:37:19;
#  ends 4 2004/07/29 19:47:19;
#  binding state active;
#  next binding state free;
#  hardware ethernet 00:90:4b:b0:04:f4;
#  uid "\001\000\220K\260\004\364";
#  client-hostname "DWK";
#}

# Research: 

# This Command prints out the IP addresses in the file, one per line
# cat /var/lib/dhcp/dhcpd.leases|gawk '/^lease/{print $2}'

# prints out the client name, but surrounds it with quotes and appends
# a semi-colon on the end.
# cat /var/lib/dhcp/dhcpd.leases|gawk '/^  client/{print $2}'

# prints out MAC, but appends a semi-colon
# cat /var/lib/dhcp/dhcpd.leases|gawk '/^  hardware/{print $3}'

# removes all the new lines; puts in a new line replacing the closing '}'
# of the block. Then removes all quotes and semicolons to clean things up 
# a touch for further processing
# cat /var/lib/dhcp/dhcpd.leases|tr -d "\n"|tr "}" "\n"|tr -d "\""|tr -d ";"

### Idea 1 ###
# I could hack together a counter that keeps track of which instance of ^lease we're on
# and counts to that before then dumping the next available MAC and client on the screen.
# This would need a sanity check on the client to make sure that it doesn't pass the next
# instance of ^lease before handing off the value because some blocks don't have a 
# client-hostname value.

### Idea 2 ###
# Find a prog that allows me to only print a certain set of lines, then evaluate only 9 lines
# of the file at a time and increment a value to keep track of the last first line read to 
# and increment that to find the next block. Major problem w/ this is that some blocks only
# have 8 lines in them.

### Idea 3 ### Currently my ideal solution:
# Figure out how to concate together the lines being printed into a new file, starting the line
# with the '^lease' and ending with '}', then evaluate on a line by line basis using awk to 
# print out the values to a variable and printing the variable as desired.

# Frank Bax suggests using tr/sed to remove all /n and then put them back in after each '}'
# Which would provide line for each entry we want. First we'd need to 'grep -v ^#' the 
# file to remove the comments at the beginning.

### Awk script written by Robert W. ### Saved to /root/bin/dhcp.awk

##===== BEGIN SCRIPT =====
#
## Extract the client's IP address...
#/lease / { ip = $2 }
#
## Extract the client's hostname...
#/client-hostname / { host = $2; gsub("[;\"]", "", host) }
#
## Extract the ethernet MAC address...
#/hardware ethernet / { mac = $3; gsub(";", "", mac) }
#
## At the end of each "lease" record, print the network information.
#/\}/ { print ip ": " host " = " mac }
#
##===== END SCRIPT =====
