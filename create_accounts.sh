#!/bin/bash
# create_accounts.sh 2020-07-29 Katsunoshin MATSUI
# an example for create servers' accounts
#   arguments: prefix (such as 'vs0'), number of machines

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -A -e "set @prefix='$1', @vms=$2; call create_serverseries(@prefix, @vms);"
