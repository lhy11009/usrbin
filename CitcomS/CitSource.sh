#!/bin/bash
#Program:
#				synthesize source.

if [[ ! $# == 1 ]]; then
		echo "Usage: ./thisfile servername"
		exit
fi

shdir=$( dirname $0 )   # read setting

source "$shdir/../source_d/server"
source "$shdir/../source_d/CitcomS_env"

dir="${1}source"
ldir="/home/p300/Desktop/source"

echo "rsync -avur ${!1}:${!dir}/lib $ldir/"   # synthesize
rsync -avur ${!1}:${!dir}/lib/*.c $ldir/lib/
rsync -avur ${!1}:${!dir}/lib/*.h $ldir/lib
echo "rsync -avur ${!1}:${!dir}/bin/Citcom.c $ldir/lib/Citcom.c"
rsync -avur ${!1}:${!dir}/bin/Citcom.c $ldir/Citcom.c
echo "rsync -avur $ldir/lib ${!1}:${!dir}/"
rsync -avur $ldir/lib/*.c ${!1}:${!dir}/lib/
rsync -avur $ldir/lib/*.h ${!1}:${!dir}/lib/
echo "rsync -avur $ldir/lib/Citcom.c ${!1}:${!dir}/bin/Citcom.c"
rsync -avur $ldir/Citcom.c ${!1}:${!dir}/bin/Citcom.c
