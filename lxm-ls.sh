#!/bin/bash

# show help
function show_help {
	echo "usage: lxm ls [-h] [-F] [-g <groups>] [<filter>]"
	echo ""
	echo "lxcManager: lxm-ls - list container(s)"
	echo ""
	echo "positional arguments:"
	echo "  <filter>        regexp to be applied on the container list"
	echo ""
	echo "optional arguments:"
	echo "  -h              show this help message and exit"
	echo "  -g <groups>     groups (comma separated) the container must be a member of"
	echo "  -F              show all fields"
}

# A POSIX variable
OPTIND=1			# Reset in case getopts has been used previously in the shell.

# Initialize default variable(s)
fancy="-f"

# parse arguments
while getopts "hg:F" opt; do
	case "$opt" in
	h) # show help
		show_help
		exit 0
		;;
	g) # regex to filter for group
		groups=$OPTARG
		;;
	F)
		fancy="-F name,state,interfaces,ipv4,ipv6,pid,memory,ram,swap,groups,autostart -f"
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

# print filtered output of lxc-ls -f
filter="$1"
if [[ -z $groups ]]; then
	lxc-ls $fancy "$filter"
else
	lxc-ls $fancy "$filter" -g "$groups"
fi

