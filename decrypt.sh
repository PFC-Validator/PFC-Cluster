#/usr/bin/env bash

if [ -f "token.sh" ]; then
	echo skipping token.sh
else 
	gpg2 --output token.sh --decrypt token.sh.asc
fi 

if [ -f "kube-config" ]; then
	echo skipping kube-config
else 
	gpg2 --output kube-config --decrypt kube-config.asc
fi 
