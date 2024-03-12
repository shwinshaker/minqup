# minqup
A mininal example of GPU job scheduler in pure shell script

## Installation
1. Install anaconda
2. set `conda_bin_path` in `install.sh`, `run.sh`, and `single_run_from_queue.sh` to your conda path
2. `bash install.sh`

## Standard run
`bash run.sh`

## Scheduled run
* Submit multiple jobs to a queue (`logs/queue.txt`): `bash batch_queue.sh`
* Start the job scheduler: `bash repeat_run.sh`

## What does the job scheduler do?
* Check available GPUs every 1 minute (`repeat_run.sh` and `nvicat.py`)
* If there are any available GPUs, read off jobs from the queue and run it (`batch_run.sh` and `single_run_from_queue.sh`). Runned jobs will be logged (`logs/log.txt`).
* Keep running until the queue empties.

## Note
* You can start the job scheduler in a tmux or screen node