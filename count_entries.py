import sys
import os
from glob import glob

input_directory =sys.argv[1]
All = []
protein_file_list = [os.path.abspath(fn) for fn in glob(input_directory+"/*.fa")]
#creation of list that hold fullpath to each OG file to be parsed

for OG_group in protein_file_list:
        count= 0
        count = len([1 for line in open(OG_group) if line.startswith(">")])
        if count == 11:
                All.append(str(os.path.basename(OG_group)))

print(All)
print(str(len(All)))
