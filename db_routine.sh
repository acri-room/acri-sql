#!/bin/bash
# db_routine.sh 2020-07-29? Katsunoshin MATSUI -> 2023-05-26 Naoki FUJIEDA
# call the monthly routine (see init_procedure.sql for details)

MONTH=$( date -d "$(date +%Y-%m-1) 1 month" +"%Y-%m" )
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
MAINTENANCE=$( grep ${MONTH} ${SCRIPT_DIR}/maintenance_days.txt | head -n 1 )
$( cat ${SCRIPT_DIR}/call_mysql.txt ) -A -e "call routine_open('${MAINTENANCE}');"