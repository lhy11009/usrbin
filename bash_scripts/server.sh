#!/bin/bash


################################################################################
# connent to and transform with server
#
# Dependencies:
#    env:
#       USRBIN_DIR
#
# Example Usage:
#    show available options:
#
#    connect to server:
#        ./bash_scripts/server_new.sh connect ucd
#    show available options:
#       ./bash_scripts/server_new.sh show_available
#    transfer files with server:
#       ./bash_scripts/server_new.sh trans ucd -d 1
#           -d: 0 (both direction)
#               1 (from server)
#               TODO: --delete doesn't work
#
########################################################
########################

source "${USRBIN_DIR}/bash_scripts/utilities.sh"
SERVER_LIST="${USRBIN_DIR}/etc/server/server"
LOCAL_FILE_LIST="${USRBIN_DIR}/etc/local_file_list"


parse_options(){
    data_direction="0"
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
        -d|--direction)
          shift  # direction for transforming data
          data_direction="$1"
        ;;
      esac
      shift
    done
}

connect(){
    ###
    # Connect to a server
    # Inputs:
    #   $1: name of server
    ###
    # get user name and address
    local server_uname_addr=$(eval "awk '{ if(\$1 == \"${1}\") print \$2;}' $SERVER_LIST")
    [[ -n "${server_uname_addr}" ]] || { cecho "${BAD}" "no info recorded with server: $1"; exit 1; }
    # connect via ssh
    echo "ssh -X ${server_uname_addr}"
    eval "ssh -X ${server_uname_addr}"
    return 0
}


show_available(){
    ###
    # show available options for servers
    ###
    # get user name and address
    cat "$SERVER_LIST"
    return 0
}


transfer_all(){
    ###
    # transfer file with a server
    # Inputs:
    #   $1: name of server
    #   $2: data direction (0, 1, 2)
    ###
    # read server info
    local server_uname_addr=$(eval "awk '{ if(\$1 == \"${1}\") print \$2;}' $SERVER_LIST")
    [[ -n "${server_uname_addr}" ]] || { cecho "${BAD}" "no info recorded with server: $1"; exit 1; }
    # read local file list
    local dir_names=($(eval "awk '{print \$1}' $LOCAL_FILE_LIST"))
    local local_dirs=($(eval "awk '{print \$2}' $LOCAL_FILE_LIST"))
    # transfer
    local remote_file_list="${USRBIN_DIR}/etc/server/$1_file_list"
    local flags="-avur --progress"
    local del_flag="--delete --force"  # delete extranous file and folderes in receiver
    for dirname in ${dir_names[@]}; do
        local_dir=$(eval "awk '{ if(\$1 == \"${dirname}\") print \$2;}' $LOCAL_FILE_LIST")
        remote_dir=$(eval "awk '{ if(\$1 == \"${dirname}\") print \$2;}' $remote_file_list")
	[[ -n ${local_dir} ]] || { cecho "${BAD}" \
		"local_dir is not found for dirname (${dirname}), check $LOCAL_FILE_LIST";\
	       	exit 1; }
	[[ -n ${remote_dir} ]] || { cecho "${BAD}" \
		"remote_dir is not found for dirname (${dirname}), check $remote_file_list";\
	       	exit 1; }
        if [[ "$2" = "0" ]]; then
            # remote to local
            local _source="${server_uname_addr}:${remote_dir}"
            local target="${local_dir}"
            echo "rsync ${flags} ${_source}/* ${target}/"
            eval "rsync ${flags} ${_source}/* ${target}/"
            # local to remote
            local _source="${local_dir}"
            local target="${server_uname_addr}:${remote_dir}"
            echo "rsync ${flags} ${_source}/* ${target}/"
            eval "rsync ${flags} ${_source}/* ${target}/"
        elif [[ "$2" = "1" ]]; then
            # remote to local, delete extranous
            local _source="${server_uname_addr}:${remote_dir}"
            local target="${local_dir}"
            echo "rsync ${flags} ${del_flag} ${_source}/* ${target}/"
            eval "rsync ${flags} ${del_flag} ${_source}/* ${target}/"
        fi
    done

    # local folder_names=$(eval "awk '{print \$1}' $SERVER_LIST")
    # TODO: modify from server_trans.sh
}


main(){
    ###
    # main function
    ###
    if [[ "$1" = "connect" ]]; then
        ##
        # connect to a server
        # Innputs:
        # $2: server name
        ##
        shift
        server_name="$1"
        connect "$server_name"
    elif [[ "$1" = "show_available" ]]; then
        show_available
    elif [[ "$1" = "trans" ]]; then
        shift
        server_name="$1"; shift
        parse_options "$@"
        transfer_all "$server_name" "$data_direction"
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
