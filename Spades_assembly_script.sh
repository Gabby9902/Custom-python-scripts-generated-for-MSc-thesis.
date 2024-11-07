#!/bin/bash
#SBATCH --partition=agrp
#SBATCH --time=14-00:00:00
#SBATCH -N 1 # Nodes
#SBATCH -n 1 # Tasks
#SBATCH --cpus-per-task=32
#SBATCH --mem 1500G
#SBATCH --error=spades.%J.err
#SBATCH --output=spades.%J.out
#SBATCH --mail-user=luthando9302@gmail.com
#SBATCH --mail-type=ALL

cd /home/gabby/Assembly_dir/

spades.py -t 32 -m 1500 \
        --iontorrent \
        --s1 IonCode_0601_1_rawlib.basecaller.bam \
	--s2 IonCode_0601_2_rawlib.basecaller.bam \
        -k 21,33,55,77,99,127 \
        -o spadesoutput



