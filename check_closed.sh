#!/bin/bash
# check_closed.sh (updated on) 2023-03-21 Naoki FUJIEDA
# return the list of time slots that are not opened for reservation
#   argument: date (YYYY-MM-DD format)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -N -s -e "set @date='$1'; $( cat ${SCRIPT_DIR}/check_closed.sql )"