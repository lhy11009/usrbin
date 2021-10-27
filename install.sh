#!/bin/bash


################################################################################
# Install usrbin
# future: fix enable_local.sh
################################################################################

dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
source "${dir}/bash_scripts/utilities.sh"
# subdirs
unset dir
dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
bash_subdir="${dir}/bash_scripts"
[[ -d "${bash_subdir}" ]] || { cecho "${BAD}" "install.sh: no directory (${bash_subdir})"; exit 1; }
bin_subdir="${dir}/bin"
[[ -d "${bin_subdir}" ]] || { echo "create ${bin_subdir}"; mkdir "${bin_subdir}"; }
# global variables
prefix="Usr"  # prefix to installed scripts

usage(){
  # usage of this script
    _text="
${BASH_SOURCE[0]}

Install usrbin, run this in the containing folder!!

Dependencies:
   source files in the subdirectory of bash_scripts

Example Usage:
    installation:
        ./install.sh execute
    clean:
        ./install.sh clean
"
    printf "${_text}"

}

options(){
    ###
    # options when installing files
    ###
    list_of_bash_scripts_to_install=("lalatex.sh" "server.sh")
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

install(){
    ###
    # install apsectLib
    ###
    local dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
    options
    local bashrc_outputs="# Environmental variables\nexport USRBIN_DIR=${dir}"  # set an environmental variable to this dir
    install_sh  # install
    printf "${bashrc_outputs}" >> "${dir}/enable.sh" # output for bashrc
    # install_3rd  # install 3rd party, future
    # screen output
    printf "install.sh: installation is completed\n\
Next step: append one-liner to .bashrc:\n\
    source ${dir}/enable.sh\n"
}

clean(){
    ###
    # clean previous installation
    ###
    # remove install executables
    printf "remove install executables\n"
    eval "[[ -d ${bin_subdir} ]] && rm ${bin_subdir}/*"
    printf "remove previous enable.sh\n"
    eval "[[ -e \"${dir}/enable.sh\" ]] && rm ${dir}/enable.sh"
}

install_sh(){
    ###
    # install bash scripts
    # Inputs:
    # Global variables as input:
    # Return:
    # Global variables as output(changed):
    #   bashrc_outputs: tests to include in the .bashrc file
    ###
    local dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
    local bash_subdir="${dir}/bash_scripts"
    for bash_script_to_install in ${list_of_bash_scripts_to_install[@]}; do
        _path="${bash_subdir}/${bash_script_to_install}"
        [[ -e "${_path}" ]] || { cecho "${BAD}" "${FUNCNAME[0]} no bash scripts (${_path}), check the source files and the file list given"; exit 1; }
        _name=`echo "${bash_script_to_install}" | cut -d'.' -f1`
        _name="${prefix}_${_name}"
        _path_to="${bin_subdir}/${_name}"
        # copy
        eval "ln -s ${_path} ${_path_to}"
        # change mode
        eval "chmod +x ${_path_to}"
        cecho ${GOOD} "${FUNCNAME[0]} ${_path_to} installed"  # screen outputs
    done
    bashrc_outputs="${bashrc_outputs}\n# aspectLib executables\nexport PATH=\${PATH}:${bin_subdir}"
    return 0
}

install_utilities(){
    ###
    # install utilities
    # todo
    ###
    local utilities_dir="${USRBIN_DIR}/utilities"
    if [[ -d ${utilities_dir} ]]; then
        cd "${utilities_dir}"
        eval "git fetch origin"
        eval "git pull origin master"
    else
        eval "mkdir ${utilities_dir}"
        cd "${utilities_dir}"
        eval "git init"
        eval "git remote add origin https://github.com/lhy11009/Utilities"
        eval "git pull origin master"
    fi
    # add git dir
    return 0
}

install_3rd(){
    ###
    # future
    ###
    # download youtube
    eval "curl -L https://yt-dl.org/downloads/latest/youtube-dl -o ./bin/youtube-dl"
    eval "sudo chmod a+x bin/youtube-dl"
}


document(){
    ###
    # documentation
    # future: fix .sh options in .sh files
    ###
    local dir="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null 2>&1 && pwd  )"
    local document_path="${dir}/document.md"
    local document_outputs="Documentation for aspectLib"
    [[ -e "${document_path}" ]] && eval "rm ${document_path}"  # remove previous ones
    document_sh  # bash
    printf "${document_outputs}" >> "${document_path}" # generate documentation
    printf "install.sh: documentation is completed\n"  # screen output
}


document_sh(){
    ###
    # document sh scripts
    # Global variables as input:
    #     bash_subdir: directory for bash scripts
    # Global variables as output:
    #    document_outputs: outputs of documentation
    ###
    [[ -d "${bash_subdir}" ]] || { cecho "${FUNCNAME[0]}: no such directory ${bash_subdir}"; exit 1; }
    for _file in "${bash_subdir}"/*.sh; do
        local file_name=$(basename "${_file}")  # filename
        local help_message=`bash ${_file} -h`  # help message
        document_outputs="${document_outputs}\n\
### ${file_name}:\n\
${help_message}\n"
    done
}


main(){
    ###
    # main function
    ###
    if [[ "$1" = "-h" ]]; then
        usage
    elif [[ "$1" = "execute" ]]; then
        ##
        # (Descriptions)
        # Innputs:
        # Terninal Outputs
        ##
        # create alias
        install
    elif [[ "$1" = "install_utilities" ]]; then
        ##
        # Install utility
        ##
        install_utilities
    elif [[ "$1" = "clean" ]]; then
        # clean previous installation
        clean
    elif [[ "$1" = "document" ]]; then
        # generate documentation
        document
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
