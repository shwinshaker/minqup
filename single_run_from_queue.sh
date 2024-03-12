#!/bin/bash
gpu_id=${1:-'1'}
conda_env_name=minqup
conda_bin_path=/home/chengyu/anaconda3/bin

set -e

# --- read from queue head --
workdir=$(head -1 logs/queue.txt | awk '{print$4}')
if [ -z $workdir ]; then
    echo "Queue is empty. exit!"
    exit 2
fi
cmd_str=$(head -1 logs/queue.txt | awk '{for(i=6;i<=NF;++i) printf $i FS}')

# -- run --
cur=$(pwd)
cd "$workdir"
[[ ! -L data ]] && ln -s "$cur/data" .
cat <<EOT > run.sh
source $conda_bin_path/activate $conda_env_name
CUDA_VISIBLE_DEVICES=$gpu_id $cmd_str
pid=\$!
echo "[gpu_id]: $gpu_id [pid]: \$pid [time]: $(TZ='America/Los_Angeles' date +%F_%H:%M) [workdir]: $workdir [cmd]: $cmd_str" 
EOT
bash run.sh >> "$cur"/logs/log.txt
cd "$cur"

# -- de-queue --
cat logs/log.txt | tail -n1
sed -i 1d logs/queue.txt