#!/bin/bash
# created to make a task list of html files that I was moving to php

for FILE in $( ls -1 *.html|awk -F . '{print $1}' ); do
  EXT1="html"
  EXT2="php"
  echo $FILE"."$EXT1","$FILE"."$EXT2 >> ../moved.csv
done
