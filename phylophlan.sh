#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --time=14-00:00:00
#SBATCH -N 1 # Nodes
#SBATCH -n 1 # Tasks
#SBATCH --cpus-per-task=10
#SBATCH --error=phylophlan.%J.err
#SBATCH --output=phylophlan.%J.out

cd /home/gabby/Spirochete_Paper/Spirochete_Bins_Figure1

phylophlan -i Phylophlan_input -o phylophlan_output -d phylophlan --diversity medium -f supermatrix_aa.cfg