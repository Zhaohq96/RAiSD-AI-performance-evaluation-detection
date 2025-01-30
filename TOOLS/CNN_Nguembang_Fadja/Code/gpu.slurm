#!/bin/bash
#SBATCH --job-name=gpu
#SBATCH --error=gpu-%j.err
#SBATCH --output=gpu-%j.out
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=longrun
#SBATCH --gres=gpu:4
#SBATCH --mem=10GB 

#export CUDA_VISIBLE_DEVICES=4
 
module load anaconda/3
module load cuda/9.0
module load cudnn/7.0

python3 ./main.py
