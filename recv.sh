#? Recieves a message from shellmail
#? usage: echo "address" | send.sh
#? usage: send.sh path/to/address_file
#? depends: none
#! ignores all input except the first line

# reads from stdin if called without arguments
# otherwise attempts to interpret the argument as an input file

# received messages are automatically b64 decoded
if read address
then
	messages=$(curl -sG --data-urlencode "key=$address" http://83.212.127.188:8080)
	for word in $messages
	do
		echo $(echo $word | base64 -d)
	done
fi < "${1:-/dev/stdin}"
# The substitution ${1:-...} takes $1 if defined
# otherwise the file name of the standard input of the own process is used.
# https://stackoverflow.com/a/7045517

# argument parsing
# https://stackoverflow.com/a/29754866