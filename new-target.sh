#! /usr/bin/env bash

#
# this script sets up a [machine_folder] working directory with files used
# by other scripts.
#    * ip-address : a file containing the ip address of the host
#    * [machine_folder]-vars.sh : a shell script intended to be source'd that
#                                 sets some arbitrarily standard (for me) env
#                                 vars
#

if [[ -z $1 || -z $2 || -d $1 ]]; then
    echo "USAGE: $0 [machine_folder] [ip_address]"
    echo "creates [machine_folder]/ip-address and [machine_folder]/[machine_folder]-vars.sh files"
    exit 1
fi

mkdir $1
FILE_IP_ADDRESS=ip-address
echo -n "$2" > $1/$FILE_IP_ADDRESS

FILE_HOST_VARS=$1-vars.sh

VARS="export TGT_IP=$2
export TGT_DIR=$(realpath $1)

echo \"+TGT_IP=\${TGT_IP}\"
echo \"+TGT_DIR=\${TGT_DIR}\"

# this file is intended to be source'd from a bash script
if [[ -z \$BASH_SOURCE && -z \${(%):-%N} ]]; then
    echo -e \"\\033[38;5;9mThis is an include script intended to be source'd by other scripts.\\033[0m\"
    # don't exit; user typed \"source ./include-script-output.sh on the command-line\"
    # exiting will close their terminal
fi

# if this script is being executed directly, exit
if [[ \"\${BASH_SOURCE[0]}\" == \"\${0}\" ]]; then
    echo -e \"\\033[38;5;9mThis is an include script intended to be source'd by other scripts.\\033[0m\"
    exit 1
fi
"

echo "$VARS" > $1/$FILE_HOST_VARS

echo -e "\n\033[1;36m$1/:\033[0m"
ls -lFh $1

echo -e "\r\nsource $1/$FILE_HOST_VARS to setup default environment variables"
