#!/bin/bash
# create a background image from charts published in a Google Spreadsheet
# requires ImageMagick (provides convert and compose)
# requires a charts.cfg which defines the location of the charts

### set variables
CONFIG_FILE=charts.cfg
TEMP=/tmp/$0 #directory to use for building the background, no trailing $
DIR=~ #directory to store background file, no trailing /
background=white #same color as chart backgrounds so they look somewhat uniform
size=1360x768 #set to resolution of monitor

### define chart locations (go to chart and publish as image to find this URL)
# The Config file should have three lines setting these three variables. I'm 
# extracting them so that I can share this script without sharing my graphs.
# You can get this address by publishing the chart, choosing image and copying
# the url included in the HTML.
#
# Ex.
# waterChart="https://spreadsheets.google.com/oimg?key=0AqIFAZKGGcH9dDDFLaGRLM1E&oid=4&zx=4nrwgmyn"
# electricChart="https://spreadsheets.google.com/oimg?key=0AqIFAZKGGcaGRLM1E&oid=5&zx=cgxtcul"
# mainChart="https://spreadsheets.google.com/oimg?key=0AqIFAZKGGcRLM1E&oid=2&zx=jvemqg7"

if [[ -f $CONFIG_FILE ]]; then
  . $CONFIG_FILE
fi

### download charts
wget -O $TEMP/water_chart.png -q $waterChart 
wget -O $TEMP/electric_chart.png -q $electricChart
wget -O $TEMP/main_chart.png -q $mainChart

### name the charts
waterChart=$TEMP/water_chart.png
electricChart=$TEMP/electric_chart.png
mainChart=$TEMP/main_chart.png

### make canvas
convert -size $size  xc:white $TEMP/canvas.jpg

### lay the charts on top of the canvas (geometry is x,y coords on the canvas)
composite $mainChart $TEMP/canvas.jpg $TEMP/temp1.jpg
composite -geometry +75+375 $waterChart $TEMP/temp1.jpg $TEMP/temp2.jpg
composite -geometry +535+375 $electricChart $TEMP/temp2.jpg $DIR/background.jpg

### apply the background
# TODO: This may apply to the issue where ssh and cron don't apply the change:
# http://ubuntuforums.org/archive/index.php/t-1147321.html
gconftool-2  -g /desktop/gnome/background/picture_filename background.jpg

