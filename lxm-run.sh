#!/bin/bash

# show help
function show_help {
	echo "usage: lxm run [-h] [-g <groups>] [<filter>] <command>"
	echo ""
	echo "lxcManager: lxm-start - run command in container(s)"
	echo ""
	echo "positional arguments:"
	echo "  <filter>			regexp to be applied on the container list"
	echo "  <command>			command to run in each container"
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
#if [[ ! -z ${@:2} ]]; then
#	show_help
#	exit 1
#fi

# get filtered list of running containers
filter="$1"
if [[ -z $groups ]]; then
	containers=$(lxc-ls --running "$filter")
else
	containers=$(lxc-ls --running "$filter" -g "$groups")
fi

# exit if list is emtpy
if [[ -z $containers ]]; then
	echo "No container(s) to start."
fi

# get command(s)
commands=${@:2}

# run command(s) in each container
for container in $containers; do
	echo "###########################################################################################"
	echo "# $container"
	echo "###########################################################################################"
	lxc-attach -n $container -- $commands
	echo ""
done

