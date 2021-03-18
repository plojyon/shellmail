#!/bin/bash
#? Recieves a message from shellmail
#? usage: send.sh address
#? depends: none
#! ignores all input except the first line
#? received messages are automatically b64 decoded

# TODO: if $1 is undefined, use a hardcoded private key
messages=$(curl -sG --data-urlencode "key=$1" http://83.212.127.188:8080)
# TODO: check if first word is ERROR:, then print it.
for word in $messages
do
	echo $(echo $word | base64 -d)
	# TODO: also attempt to decrypt the message with my private key
done
