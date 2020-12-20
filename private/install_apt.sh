#!/bin/bash

## back them up in a format that dpkg can read* for after your reinstall
catalog(){
    temp_dir="${HOME}/install_temp"
    [[ -d ${temp_dir} ]] || mkdir "${temp_dir}"

    eval "dpkg --get-selections > ${temp_dir}/Package.list"
    eval "sudo cp -R /etc/apt/sources.list* ${temp_dir}/"
    eval "sudo apt-key exportall > ${temp_dir}/Repo.keys"
}

##  Reinstall now
reinstall(){
    [[ -d $1 ]] || { echo "$1 must be a existing directory"; exit 1; }

    sudo apt-key add "$1"/Repo.keys
    sudo cp -R "$1"/sources.list* /etc/apt/
    sudo apt-get update
    sudo apt-get install dselect

   ## You may have to update dpkg's list of available packages or it will just
    ## ignore your selections (see this debian bug for more info).
    ## You should do this before sudo dpkg --set-selections < ~/Package.list, like this:
    apt-cache dumpavail > ~/temp_avail
    sudo dpkg --merge-avail ~/temp_avail
    rm ~/temp_avail

    sudo dpkg --set-selections < "$1"/Package.list
    sudo dselect
}


## back up system
## Inputs:
##  $1: path to backup folder
back_up(){
    rsync --progress /home/`whoami` "$1"
}

## backup system
recover(){
    rsync --progress "$1" /home/`whoami`
}

## main function
main(){
    if [[ "$1" = "catalog" ]]; then
        # example usage:
        #   ./install_apt.sh catalog
        catalog
    elif [[ "$1" = "reinstall" ]]; then
        # example usage:
        reinstall
    elif [[ "$1" = "back_up" ]]; then
        back_up
    elif [[ "$1" = "recover" ]]; then
        recover
    fi
    return 0
}

main $@
