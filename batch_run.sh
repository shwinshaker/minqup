#!/bin/bash

gpu_ids=(1)

count=0
for ((i=0; i<${#gpu_ids[@]}; i++));do
    echo
    bash single_run_from_queue.sh "${gpu_ids[$count]}"
    msg=$?
    [ $msg -eq 2 ] && break
    [ $msg -eq 0 ] && count=$(($count + 1))
    [ $msg -eq -1 ] && break
done
echo
echo '# Total Submitted: '"$count"
