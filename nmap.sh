#! /usr/bin/env bash

#
# this nmap script scans a host twice
#   * scan #1 is a quick top-1000 tcp port scan for quick results
#   * scan #2 is a full 65535 tcp port scan which can take a while
#     but you won't care because you're partying on the initial
#     results
#
# all results are logged into a nmap.out file in [machine_folder]
#

if [[ -z $1 || ! -f $1/ip-address ]]; then
    echo "USAGE: $0 [machine_folder]"
    echo "expects [machine_folder]/ip-address file"
    exit 1
fi

if ! ip addr show tun0 > /dev/null; then
    echo -e "\033[1;31mERROR: VPN tunnel not found!\033[0m"
    exit 1
fi

(
    echo "% $0 $@"
    TARGET=$(cat $1/ip-address)
    echo "$1 : $TARGET : TOP 1000 PORTS"
    sudo nmap -Pn -n -v -sC -A $TARGET

    echo -e "\n$1 : $TARGET : ALL PORTS"
    sudo nmap -Pn -n -v -sC -A -p- $TARGET
) | tee $1/nmap.out
