#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --job-name=paml
#SBATCH --output=paml.out
#SBATCH --error=paml.err

cd /home/gabby/OMA.2.6.0/Output/OrthologousGroupsFasta/Common_OGs

codeml All_control_file.ctl
