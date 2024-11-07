import sys
import os
from glob import glob
from Bio import SeqIO

OG_dir = sys.argv[1] #dir where OG files are
ext = sys.argv[2] #extesion of files to be found
genomes = sys.argv[3] #list of all expected - must be exactly as in header of fasta entries

file_list = [os.path.abspath(fn) for fn in glob(OG_dir+"/*"+ext)]
print(file_list)
#creation of list that hold fullpath to each OG file to be parsed

genome_list = set(line.rstrip("\n") for line in open(genomes))
print(genome_list)
#create list of all genomes to be found

for genome in genome_list:
        output_file = OG_dir+"/"+genome+"multifasta"+ext
        records = []
        for OG_group in file_list:
                for r in SeqIO.parse(OG_group, "fasta"):
                        if genome in str(r.id):
                                records.append(r)
#Going through each fasta looking for headers tht contain each genome
        SeqIO.write(records, output_file, "fasta")
        #writes pulled fastas to output file
