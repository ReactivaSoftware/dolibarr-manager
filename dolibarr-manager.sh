#! /bin/sh

# Copyright 2018 (c) Peter Fontaine <peter.fontaine@reactiva.fr>
# Copyright 2018 (c) SAS Reactiva Software
#
#
# Permission is hereby granted, free of charge, to any person obtaining 
# a copy of this software and associated documentation files (the “Software”),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the 
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# The Software is provided “as is”, without warranty of any kind, express or
# implied, including but not limited to the warranties of merchantability,
# fitness for a particular purpose and noninfringement. In no event shall
# the authors or copyright holders be liable for any claim, damages or other
# liability, whether in an action of contract, tort or otherwise, arising
# from, out of or in connection with the software or the use or other
# dealings in the Software.

_usage() {
	echo "

Usage: $0 [-s SERVICE_NAME] <subcommand> <subcommand> [args]

OPTIONS:
  -s SERVICE_NAME			Name of the running service.

SUCOMMANDS:
  Commands with * require -s SERVICE NAME

  service:

    $0 service create <name> <hostname> [<domain name>]
    $0 service update <version>                                           *
    $0 service delete <reason>                                            *
    $0 service list (alias for $0 list all)
    $0 service motd <motd>                                                *
    $0 service set-maintance <reason>                                     *
    $0 service infos                                                      *

  list:

    $0 list all
    $0 list activated
    $0 list <search string>


"

	exit 1
}

while getopts ":s:h:" OPT; do
	case $OPT in
		s)
			SERVICE_NAME="$OPTARG"
			;;
		h)
			echo "Help: "
			_usage
			;;
		\?)
			echo "Invalid option: -$OPTARG" >&2
			_usage
			;;
	esac
done

shift $((OPTIND-1))

case $1 in

	service)
		shift
		case $1 in
			create)
				shift
				echo "$@"
				;;
			update)
				shift
				echo "$@"
				;;
			delete)
				shift
				echo "$@"
				;;
			list)
				shift
				echo "$@"
				;;
			motd)
				shift
				echo "$@"
				;;
			set-maintance)
				shift
				echo "$@"
				;;
			infos)
				shift
				echo "$@"
				;;
			*)
				_usage
				;;
		esac
		;;

	list)
		shift
		case $1 in
			all)
				shift
				echo "$@"
				;;
			activated)
				shift
				echo "$@"
				;;
			*)
				_usage
				;;
		esac
		;;

	*)
		_usage
		;;
esac
