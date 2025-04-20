#!/bin/bash
# query_updated_keys.sh
# return the pair of user name and their verification keys, updated recently
#   argument: (none)

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mysql --defaults-extra-file=${SCRIPT_DIR}/call_mysql.conf wordpress -N -A -B -e "select user.user_nicename, vk.meta_value, up.meta_value from wp_users as user inner join wp_usermeta as vk on user.id = vk.user_id and vk.meta_key = 'verification_keys' inner join wp_usermeta as up on user.id = up.user_id and up.meta_key = 'keys_updated' where up.meta_value > subtime(utc_timestamp(), '01:00:00')" | sed -e 's/\r\?\\n/\\\\/g'
