from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import os
import sys

input_directory = sys.argv[1]

nucleotide_files = [file for file in os.listdir(input_directory) if file.endswith("multifasta_nuc.fasta")]
print(nucleotide_files)
codon_stop_array = ["TAG", "TGA", "TAA"]

for nuc in nucleotide_files:
        filename, file_extension = os.path.splitext(nuc)
        print(filename)
        output = filename+"_without_stop"+file_extension
        output_handle = open(output, "w")
        new_fasta_file = []
        for record in SeqIO.parse(nuc, "fasta"):
                if (str(record.seq[-3:])) in codon_stop_array:
                        new_record = SeqRecord(Seq(str(record.seq[0:-3])))
                        new_record.id = record.id
                        new_record.description = record.description
                        new_fasta_file.append(new_record)
                else:
                        new_fasta_file.append(record)
        SeqIO.write(new_fasta_file, output_handle,"fasta")
        output_handle.close()
