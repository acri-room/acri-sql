#!/bin/bash
mysql -uwordpress -p -A wordpress -e "set @prefix='$1', @vms=$2; call create_accounts(@prefix, @vms);"
