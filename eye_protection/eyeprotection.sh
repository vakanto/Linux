#!/bin/bash

while  [ 1!=0 ] 
do
 sleep 1200s
 if (( $SECONDS > 1200)); then
  xterm -fullscreen -e ./new_term.sh
  SECONDS=0
 fi
done
