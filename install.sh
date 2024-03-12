#!/bin/bash

set -e

conda_env_name=minqup
conda_bin_path=/home/chengyu/anaconda3/bin
conda create -n "$conda_env_name" python=3.9.1
source "$conda_bin_path"/activate "$conda_env_name"

pip install gpustat
pip install torch==2.0.1 torchvision==0.15.2
