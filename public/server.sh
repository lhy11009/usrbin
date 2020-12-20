#!/bin/bash
#lhy 20180308
#connect server
#server name: p300, gd1, gd2
#usage ./this_file + server name

shdir=$( dirname $0 ) #standard get location
src_server="$shdir/../source_d/server"

if [ ! $# == 1 ]; then
	echo "usage: ./this_file + server name"
	exit
fi

source $src_server

if [ $1 == "p300" ]; then
	ssh -X $p300
elif [ $1 == "gd1" ]; then
	ssh -X $gd1
elif [ $1 == "gd1root" ]; then
	ssh -X $gd1root
elif [ $1 == "gd2" ]; then
	ssh -X $gd2
elif [ $1 == "gd2root" ]; then
	ssh -X $gd2root
elif [ $1 == "wm" ]; then
	ssh -X $wm
elif [ $1 == "peloton" ]; then
	ssh -X $peloton
elif [ $1 == "ymir" ]; then
	ssh -X $ymir
else
	echo "wrong server name"
	exit
fi



