#!/bin/bash


################################################################################
# help to generate latex essays & documentations
################################################################################

dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
source "${dir}/utilities.sh"  # use utility functions
# source the local file list
host_name=`hostname`
dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
[[ -e "${dir}/../files/${host_name}.sh" ]] || { "There is no ${host_name}.sh in the files directory, you need to first creat one"; exit 1; }
source "${dir}/../files/${host_name}.sh"

usage(){
  # usage of this script
    _text="
${BASH_SOURCE[0]}

help to generate latex essays & documentations

Dependencies:
   env:

   files: this script depends on the bash flle named with hostname in the files folder(e.g. shilofue.sh), \n\
   those files set up variables for the file systems in these PCs\n\
\n\
\n\
Example Usage: \n\
   document a figure: \n\
     ./bash_scripts/lalatex.sh document_figure \n\
     /home/lochy/ASPECT_PROJECT/TwoDSubduction/non_linear32/eba1_MRf12_iter20_DET/img/CDPT_newton_history.png \n\
     /home/lochy/Documents/papers/documented_files/TwoDSubduction
"
    printf "${_text}"

}


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

document_figure(){
    ###
    # document a single file for later usage
    # Inputs:
    # Global variables as input:
    # Return:
    # Global variables as output(changed):
    ###
    file_path="$1"
    [[ -n "$2" ]] || { cecho "${BAD}" "second input doesn't exist $2"; exit 1; }
    target_parent_dir="$2"
    local file_base=$(basename "${file_path}")  # base name
    local file_name="${file_base%.*}" # without extensiion
    local target_dir="${target_parent_dir}/${file_name}"
    # check file and directory
    [[ -e "${file_path}" ]] || { cecho "${BAD}" "file doesn't exist (${file_path})"; exit 1; }
    [[ -d "${target_parent_dir}" ]] || mkdir "${target_parent_dir}"
    [[ -d "${target_dir}" ]] && { cecho "${BAD}" "directory exists (${target_dir}), maybe change the name of figure"; exit 1; } || mkdir "${target_dir}"
    # copy file
    cp "${file_path}" "${target_dir}"
    # copy a tex file with the same name
    # substitue keys with values
    local keys=("FIGURE_PATH" "FIGURE_BASENAME")
    local values=("figures/${file_base}" "${file_name}")
    cecho ${GOOD} "Translating figure.tex file"
    utilities_tranlate_script "${UsrBinDIR}/files/tex_files/figure.tex" "${target_dir}/figure.tex"
    # open up gui for editing
    eval "xdg-open ${target_dir}/figure.tex"
    return 0
}


share_figure(){
    ###
    # copy a figure to share folder, todo
    # Inputs:
    #    $1: name of a figure
    # Global variables as input:
    #    SHARED_DIR: a shared directory between pcs
    # Return:
    # Global variables as output(changed):
    ###
    #SHARED_DIR=''
    [[ -e "${SHARED_DIR}" ]] || { cecho "${BAD}" "no variable named SHARED_DIR is defined previously"; exit 1; }
    file_path=`readlink -f "$1"`
    [[ -e "${file_path}" ]] || { cecho "${FUNCNAME[0]}, no such file ${file_path}"; exit 1; }
    local dir_name=`dirname "${file_path}"`
    local dir_base_name=`basename "${dir_name}"`
    local file_name=$(basename "${file_path}")
    local file_copy_path="${SHARED_DIR}/${dir_base_name}_${file_name}"  # use dirname + filename as new file name
    echo "${file_copy_path}"  # debug
    eval "cp ${file_path} ${file_copy_path}"
    printf "${FUNCNAME[0]}: new file generated ${file_copy_path}\n" # output
}


main(){
    ###
    # main function
    ###
    if [[ "$1" = "-h" ]]; then
        usage
    elif [[ "$1" = "document_figure" ]]; then
        ##
        # (Descriptions)
        # Innputs:
        # Terninal Outputs
        ##
        document_figure "$2" "$3"
    elif [[ "$1" = "share_figure" ]]; then
        ##
        # copy a figure to share folder
        # Inputs:
        # Terninal Outputs
        ##
        share_figure "$2"
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
