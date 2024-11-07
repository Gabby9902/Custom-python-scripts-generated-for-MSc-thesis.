from Bio import SeqIO, SeqFeature
from Bio.SeqRecord import SeqRecord
import argparse
import sys
import os
from glob import glob
from Bio import SeqIO
from xlsxwriter import Workbook

def getOverlap(a, b):
    return max(0, min(a[1], b[1]) - max(a[0], b[0]))

def get_coding_density(genbank_path):
    genbank_handle = open(genbank_path, "rU")
    seq_records = SeqIO.parse(genbank_handle, "genbank")
    protein_dict = {}
    total_sequence = 0
    for record in seq_records:
        for index,feature in enumerate(record.features):
            contig_length = len(record.seq)
            if feature.type == 'CDS':
                start = feature.location._start.position
                end = feature.location._end.position
                locus_tag = feature.qualifiers['locus_tag'][0]
                protein_dict[locus_tag] = {}
                protein_dict[locus_tag]['start'] = start
                protein_dict[locus_tag]['end'] = end
        total_sequence += contig_length

    genbank_handle.close()

    coding_sequence = 0
    total_overlapping_sequence = 0
    for count,protein in enumerate(list(protein_dict.keys())[:len(list(protein_dict.keys())) - 1]):
        start = protein_dict[protein]['start']
        end = protein_dict[protein]['end']
        length = abs(start - end)
        coding_sequence += length

        next_protein = list(protein_dict.keys())[count + 1]
        next_start = protein_dict[list(protein_dict.keys())[count + 1]]['start']
        next_end = protein_dict[list(protein_dict.keys())[count + 1]]['end']
        a = [start,end]
        b = [next_start,next_end]
        if getOverlap(a,b) > 0:
            #print "Found {} bp of overlap in reading frames between {} and {}!".format(getOverlap(a,b),protein,next_protein)
            total_overlapping_sequence += getOverlap(a,b)

    true_coding_sequence = coding_sequence - total_overlapping_sequence
    crude_coding_density = round((coding_sequence / total_sequence*100),2)
    adjusted_coding_density = round((true_coding_sequence / total_sequence*100),2)
    return(adjusted_coding_density)

def filter_pseudo_from_gbk(origin_file,list_file,outputfile):
    unwanted = list(line.rstrip("\n").split(None,1)[0] for line in open(list_file))
    count = 0
    records = []
    for record in SeqIO.parse(origin_file,"genbank"):
        features = []
        # SeqIO.SeqRecord(self, seq, id='<unknown id>', name='<unknown name>', description='<unknown description>', dbxrefs$
        # output_file = str(record.id)+"_extracted.gbk"
        for index, feature in enumerate(record.features):
            if 'locus_tag' in feature.qualifiers:
                if feature.qualifiers['locus_tag'][0] in unwanted:
                    continue
                    # record.features.remove(feature)

                # Add feature to record.
                features.append(feature)
        # Finished constructing list of features
        # Constructing seqRecord object
        seq_rec = SeqIO.SeqRecord(
            seq=record.seq,
            id=record.id,
            name=record.name,
            description=record.description,
            dbxrefs=record.dbxrefs,
            annotations=record.annotations,
            features=features,
        )
        # Adding seqRecord to records list
        records.append(seq_rec)
    # Write out records list to output_file
    SeqIO.write(records, outputfile, "genbank")

characteristics = []

input_directory = sys.argv[1]

tab_files = [file for file in os.listdir(input_directory) if file.endswith(".tab")]

#create lists of all proteins that are pseudogenes or matched to proteins that are annotated as
#transpoases or hypothetical
for tab in tab_files:
        pseudo_list = []
        transposase_list =[]
        hypothetical_list = []
        bad_match_list = []
        filename, file_extension = os.path.splitext(tab)
        pseudo_list_output_file = input_directory+"/"+filename+"_pseudogene_list"
        blast_matches = len(open(input_directory+"/"+tab).readlines())
        Total_ORFS = len([1 for line in open(input_directory+"/"+filename+".faa") if line.startswith(">")])
        No_sig_match = Total_ORFS - blast_matches
        pseudo_output_file = input_directory+"/"+filename+"pseudo_list"

#Find pseudogenes, hypotheticals, transposases and bad matches
        with open(input_directory+"/"+tab) as input:
                next(input)
                for line in input:
                    qseqid,stitle,pident,evalue,qlen,slen = line.split("\t")
                    qlen_int = float(qlen)
                    slen_int = float(slen)
                    size_deviation = qlen_int/slen_int*100
                    if (size_deviation < 80) or (size_deviation > 120):
                        pseudo_list.append(qseqid)
                    if "transposase" in stitle:
                        transposase_list.append(qseqid)
                    if "hypothetical" in stitle:
                        hypothetical_list.append(qseqid)
                    if float(pident) < 50:
                        bad_match_list.append(qseqid)

#Make pseudogene list for each file
        with open(pseudo_list_output_file,"w") as pseudo_output:
                for item in pseudo_list:
                    pseudo_output.write(item+"\n")
        pseudo_output.close()

#Create new files without pseudogenes
        for extension in [".faa",".fna",".ffn"]:
                pseudo_out = input_directory+"/"+filename + "without_pseudos"+extension
                origin_file = input_directory+"/"+filename+extension
                records = (r for r in SeqIO.parse(origin_file, "fasta") if r.id not in pseudo_list)
                SeqIO.write(records,pseudo_out, "fasta")

#Make new gbk files without pseudogenes
        origin_file = input_directory+filename+".gbk"
        outputfile = input_directory+filename+"without_pseudogenes.gbk"
        filter_pseudo_from_gbk(origin_file,pseudo_list_output_file,outputfile)

#Find coding density before and after pseudogene removal
        before_coding_density = get_coding_density(origin_file)
        after_coding_density = get_coding_density(outputfile)

#Count items in each list and add to list of dictionaries ([{sample_1:pseudo_count,transpo_count,hypo_count        
        sample_list = []
        pseudo_count = len(pseudo_list)
        transpo_count = len(transposase_list)
        hypo_count = len(hypothetical_list)
        bad_match = len(bad_match_list)
        sample_dict = {"Genome":filename,
        "Total ORFs": str(Total_ORFS),
        "Pseudogenes":str(pseudo_count),
        "Transposases":str(transpo_count),
        "Hypothetical":str(hypo_count),
        "No_sig_match":str(No_sig_match),
        "Bad_matches": str(bad_match),
        "Initial_coding_density":str(before_coding_density),
        "Coding_density_without_pseudos": str(after_coding_density)}
        characteristics.append(dict(sample_dict))

#Tabulate characteristics
tab_headers = ["Genome",
"Total ORFs",
"Pseudogenes",
"Transposases",
"Hypothetical",
"No_sig_match", 
"Bad_matches",
"Initial_coding_density",
"Coding_density_without_pseudos"]
wb=Workbook(input_directory+"/"+"Genome_characteristics.xlsx")
ws=wb.add_worksheet("New_Sheet")
first_row=0
for h in tab_headers:
    col=tab_headers.index(h)
    ws.write(first_row,col,h)

row=1
for genome in characteristics:
    for key, value in genome.items():
        col=ordered_list.index(key)
        ws.write(row,col,value)
    row+=1
wb.close()