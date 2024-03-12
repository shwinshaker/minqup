#!/bin/bash

set -e

conda_env_name=minqup
conda_bin_path=/home/chengyu/anaconda3/bin
output_path=main.out

source "$conda_bin_path"/activate "$conda_env_name"
CUDA_VISIBLE_DEVICES=3 python main.py --epochs 10 > "$output_path"
