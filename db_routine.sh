#!/bin/sh
# db_routine.sh 2020-07-29? Katsunoshin MATSUI
# call the monthly routine (see init_procedure.sql for details)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
$( cat ${SCRIPT_DIR}/call_mysql.txt ) -A -e "call routine_open();"
