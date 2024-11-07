#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=200GB
#SBATCH --job-name=oma3
#SBATCH --output=oma_logs/oma3-%J.log
#SBATCH --error=oma_logs/oma3-%J.err

cd /home/gabby/OMA.2.6.0

./bin/oma
