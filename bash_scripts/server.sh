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
#        Usr_server connect ucd
#    show available options:
#        Usr_server show_available
#    transfer files with server:
#        Usr_server trans ucd -d 1
#           -d: 0 (both direction)
#               1 (from server)
#               TODO: --delete doesn't work
#    connect vpn to ucdavis:
#       Usr_server ucdavis_vpn
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


transfer_object(){
    ###
    # transfer one file/directory with a server
    # Inputs:
    #   $1: name of server
    #   $2: name of the project
    #   $3: name of a directory
    #   $4: include all files - 0, only case files - 1
    ###
    local server_uname_addr="$1"
    local remote_file_list="${USRBIN_DIR}/etc/server/$1_file_list"
    [[ -n "${server_uname_addr}" ]] || { cecho "${BAD}" "no info recorded with server: $1"; exit 1; }
    local project="$2"
    local dir_name="$3"
    [[ -n "$4" ]] && { file_type="$4"; } || { file_type=0; }
    
    # get the path of directory
    # if a "all" is given to "$3", then we sync everything 
    local_dir=$(eval "awk '{ if(\$1 == \"${project}\") print \$2;}' $LOCAL_FILE_LIST")
    [[ -n ${local_dir} ]] || { cecho "${BAD}" \
	"local_dir is not found for dirname (${project}), check $LOCAL_FILE_LIST";\
	       	exit 1; }
    remote_dir=$(eval "awk '{ if(\$1 == \"${project}\") print \$2;}' $remote_file_list")
    [[ -n ${remote_dir} ]] || { cecho "${BAD}" \
        "remote_dir is not found for dirname (${project}), check $remote_file_list";\
	        exit 1; }
    if [[ ${dir_name} = "all" ]]; then
        local_subdir="${local_dir}"
        remote_subdir="${remote_dir}"
    else
        local_subdir="${local_dir}/${dir_name}"
        remote_subdir="${remote_dir}/${dir_name}"
    fi
           
    # remote to local
    # -f'- output*' means exclude the output directory
    # For file_type 0, sync everything from remote to local
    # For file_type 1, exclude output file from ASPECT, visit, etc.
    # For file_type 2, exclude output file from ASPECT, visit, etc.
    # but include the files in img
    # Also take folder rules set up by the .rsync-filter files into
    # consideration by add flag '-FF'.
    local flags; local _source; local target; local parental_dir;
    local normal_flag
    
    _source="${server_uname_addr}:${remote_subdir}"
    target="${local_subdir}"
    parental_dir=$(dirname "${target}")

    exclude_aspect_flags="-avuhFF --progress -f'- *output*' -f '- snap_shot*' -f '- vtk_output*' -f'- *visit*' -f'- *paraview*' -f '- *.std*' -f '- *tar*'"
    exclude_restart_flag="-avuh --exclude=*restart*"
    normal_flag="-avuh --progress"
    if [[  ${file_type} == 1 ]]; then
        # flags="-avuhFF --progress -f'- *output*' -f '- snap_shot*' -f '- vtk_output*' -f'- *visit*' -f'- *paraview*' -f '- img/*' -f '- *.std*' -f '- *tar*'"
	flags="${exclude_aspect_flags} -f '- img/*'"
    	echo "rsync ${flags} ${_source}/* ${target}/"
    	eval "rsync ${flags} ${_source}/* ${target}/"
    elif [[  ${file_type} == 2 ]]; then
	flags="${exclude_aspect_flags}"
    	echo "rsync ${flags} ${_source}/* ${target}/"
    	eval "rsync ${flags} ${_source}/* ${target}/"
    elif [[  ${file_type} == 3 ]]; then
	flags="${exclude_restart_flag}"
    	echo "rsync ${flags} ${_source} ${parental_dir}/"
    	eval "rsync ${flags} ${_source} ${parental_dir}/"
    elif [[  ${file_type} == 4 ]]; then
	flags="${normal_flag}"
    	echo "rsync ${flags} ${_source} ${parental_dir}/"
    	eval "rsync ${flags} ${_source} ${parental_dir}/"
    else
        flags="-avuh --progress"
    	echo "rsync ${flags} ${_source} ${parental_dir}/"
    	eval "rsync ${flags} ${_source} ${parental_dir}/"
    fi

    
    # local to remote
    # For file_type 0, sync everything from local to remote
    # For file_type 1, sync everything from local to remote
    _source="${local_subdir}"
    target="${server_uname_addr}:${remote_subdir}"
    parental_dir=$(dirname "${target}")
    
    if [[  ${file_type} == 1 ]]; then
	flags="${exclude_aspect_flags} -f '- img/*'"
    	echo "rsync ${flags} ${_source}/* ${target}/"
    	eval "rsync ${flags} ${_source}/* ${target}/"
    elif [[  ${file_type} == 2 ]]; then
        flags="-avuh --progress"
    	echo "rsync ${flags} ${_source}/* ${target}/"
    	eval "rsync ${flags} ${_source}/* ${target}/"
    elif [[  ${file_type} == 3 ]]; then
	echo "skip syncing in the other direction"
    elif [[  ${file_type} == 4 ]]; then
	echo "skip syncing in the other direction"
    else
        flags="-avuh --progress"
    	echo "rsync ${flags} ${_source} ${parental_dir}/"
    	eval "rsync ${flags} ${_source} ${parental_dir}/"
    fi
}


transfer_all(){
    ###
    # transfer file with a server
    # Inputs:
    #   $1: name of server
    #   $2: data direction (0, 1, 2)
    ###
    # read server info
    # This only works if the host name is set up correctly in the .ssh/config file
    local server_uname_addr="$1"
    # local server_uname_addr=$(eval "awk '{ if(\$1 == \"${1}\") print \$2;}' $SERVER_LIST")
    [[ -n "${server_uname_addr}" ]] || { cecho "${BAD}" "no info recorded with server: $1"; exit 1; }
    # read local file list
    local dir_names=(paper subject shared)
    local local_dirs=($(eval "awk '{print \$2}' $LOCAL_FILE_LIST"))
    # transfer
    local remote_file_list="${USRBIN_DIR}/etc/server/$1_file_list"
    local flags="-avuh --progress"
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

clean_shared_folder(){
    ####
    # Delete the contents in the shared folder. First the local folder,
    # then the remote folder
    #   $1: name of server
    ####
    # This only works if the host name is set up correctly in the .ssh/config file
    local dirname="shared"
    local server_uname_addr="$1"
    local remote_file_list="${USRBIN_DIR}/etc/server/$1_file_list"
    [[ -e "${remote_file_list}" ]] || { cecho "${BAD}" \
	    "remote_file_list(${remote_file_list}) doesn't exist";\
	       	exit 1; }
    local flags="-avuh --progress --delete"

    local local_dir=$(eval "awk '{ if(\$1 == \"${dirname}\") print \$2;}' $LOCAL_FILE_LIST")
    echo "local_dir: ${local_dir}" # debug
    local remote_dir=$(eval "awk '{ if(\$1 == \"${dirname}\") print \$2;}' $remote_file_list")
    echo "remote_dir: ${remote_dir}" # debug

    # clean contents in local dir
    echo "rm -rf ${local_dir}/*"
    eval "rm -rf ${local_dir}/*"

    # clean content in remote dir
    local _source="${local_dir}"
    local target="${server_uname_addr}:${remote_dir}"
    echo "rsync ${flags} ${del_flag} ${_source}/ ${target}/" # screen output
    eval "rsync ${flags} ${del_flag} ${_source}/ ${target}/"
}

ucdavis_connect(){
	cd "${USRBIN_DIR}/etc/openvpn"
	[[ -e "profile_ucdavis.ovpn" ]] || { cecho "${BAD}" \
		"profile_ucdavis.ovpn doesn't exist, please configure the openvpn first";\
	       	exit 1; }
	eval "sudo openvpn --config profile_ucdavis.ovpn --auth-retry interact"
}

# todo_rsync
distribute_rsync-filter(){
    local _dir="$1"
    local rf_file_std="${USRBIN_DIR}/files/rsync-filter"
    [[ -e "${rf_file_std}" ]] || { cecho "${BAD}" "${rf_file_std} doesn't exist."; exit 1;}
    for subdir in "${_dir}"/*; do
        if [[ -d "${subdir}" ]]; then
            rf_file="${subdir}/.rsync-filter"
            if ! [[ -e "${rf_file}" ]]; then
                cp "${rf_file_std}" "${rf_file}"
                echo "File generated: ${rf_file}"
            fi
        fi
    done
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
    elif [[ "$1" = "clean_shared" ]]; then
	shift
        server_name="$1"
	echo "option clean_shared" # debug
	clean_shared_folder "$server_name"
	
    elif [[ "$1" = "sync" ]]; then
	shift
        local server_name="$1"; shift
	local project="$1"; shift
	local subdir="$1"; shift
	local file_type="$1"; shift
	transfer_object "${server_name}" "${project}" "${subdir}" "${file_type}"
    elif [[ "$1" = "ucdavis_vpn" ]]; then
	ucdavis_connect
    elif [[ "$1" = "distribute_rsync-filter" ]]; then
        shift
        local directory="$1"
        distribute_rsync-filter "$1"
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
