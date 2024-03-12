#!/bin/bash

var_name='epochs'
vars=(5 10 20)

mkdir -p logs
mkdir -p workdirs
for ((i=0; i<${#vars[@]}; i++));do
    echo
    echo "----------------- ""$var_name": "${vars[$i]}"" ----------------"

    # define launch command
    cmd_string="python main.py --$var_name ${vars[$i]} > main.out 2>&1 &"

    # create workdir and copy the src code
    workdir=workdirs/"$var_name"="${vars[$i]}"
    if [ -d $workdir ]; then
        read -p "workdir already exists! Delete [d] or Skip [s] exit [*]? " ans
        case $ans in
            [Dd]* ) rm -r $workdir; echo "dir removed.";;
            [Ss]* ) echo "skipped."; continue;;
            * ) echo "exited."; exit;;
        esac
    fi
    mkdir $workdir
    cp main.py $workdir

    # log to queue.txt
    echo "[Time]: $(TZ='America/Los_Angeles' date +%F_%H:%M) [workdir]: $workdir [cmd]: $cmd_string" >> logs/queue.txt
done
