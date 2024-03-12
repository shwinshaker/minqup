#!/bin/bash

while true; do
        echo
        echo -e '\033[31m ----------- Repeat run starts! ------------- \033[0m'
        python nvicat.py
        bash batch_run.sh
        echo -e '\033[31m ------------ Run ended, sleeping ------------- \033[0m'
        sleep 1m
done
