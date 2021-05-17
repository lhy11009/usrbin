#!/bin/bash
# usage
#change file name with invalid coding

find "$1" -depth -print0 | while IFS= read -r -d '' file; do #standard method to read from command line output
	d="$( dirname "$file" )"
	f="$( basename "$file" )" #standard method to get basename
	new="${f//[^a-zA-Z0-9\/\._\-]/}" #standard method to string operation: find and eliminate
	if [ "$f" != "$new" ]      # if equal, name is already clean, so leave alone
	then
#		while [ -e "$d/$new" ]
#	  do
#			echo "Notice: \"$new\" and \"$f\" both exist in "$d":"
#			new="a$new"
#			echo "Change new name to $new"
#		done		
#		echo mv "$file" "$d/$new"      # remove "echo" to actually rename things
#		mv "$file" "$d/$new"      # remove "echo" to actually rename things
		echo "rm -r $file"
		rm -r "$file"
	fi
done
