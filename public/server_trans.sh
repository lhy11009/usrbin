#!/bin/bash
# usage:
#synchronize files between pc and workstation
#./p300_trans.sh
# extra file:
#$src_server, where address and id of workstation are stored
#$File, where directories to synchronieze are listed 
################################################################################
# Parse input parameters
shdir=$( dirname $0 )
server_name=$1
shift
method=$1
src_server="$shdir/../source_d/server"
FILE="$shdir/../profile/${server_name}_file_list"

################################################################################
# load in workstation address and id
source $src_server
echo "server: ${!server_name}"
echo "###############################"

################################################################################
# Define synchronizing functions

transfer_all(){
    # rsync everthing in the forlder
    target=$1
    addr=$2
    mode=$3
    if [ $mode -eq 0 ]; then
        flags="-avur"
    elif [ $mode -eq 1 ]; then
        flags="-avur --delete --force"
    fi
    echo "rsync ${flags} $target $addr/.."
    eval "rsync -avur ${flags} $target $addr/.."
}

default(){
    # rsync this way and rsync the other way
    name=$1
    addr=$2
    target=$3
    k=1
    while read addr && read target; do
        target="${!name}:$target"
        echo "address $k: $addr"
        echo "target $k: $target"
        echo "###################################"
	transfer_all $target $addr 0
        echo "###################################"
	transfer_all $addr $target 0
        echo "###################################"
        ((k++))
    done < $FILE
}

thisway(){
    # rsync thisway and synchronize
    name=$1
    addr=$2
    target=$3
    k=1
    while read addr && read target; do
        target="${!name}:$target"
        echo "address $k: $addr"
        echo "target $k: $target"
        echo "###################################"
	transfer_all $target $addr 1
        echo "###################################"
        ((k++))
    done < $FILE
}

thatway(){
    # rsync thatway and synchronize
    name=$1
    addr=$2
    target=$3
    k=1
    while read addr && read target; do
        target="${!name}:$target"
        echo "address $k: $addr"
        echo "target $k: $target"
        echo "###################################"
	transfer_all $addr $target 1
        echo "###################################"
        ((k++))
    done < $FILE
}

################################################################################
# rsync it
if [ $method -eq 0 ]; then
    default ${server_name} $target $addr
elif [ $method -eq 1 ]; then
    thisway ${server_name} $target $addr
elif [ $method -eq 2 ]; then
    thatway ${server_name} $target $addr
else
    echo "Wrong method name"
    exit 1
fi
echo "################################"
