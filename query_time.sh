#!/bin/bash
# query_time.sh
# return the list of reserved servers and users on the specific time slot
#   argument: date (YYYY-MM-DD), time (HH:NN:SS)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -N -A -e "select server.user_login, user.user_login from wp_olb_history inner join wp_users as server on wp_olb_history.room_id = server.id inner join wp_users as user on wp_olb_history.user_id = user.id where date = '$1' and time = '$2'" | sort > query_time_result.dat
