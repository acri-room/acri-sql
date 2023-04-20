#!/bin/sh
# cancellation.sh
# force cancel a specific time slot
#   arguments: date, time, server name, user name

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
$( cat ${SCRIPT_DIR}/call_mysql.txt ) -N -A -e "delete wp_olb_history from wp_olb_history inner join wp_users as server on wp_olb_history.room_id = server.id inner join wp_users as user on wp_olb_history.user_id = user.id where date = '$1' and time = '$2' and server.user_login = '$3' and user.user_login = '$4';"
