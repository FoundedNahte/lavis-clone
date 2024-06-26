#!/bin/bash

#SBATCH --job-name=blip2_w8                     # sets the job name
#SBATCH --output=qformer_text_w8_a32.%j                    # indicates a file to redirect STDOUT to; %j is the jobid. If set, must be set to a file instead of a directory or else submission will fail.
#SBATCH --error=qformer_text_w8_a32.%j                     # indicates a file to redirect STDERR to; %j is the jobid. If set, must be set to a file instead of a directory or else submission will fail.
#SBATCH --time=20:00:00                                      # how long you would like your job to run; format=hh:mm:ss

#SBATCH --partition=vulcan-scavenger
#SBATCH --qos=vulcan-scavenger                                  # set QOS, this will determine what resources can be requested
#SBATCH --account=vulcan-abhinav
#SBATCH --gres=gpu:rtxa5000:8

#SBATCH --nodes=1                                               # number of nodes to allocate for your job
#SBATCH --ntasks=1                                              
#SBATCH --ntasks-per-node=1                                      
#SBATCH --mem=128gb                                               # (cpu) memory required by job; if unit is not specified MB will be assumed

# OUTPUT_DIR='/fs/vulcan-scratch/elau1/BLIP2_runs/flickr_baseline'

source ~/.bashrc

module load cuda

source ~/ViT/bin/activate

python -m torch.distributed.run \
       --nproc_per_node=8 evaluate.py \
       --cfg-path ret_flickr_eval.yaml

wait                                                            # wait for any background processes to complete

# once the end of the batch script is reached your job allocation will be revoked
