#!/bin/bash

# show help
function show_help {
	echo "usage: lxm run [-h] [-g <groups>] [<filter>] <command>"
	echo ""
	echo "lxcManager: lxm-start - run command in container(s)"
	echo ""
	echo "positional arguments:"
	echo "  <filter>        regexp to be applied on the container list"
	echo "  <command>       command to run in each container"
	echo ""
	echo "optional arguments:"
	echo "  -h              show this help message and exit"
	echo "  -g <groups>     groups (comma separated) the container must be a member of"
}

# A POSIX variable
OPTIND=1			# Reset in case getopts has been used previously in the shell.

# parse arguments
while getopts "hvg:F" opt; do
	case "$opt" in
	h) # show help
		show_help
		exit 0
		;;
	g) # regex to filter for group
		groups=$OPTARG
		;;
	\?) # unrecognized option
		exit 1
		;;
	:) # missing argument
		exit 1
		;;
	esac
done

shift $((OPTIND-1))

# if two arguments are left: get filter and command
if [[ $# -eq 2 ]]; then
	filter=$1
	cmd=${@:2}
# if only one argument is left: assume that this is the command, set filter to ''
elif [[ $# -eq 1 ]]; then
	filter=""
	cmd=${@:1}
else
	echo "Too many arguments given."
	exit 1
fi

# get filtered list of running containers
if [[ -z $groups ]]; then
	containers=$(lxc-ls --running "$filter")
else
	containers=$(lxc-ls --running "$filter" -g "$groups")
fi

# exit if list is emtpy
if [[ -z $containers ]]; then
	echo "No container(s) to start."
fi

# run command(s) in each container
for container in $containers; do
	echo "###########################################################################################"
	echo "# $container"
	echo "###########################################################################################"
	# use eval in order to get commands with e.g. pipes excecuted correctly
	eval "lxc-attach -n $container -- $cmd"
	echo ""
done

