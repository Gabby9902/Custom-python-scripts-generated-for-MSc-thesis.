#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2GB
#SBATCH --job-name=oma1
#SBATCH --output=logs/oma1-%J.log
#SBATCH --export=None
#SBATCH --error=logs/oma1-%J.err

cd /home/gabby/OMA.2.6.0
./bin/oma -c