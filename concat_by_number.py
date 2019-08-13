import sys
import os

if len(sys.argv) != 4: 
    print("usage : python concat_by_number.py <directory with files to concat> <regroup size> <output directory>")
    exit()

indir = sys.argv[1]
outdir = sys.argv[3]
size = sys.argv[2]
i = 0
concat_list = []
nb_volume = 0
concat_cmd = ""
for f in os.listdir(indir):
    i += 1 
    f_path = indir.rstrip("/")+"/"+f
    concat_list.append(f_path)
    if i%10 == 0:
        nb_volume += 1
        concat_cmd += "echo " + str(nb_volume) + ";"
        concat_cmd += "zcat " + " ".join(concat_list) + "| gzip > " + outdir.rstrip("/") + "/volume" + str(nb_volume) + ".fasta.gz;"
        concat_list = []

if concat_list:
    nb_volume += 1
    concat_cmd += "echo " + str(nb_volume) + ";"
    concat_cmd += "zcat " + " ".join(concat_list) + "| gzip > " + outdir.rstrip("/") + "/volume" + str(nb_volume) + ".fasta.gz;"        
os.system(concat_cmd)
