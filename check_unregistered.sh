#!/bin/bash
# check_unregistered.sh
# return the list of servers that are opened for reservation but not reserved yet
#   arguments: date (YYYY-MM-DD), time (HH:NN:SS)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
$( cat ${SCRIPT_DIR}/call_mysql.txt ) -N -A -e "select user_login from wp_olb_timetable left join wp_olb_history on wp_olb_timetable.room_id = wp_olb_history.room_id and wp_olb_timetable.date = wp_olb_history.date and wp_olb_timetable.time = wp_olb_history.time inner join wp_users on wp_olb_timetable.room_id = wp_users.id where wp_olb_history.id is null and wp_olb_timetable.date = '$1' and wp_olb_timetable.time = '$2';" | sort > unregistered_server.dat
