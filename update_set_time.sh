#!/bin/bash
# update_set_time.sh
# update the time when verification keys are set in the gateway server
#   argument: username (beginning with `u_`), time string

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
USER_ID=$( mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -N -A -B -e "select meta.user_id from wp_usermeta as meta inner join wp_users as user on meta.user_id = user.id where user.user_nicename = '$1' and meta_key = 'keys_set'" | tail -n 1 | tr -d '\n' )
if [ -z "${USER_ID}" ]; then
  mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -A -e "insert into wp_usermeta (user_id, meta_key, meta_value) select user.id, 'keys_set', '$2' from wp_users as user where user.user_nicename = '$1'"
else
  mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -A -e "update wp_usermeta set meta_value = '$2' where user_id = '${USER_ID}' and meta_key = 'keys_set'"
fi
