#!/bin/bash
# list_user.sh
# return the name of user who reserves the specific time slot of server
#   argument: server name, date, time

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -N -A -e "select user.user_login from wp_olb_history inner join wp_users as server on wp_olb_history.room_id = server.id inner join wp_users as user on wp_olb_history.user_id = user.id where server.user_login = '$1' and date = '$2' and time = '$3'" > query_result.dat
