# !/bin/bash
#
# pull from git dipository
#

dir="$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

################################################################################ 
# install from required sources
################################################################################ 
install()
{
	#
	local git_account="lhy11009"

	local external_dir="${dir}/../external"
	# make a directory to hold external scripts
	# [[ -d ${external_dir} ]] || mkdir "${external_dir}"  # make new dir if this doen't exist
	[[ -d ${external_dir} ]] || eval "rm -rf ${external_dir}"  # remove and then make new dir if this already exists
	mkdir "${external_dir}"

	# check for xbt-tool
	xbt_dir="${external_dir}/xbt_tool"
	[[ -d ${xbt_dir} ]] || mkdir "${xbt_dir}"
	# git init
	cd "${xbt_dir}"
	local remote_dir="https://github.com/${git_account}/xbt-external_backup_tool"
	eval "git init; git remote add ${git_account} ${remote_dir}; git pull lhy11009 master"
	local installer="xbt_3.0_all.deb"  # test
	install_xbt_tool
	# back to the directory of this script
	cd "${dir}"
}


################################################################################ 
# install xbt_tool
################################################################################ 
install_xbt_tool()
{
	local installer="xbt_3.0_all.deb"
	install_via_deb "${installer}"
	xbt_path=$(which xbt)
	if [ -n "${xbt_path}" ]; then
	       	echo "xbt installed"
	fi
}

################################################################################ 
# install from source deb
################################################################################ 
install_via_deb()
{
	eval "dpkg -i ${1} && apt-get install -f"
}

remove()
{
	echo "0"
}

main()
{
	install
}

main $@
