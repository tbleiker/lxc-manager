#!/bin/bash

# show help
function show_help {
	echo "usage: lxm stop [-h] [-g <groups>] [<filter>]"
	echo ""
	echo "lxcManager: lxm-stop - stop Container(s)"
	echo ""
	echo "positional arguments:"
	echo "  <filte>			regexp to be applied on the container list"
	echo ""
	echo "optional arguments:"
	echo "  -h					show this help message and exit"
	echo "  -g <groups>		groups (comma separated) the container must be a member of"
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

# exit if more than one argument is left
if [[ ! -z ${@:2} ]]; then
	show_help
	exit 1
fi

# get filtered list of running containers
filter="$1"
if [[ -z $groups ]]; then
	containers=$(lxc-ls --running "$filter")
else
	containers=$(lxc-ls --running "$filter" -g "$groups")
fi

# exit if list is emtpy
if [[ -z $containers ]]; then
	echo "No container(s) to stop."
fi

# confirm if no FILTER is given
if [[ -z $filter ]]; then
	read -n 1 -r -p "Stop all running containers? [y/N]? " response
	echo ""
	if [[ ! $response =~(y|j) ]]; then
		exit 0
	fi
fi

# stop container(s)
for container in $containers; do
	echo "stoping container:" $container
	lxc-stop -n $container
done

