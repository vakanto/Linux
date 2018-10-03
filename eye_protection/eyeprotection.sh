#!/bin/bash

while  [ 1!=0 ] 
do
 echo $SECONDS
 if (( $SECONDS > 2)); then
  xterm -fullscreen -e ./new_term.sh
  SECONDS=0
 fi
done
