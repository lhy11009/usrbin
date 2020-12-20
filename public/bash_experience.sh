#!/bin/bash
#usage
# renew bash experience file, reading froa history

shdir=$( dirname $0 )
source $shdir/../source_d/localinfo
bash_experience_file="$home_dir/$bash_experience_file"

while IFS= read -r line; do #standard read from file line by line
if [[ $line = *"#standard"* ]]; then #standard match string
	line=${line#* } #standard eliminate content before the first space	
	echo "$line" >> "$bash_experience_file"		
fi
done < "$1"
