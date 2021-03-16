#? Send a message via shellmail
#? usage: echo "address message" | send.sh
#? depends: none
#! ignores all input except the first line
#! the address mustn't contain spaces

# reads from stdin if called without arguments
# otherwise attempts to interpret the argument as an input file

# the message is automatically b64 encoded and encrypted with the recipient's address
if read line
then
	address=$(echo "$line" | head -n1 | awk '{print $1}') # grab the first word of the first line
	msg=$(echo "$line" | head -n1 | awk '{for(i=2;i<=NF;i++) print $i}') # grab the rest of the line
	b64=$(echo "$msg" | base64)
	echo $(curl -sG --data-urlencode "to=$address" --data-urlencode "msg=$b64" http://83.212.127.188:8080)
fi < "${1:-/dev/stdin}"
# The substitution ${1:-...} takes $1 if defined
# otherwise the file name of the standard input of the own process is used.
# https://stackoverflow.com/a/7045517
