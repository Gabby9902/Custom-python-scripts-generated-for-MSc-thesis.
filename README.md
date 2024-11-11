All batch scripts, R scripts and installation commands required for the completion of my MSc (Microbiology) degree.
Scripts and installation instructions are listed according to which part of the research workflow they fall under.
(Inputs for some custom scripts and programmes can be found in the 'Custom scripts input data' folder)

Metagenome Assembly and Binning
QUAST
conda create - -name quast_env
conda activate quast_env
conda install -y -c bioconda quast
quast “scaffold_name”.fasta > Quast.output

AUTOMETA
Installation
conda create -y -n autometa
conda activate autometa
conda install -y -c bioconda -c conda-forge autometa
autometa-config --section databases --option markers --value /home/sam/Databases/autometa_markers #Note: Leave this path as is, do not change it to your user name
autometa-config --section databases --option ncbi –value /home/sam/Databases/autometa_ncbi_sam #Same here - leave it as is
Running
sbatch autometa_flagged.sh \
-o /path/to/where/output/should/go \
-a /path/to/scaffolds.fasta \
-s basename_of_choice \
-n /home/sam/Databases/autometa_ncbi_sam \
-m /home/sam/Databases/autometa_markers \
-l 3000 -v spades -c 8

CHECKM
create -y -n checkm2 -c bioconda -c conda-forge checkm2 'python>=3.7, <3.9'
conda activate checkm2
sbatch checkm.sh
	
GTDB-TK
conda create -y -n gtdbtk
conda activate gtdbtk
conda install -y -c conda-forge -c bioconda gtdbtk=2.4.0
conda env config vars set GTDBTK_DATA_PATH="/home/sam/Databases/release220"
conda deactivate
conda activate gtdbtk
sbatch gtdbtk.sh

PhyloPhlan3
conda create -n phylophlan
conda activate phylophlan
conda install -c bioconda phylophlan
conda activate phylophlan
sbatch phylophlan.sh

FASTANI
conda create -n fastANI
conda activate fastANI
conda install -c bioconda fastANI
fastANI --threads 2 --ql querylist.txt --rl reflist.txt --matrix -o fastani.out

ANICLUSTERMAP
conda create --name aniclustermap -c conda-forge aniclustermap
conda activate aniclustermap ANIclustermap -i /home/gabby/Spirochete_Paper/FastANI -o /home/gabby/Spirochete_Paper/FastANI --fig_width 20 --fig_height 15 –annotation


PROKKA
conda create --name prokka
conda activate prokka
conda install -y -c biobuilds perl=5.22
conda install -y -c conda-forge parallel
conda install -y -c bioconda prodigal blast=2.2 tbl2asn prokka
conda deactivate
sbatch prokka.sh

KOFAMSCAN
conda create --name kofamscan
conda activate kofamscan 
conda install -y -c bioconda kofamscan hmmer
conda install -y -c conda-forge ruby parallel
conda deactivate

SAMTOOLS
conda create --name samtools
conda activate samtools
conda install -y -c bioconda samtools
conda deactivate


CLINKER (BGC VISUALISATION)
conda create -n clinker -c conda-forge -c bioconda clinker-py
conda activate clinker
clinker /path/to/clusters/*.gbk -p BGCs.html
	
