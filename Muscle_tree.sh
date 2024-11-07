#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2GB
#SBATCH --job-name=muscle
#SBATCH --output=muscle_tree.out
#SBATCH --error=muscle_tree.err
#SBATCH --time=12:00:00

cd /home/gabby/OMA.2.6.0/Output/OrthologousGroupsFasta/Common_OGs


muscle -in supergenes_aln.fasta -out supergenes.phy -maketree -cluster neighborjoining