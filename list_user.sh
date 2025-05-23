#!/bin/bash
# list_user.sh
# return the list of regular users

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -N -A -e "select user_login from wp_users where user_login like 'tu_%' or user_login like 'u_%';" > wp_user.dat
