#!/bin/bash
# query_all.sh (updated on) 2023-03-21 Naoki FUJIEDA
# return the list of reserved/closed time slots on the specific date
#   argument: date (YYYY-MM-DD format)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -N -A -e "select server.user_login, time, user.user_login from wp_olb_history inner join wp_users as server on wp_olb_history.room_id = server.id inner join wp_users as user on wp_olb_history.user_id = user.id where date = '$1'"; ${SCRIPT_DIR}/check_closed.sh $1; } | sort > query_all_result.dat
