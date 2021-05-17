#!/bin/bash


################################################################################
# Installation
#
# Dependencies:
#    env:
#
# Example Usage:
################################################################################

dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
# source "${ASPECT_LAB_DIR}/bash_scripts/utilities.sh"


#parse_options(){
#    ###
#    # parse options
#    ###
#    while [ -n "$1" ]; do
#      param="$1"
#      case $param in
#        -h|--help)
#          usage  # help information
#          exit 0
#        ;;
#      esac
#      shift
#    done
#}

copy_files(){
    ###
    # copy_files from 'files' to 'etc'
    # Inputs:
    # Global variables as input:
    # Return:
    # Global variables as output(changed):
    ###
    # server
    mkdir "$UsrBinDir/etc/server"
    eval "cp $UsrBinDir/files/server $UsrBinDir/etc/server/"
    # remote file lists
    return 0
}


main(){
    ###
    # main function
    ###
    if [[ "$1" = "foo" ]]; then
        ##
        # (Descriptions)
        # Innputs:
        # Terninal Outputs
        ##
        some_funct()
        printf "${return_values}"
    else
	cecho "${BAD}" "option ${1} is not valid\n"
    fi
    fi
}

set +a  # return to default setting

##
# if this is call upon in terminal, the main function is executed
##
if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
	main $@
fi

## notes

#trouble shooting
# [[ -n "$2" ]] || { cecho "${BAD}" "no log file given ($2)"; exit 1; }

#debuging output
# printf "${FUNCNAME[0]}, return_values: ${return_values[@]}\n" # debug

# parse options
        # shift
        # parse_options() $@
