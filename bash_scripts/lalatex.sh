#!/bin/bash


################################################################################
# help to generate latex essays & documentations
################################################################################

dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
source "${UsrBinDIR}/bash_scripts/utilities.sh"  # use utility functions

usage(){
  # usage of this script
    _text="
${BASH_SOURCE[0]}

help to generate latex essays & documentations

Dependencies:
   env:
       ASPECT_LAB_DIR
       ASPECT_SOURCE_DIR

Example Usage:
   document a figure:
     ./bash_scripts/lalatex.sh document_figure \
     /home/lochy/ASPECT_PROJECT/TwoDSubduction/non_linear32/eba1_MRf12_iter20_DET/img/CDPT_newton_history.png \
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
    # document a single file for later usage, todo
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
