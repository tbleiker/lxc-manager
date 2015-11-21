#!/bin/bash

# show help
function show_help {
	echo "usage: lxm [-h] <command> [<args>]"
	echo ""
	echo "lxcManager: lxm - main command"
	echo ""
	echo "These are the commands which can be used:"
	echo "  ls              list container(s)"
	echo "  start           start container(s)"
	echo "  stop            stop container(s)"
	echo "  restart         restart container(s)"
	echo "  run             run command in container(s)"
	echo ""
	echo "optional arguments:"
	echo "  -h              show this help message and exit"
}

basedir=$(dirname $(readlink -f $0))

case $1 in
	ls)
		$basedir/lxm-ls.sh "${@:2}"
		;;
	start)
		$basedir/lxm-start.sh "${@:2}"
		;;
	stop)
		$basedir/lxm-stop.sh "${@:2}"
		;;
	restart)
		$basedir/lxm-restart.sh "${@:2}"
		;;
	run)
		$basedir/lxm-run.sh "${@:2}"
		;;
	-h)
		show_help
		;;
	*)
		show_help
		exit 1
esac

