#############################################
# python script used to find empty GPUs
#############################################

import re
import subprocess
import fileinput

def parse_output(output):
    gpu_utils = []
    memory_total = []
    memory_used = []
    gpu_ids = []
    lines = []
    for line in output.split('\n'):
        if not re.match(r'^\[\d\].*', line):
            continue
        lines.append(line)
        gpu_utils.append(float(re.findall(r',\s*(\d+)\s*\%\s*\|', line)[0]))
        memory_total.append(int(re.findall(r'\|\s*\d+\s*\/\s*(\d+)\s*MB\s*\|', line)[0]))
        memory_used.append(int(re.findall(r'\|\s*(\d+)\s*\/\s*\d+\s*MB\s*\|', line)[0]))
        gpu_ids.append(int(re.findall(r'^\[(\d+)\].*', line)[0]))
    memory_free = [t - u for t, u in zip(memory_total, memory_used)]
    return gpu_ids, gpu_utils, memory_free, lines


if __name__ == '__main__':
    ## -- define available gpu --
    least_memory_free = 16000  # only gpu with at least this much memory will be viewed as available
    gpus_only = [0, 1]  # only gpu from this list will be viewed as available
    
    ## -- find available gpu using gpustat --
    output = subprocess.getoutput(f'gpustat')
    gpu_ids, gpu_utils, memory_free, lines = parse_output(output)
    if gpus_only:
        free_idx = [i for i, (u, g, m) in enumerate(zip(gpu_utils, gpu_ids, memory_free)) if u == 0 and g in gpus_only and m > least_memory_free]
    else:
        free_idx = [i for i, (u, m) in enumerate(zip(gpu_utils, memory_free)) if u == 0 and m > least_memory_free]
    free_gpu_ids = [g for i, g in enumerate(gpu_ids) if i in free_idx]
    free_lines = [l for i, l in enumerate(lines) if i in free_idx]
    for line in free_lines:
        print(line)
    print(f'# Total Available: {len(free_gpu_ids)}')
    
    ## -- format for bash launch --
    print('write gpu ids to running script..')
    gpu_ids_str = ' '.join([str(i) for i in free_gpu_ids])
    with fileinput.input("batch_run.sh", inplace=True) as file:
        for line in file:
            if re.match('^gpu_ids=.*', line):
                line = re.sub('^gpu_ids=(.*)', f'gpu_ids=({gpu_ids_str})', line)
            print(line, end='')
    
    
