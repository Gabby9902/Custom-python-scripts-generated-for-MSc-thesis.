#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --time=3-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=200GB
#SBATCH --job-name=sam_oma2
#SBATCH --output=oma_logs/oma_%j.out
#SBATCH --error=oma_logs/oma_%j.err

cd /home/gabby/OMA.2.6.0

./bin/oma -s -n 32
