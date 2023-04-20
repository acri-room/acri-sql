#!/bin/sh
# registration.sh
# force reserve a specific time slot
#   argument: date, time, server name, user name

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
$( cat ${SCRIPT_DIR}/call_mysql.txt ) -N -A -e "insert into wp_olb_history (date, time, room_id, user_id, free, absent) select '$1', '$2', server.id, user.id, 0, 0 from wp_users as server, wp_users as user where server.user_login = '$3' and user.user_login = '$4' and not exists (select * from wp_olb_history inner join wp_users on wp_olb_history.room_id = wp_users.id where date = '$1' and time = '$2' and user_login = '$3');"
