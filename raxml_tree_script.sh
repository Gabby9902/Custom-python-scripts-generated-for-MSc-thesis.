#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --time=14-00:00:00
#SBATCH -N 1 # Nodes
#SBATCH -n 1 # Tasks
#SBATCH --cpus-per-task=20
#SBATCH --error=raxml_bootstrap.%J.err
#SBATCH --output=raxml_bootstrap.%J.out

cd /home/gabby/OMA.2.6.0/Output/OrthologousGroupsFasta/Common_OGs

raxmlHPC-PTHREADS-SSE3 -s Final.faa -n PAML_bootstrap_tree.nwk -f a -m PROTGAMMAAUTO -N 100 -p 1989 -x 1989 -T 20