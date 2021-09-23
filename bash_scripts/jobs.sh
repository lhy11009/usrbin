#!/bin/bash


################################################################################
# Manage jobs
################################################################################

dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
source "${USRBIN_DIR}/bash_scripts/utilities.sh"  # use utility functions

usage(){
  # usage of this script
    _text="
${BASH_SOURCE[0]}

Manage jobs

Dependencies:
   env:
       USRBIN_DIR

Example Usage:
    restart all:
        Usr_jobs restart
    edit log files:
        Usr_jobs edit 0
            0 - job list file
            1 - todo list file
"
    printf "${_text}"

}


parse_options(){
    ###
    # parse options
    ###
    while [ -n "$1" ]; do
      param="$1"
      case $param in
        -h|--help)
          usage  # help information
          exit 0
        ;;
        -a)
          shift
          appendix="${1}"
        ;;
        -a=*|--appendix=*)
          appendix="${param#*=}"
        ;;
      esac
      shift
    done
}

# global variables for log file path
job_list_path="${HOME}/Documents/Subject/Memo/job_list"
todo_list_path="${HOME}/Documents/Subject/Memo/todo_list.md"
book_dir="${HOME}/Documents/Subject/Books"
paper_dir="${HOME}/Documents/Subject/papers"

restart_all(){
    ###
    # Restart all applications
    # Inputs:
    #   $1: list number/appendix
    ###
    file_path="${job_list_path}${1}"
    [[ -e "${file_path}" ]] || { cecho "${BAD}" "file doesn't exist ($file_path)"; exit 1; }
    # open list of command
        eval "vim ${file_path}"
    # execute list of command
    restart_with_key "${file_path}" "calendar"
    restart_with_key "${file_path}" "mail"
    restart_with_key "${file_path}" "canvas"
    restart_with_key "${file_path}" "onedrive"
    restart_with_key "${file_path}" "code"
    restart_with_key "${file_path}" "konqueror"
    restart_with_key "${file_path}" "audio-recorder"
    return 0
}

restart_with_key()
{
    ###
    # Restart with a key word in command
    # Inputs:
    #   $1: file storing a list of command
    ###
    local file_path="$1"
    local key="$2"
    [[ -e "${file_path}" ]] || { cecho "${BAD}" "no file path given ($2)"; exit 1; }
    local output
    while IFS= read -r line; do
        if [[ ${line} =~ "#" ]]; then
            output="${line}"
        else
            [[ ${line} =~ "${key}" ]] && { echo "${output}"; eval "nohup ${line} &"; }
        fi
    done < "${file_path}"
}

edit()
{
    ###
    # Edit log files
    # Inputs:
    #   $1: option for file to edit
    #        1 - job file
    #        2 - todo file
    ###
    local file_path
    if [[ ${1} = "0" ]]; then
        file_path="${job_list_path}"
    elif [[ ${1} = "1" ]]; then
        file_path="${todo_list_path}"
    fi
    eval "vim ${file_path}"
}


main(){
    ###
    # main function
    ###
    local command="$1"
    shift # add parse options in each subcommand
    if [[ "${command}" = "-h" ]]; then
        usage
    elif [[ "${command}" = "restart" ]]; then
        ##
        # Restart all applications
        # Innputs:
        # Terninal Outputs
        ##
        parse_options $@
        restart_all "${appendix}"
    elif [[ "${command}" = "edit" ]]; then
        [[ -n "${1}" ]] || { cecho "${BAD}" "no file type given for command \"edit\" ($2)"; exit 1; }
        edit "$1"
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
# [[ -n "${var}" ]] || { cecho "${BAD}" "no log file given ($2)"; exit 1; }
# [[ -z "${var}" ]] && { cecho "${BAD}" "no log file given ($2)"; exit 1; }
# [[ -e "${file}" ]] || { cecho "${BAD}" "no log file given ($2)"; exit 1; }

#debuging output
# printf "${FUNCNAME[0]}, return_values: ${return_values[@]}\n" # debug

# parse options
        # shift
        # parse_options() $@
