#!/bin/bash
function exitFunction  
{
	echo "Exit Code 0"
}
trap exitFunction 0

function stop
{
	echo "stopped"
	exit 0	
}
trap stop INT QUIT TERM

while true
do
	echo "This is a test"
	sleep 2
done

exit 0
