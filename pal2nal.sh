#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --time=1-00:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --job-name=pal2nal
#SBATCH --output=pal2nal.out
#SBATCH --error=pal2nal.out

cd /home/gabby/OMA.2.6.0/Output/OrthologousGroupsFasta/Common_OGs

# Run the command
pal2nal.pl /home/gabby/OMA.2.6.0/Output/OrthologousGroupsFasta/Common_OGs/Final.faa /home/gabby/OMA.2.6.0/Output/OrthologousGroupsFasta/Common_OGs/Final.fasta -output paml -codontable 11 > Final.paml