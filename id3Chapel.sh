#!/bin/bash
# Takes argument for a directory to work in

if [ $# -ne 0 ]
then 
	cd $1
fi

# assumes things about name structure and pumps that into changing the id3 tags
ls -1 *.mp3 | awk -F . '{ system ("id3v2 -A \"WBC Chapels "$3"\" -a \""$4" "$5"\" -c \""$6" "$7" by "$4" "$5" on "$1"/"$2"/"$3" in "$8" format\" -t \""$6" "$7"\" -g 28 -y "$3" "$0)}'

