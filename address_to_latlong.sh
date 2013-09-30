#!/bin/bash
# by Josiah Ritchie <jritchie@crosslinkgroup.com>
# 2013/Sept/24
#
# Input: Include an argument in quotes with the address to query against Google's Geocode API
#
# Returns: Latitude and Longitude
#

#Check that we received a location
if [ -z "$1" ]; then echo "Please provide an address in quotes as an argument to this command"; exit ; fi
Location=$1

#Send the query to Google's Geocode
GoogleSearchString="`echo $1 | sed 's/ /\+/g' |sed 's/[\#$?@]//g'`"
Saddress="http://maps.googleapis.com/maps/api/geocode/xml?address=\"$GoogleSearchString\"&sensor=true"
wget -O out.xml $Saddress > /dev/null 2>&1

#Determine Location's Latitude and Longitude
Latitude=`tail -n +2 out.xml |egrep -o "[-0-9]*[.][-0-9]*" |sed -n 1p`
Longitude=`tail -n +2 out.xml |egrep -o "[-0-9]*[.][-0-9]*" |sed -n 2p`

#Output results
echo "Turned ${GoogleSearchString} into coordinates of ${Latitude} and ${Longitude}"
