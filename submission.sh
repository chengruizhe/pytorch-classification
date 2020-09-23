#!/bin/bash

#SBATCH -p rise # partition (queue)
#SBATCH -N 1 # number of nodes requested
#SBATCH -n 1 # number of tasks (i.e. processes)
#SBATCH --cpus-per-task=8 # number of cores per task

# I think gpu:4 will request 4 of any kind of gpu per node,
# and gpu:v100_32:8 should request 8 v100_32 per node
#SBATCH --gres=gpu:8
#SBATCH --nodelist=atlas# if you need specific nodes
#SBATCH -t 0-8:00 # time requested (D-HH:MM)

#SBATCH -D /home/eecs/chengruizhe/pytorch-classification
#SBATCH -o /home/eecs/chengruizhe/slurm/slurm.%N.%j.out # STDOUT
#SBATCH -e /home/eecs/chengruizhe/slurm/slurm.%N.%j.err # STDERR


# print some info for context
pwd
hostname
date

echo starting job...

# activate your virtualenv
# source /data/drothchild/virtualenvs/pytorch/bin/activate
# or do your conda magic, etc.
source ~/.bashrc
conda activate pytorch

# python will buffer output of your script unless you set this
# if you're not using python, figure out how to turn off output
# buffering when stdout is a file, or else when watching your output
# script you'll only get updated every several lines printed
export PYTHONUNBUFFERED=1

# do ALL the research
srun python imagenet.py -a resnet18 --data /data/imagenetwhole/ilsvrc2012 --epochs 90 --schedule 31 61 --gamma 0.1 -c checkpoints/imagenet/resnet18
#-e --strategy=ema --save-every 1

# print completion time
date