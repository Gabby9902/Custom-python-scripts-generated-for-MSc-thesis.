import sys
import os
from glob import glob
from Bio import SeqIO

wanted =[]

input_directory = sys.argv[1]
#directory is path to multifastas
nucleotide_file = sys.argv[2]
#nucleotide_file is path the conactenated nucleotide file corresponding to proteins

multifasta_file_list = [os.path.abspath(fn) for fn in glob(input_directory+'/*multifasta.aln')]
#creation of list that hold fullpath to each multifasta file to be parsed
print(str(multifasta_file_list))

for file in multifasta_file_list:
        records = []
        wanted = []
        output_file = (os.path.abspath(file))[:-4]+"_nuc.fasta"
        print(os.path.abspath(output_file))
#       outputfile named the same as input OG file
        wanted = list(r.id for r in SeqIO.parse(file, "fasta"))
        print(str(wanted))
#       lists all headers in OG file
        for item in wanted:
                for r in SeqIO.parse(nucleotide_file, "fasta"):
                        if r.id == item:
                                print(str(r.id))
                                records.append(r)
#       pulls all fastas with headers that correspond to wanted list
        SeqIO.write(records, output_file, "fasta")
#       writes pulled fastas to output files
