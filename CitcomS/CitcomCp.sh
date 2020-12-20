#!/bin/bash
#Program:
#				copy CitcomS output from server.
#Usage:
#./th_cp.sh $casename
#History:
#2017/03/10 	lhy		First release
#2017/03/16   lhy   Rewrite using rsync
#2018/03/09 	lhy		2.0 edition
#usage ./thisfile servername casename project

if [[ ! $# == 3 ]]; then
		echo "Usage: ./thisfile servername casename project"
		exit
fi

#load parameters
#source "$usrbin/CitcomS/config"

shdir=$( dirname $0 )

source "$shdir/../source_d/server"
source "$shdir/../source_d/CitcomS_env"

dir="${1}dir"
file="$shdir/../profile/CitcomS_file_name"

#get filetype from file_list
while read line; do
		echo "rsync -avur ${!1}:${!dir}/$2/*$line* ${!3}/$2/" #standard dynamically name parameter
		rsync -avur "${!1}:${!dir}/$2/*$line*" "${!3}/$2/"
done < $file
