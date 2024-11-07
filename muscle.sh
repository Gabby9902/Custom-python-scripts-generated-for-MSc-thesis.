#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=2GB
#SBATCH --job-name=muscle
#SBATCH --output=muscle.out
#SBATCH --error=muscle.err
#SBATCH --time=12:00:00

cd /home/gabby/OMA.2.6.0/Output/OrthologousGroupsFasta/Common_OGs

for protein_file in `ls *edited.fa`
do
        muscle -align ${protein_file} -output ${protein_file/.fa/.aln}
done
