#/usr/bin/env bash

if [ -f "token.sh" ]; then
	echo skipping token.sh
else 
	gpg2 --output token.sh --decrypt token.sh.asc
fi 

