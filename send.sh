#!/bin/bash
#? Send a message via shellmail
#? usage: echo "address message" | send.sh
#? depends: none
#! the message is automatically b64 encoded and encrypted with the recipient's address

# The following code was sponsored by StackOverflow
# https://stackoverflow.com/a/29754866
# Thank you Robert Siemer for your submission

# More safety, by turning some bugs into errors.
# Without `errexit` you don’t need ! and can replace
# PIPESTATUS with a simple $?, but I don’t do that.
set -o errexit -o pipefail -o noclobber -o nounset

# -allow a command to fail with !’s side effect on errexit
# -use return value from ${PIPESTATUS[0]}, because ! hosed $?
! getopt --test > /dev/null 
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
	echo 'I’m sorry, `getopt --test` failed in this environment.'
	exit 1
fi

OPTIONS=m:a:
LONGOPTS=message:,address:

# -regarding ! and PIPESTATUS see above
# -temporarily store output to be able to check for errors
# -activate quoting/enhanced mode (e.g. by writing out “--options”)
# -pass arguments only via   -- "$@"   to separate them correctly
! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
	# e.g. return value is 1
	#  then getopt has complained about wrong arguments to stdout
	exit 2
fi
# read getopt’s output this way to handle the quoting right:
eval set -- "$PARSED"

msg=""
addr=""
# now enjoy the options in order and nicely split until we see --
while true; do
	case "$1" in
		-m|--message)
			msg="$2"
			shift 2
			;;
		-a|--address)
			addr="$2"
			shift 2
			;;
		--)
			shift
			break
			;;
		*)
			echo "Programming error $1 $2"
			exit 3
			;;
	esac
done

if [[ -z "${addr}" && -z "${msg}" ]];
then
	echo "$0: Missing parameters -m <message> and -a <address>"
	exit 5
fi
if [[ -z "${addr}" ]];
then
	addr="$(cat /dev/stdin)"
fi
if [[ -z "${msg}" ]];
then
	msg="$(cat /dev/stdin)"
fi
if [[ -z "${addr}" ]];
then
	echo "$0: Missing parameter -a <address>"
fi
if [[ -z "${msg}" ]];
then
	echo "$0: Missing parameter -m <message>"
fi


#echo "addr:$addr"
#echo "msg:$msg"

echo $(curl -sG --data-urlencode "to=$addr" --data-urlencode "msg=$(echo $msg | base64)" http://83.212.127.188:8080)
