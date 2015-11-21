#!/bin/bash

# show help
function show_help {
	echo "usage: lxm start [-h] [-g <groups>] [<filter>]"
	echo ""
	echo "lxcManager: lxm-start - start container(s)"
	echo ""
	echo "positional arguments:"
	echo "  <filter>			regexp to be applied on the container list"
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

# get filtered list of stopped containers
filter="$1"
if [[ -z $groups ]]; then
	containers=$(lxc-ls --stopped "$filter")
else
	containers=$(lxc-ls --stopped "$filter" -g "$groups")
fi

# exit if list is emtpy
if [[ -z $containers ]]; then
	echo "No container(s) to start."
fi

# confirm if no FILTER is given
if [[ -z $filter ]]; then
	read -n 1 -r -p "Start all stopped containers? [y/N]? " response
	echo ""
	if [[ ! $response =~(y|j) ]]; then
		exit 0
	fi
fi

# start container(s)
for container in $containers; do
	echo "starting container:" $container
	lxc-start -n $container
done

