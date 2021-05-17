#!/bin/bash
# setup git repository using a setup file
# Inputs:
#	files/git_repositories
# todo

##setup a repository
setup_repository(){
    local i=0
    number_of_repositories="$1[*]"  # total number
    while (($i < ${number_of_repositories})); do
	repository=${1[$1]}
	# url=
	# branch=
	# remote_branch=
        eval "git remote add ${repository} ${url}"
	eval "git checkout -b ${branch} ${repository}/${remote_branch}"
	((i++))
    done
}

## main function
main(){
    setup_repository
}

## run the script

main $@
