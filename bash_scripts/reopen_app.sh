#!/bin/bash


################################################################################
# Reopen an app by first terminating the existing instances
#
# Dependencies:
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

close_instance(){
    ###
    # (Descriptions)
    # Inputs:
    # Global variables as input:
    # Return:
    # Global variables as output(changed):
    ###
    local cmd="$1"
    eval "ps -o pid,ruser=lochy,comm -ax | grep ${cmd}"

    # kill
    # pid=
    kill "${pid}"
    return 0
}


main(){
    ###
    # main function
    ###
    if [[ "$1" = "close" ]]; then
        ##
        # close all instances of a command
        # Innputs:
        # Terninal Outputs
        ##
        shift
        cmd="$1"
        close_instance "${cmd}"
    else
	    cecho "${BAD}" "option ${1} is not valid\n"
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
