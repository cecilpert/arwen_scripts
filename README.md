# arwen_scripts
Little scripts working on arwen, mostly using slurm to manage data. 

`add_fasta_id.py``
"""Script to add some id information in fasta header. 
Example :
>YP_588478.1 protein YjjZ [Escherichia coli str. K-12 substr. MG1655]
Call : python add_fasta_id.py seq.fasta GCF_000005845.2
Header will become
>GCF_000005845.2|YP_588478.1 protein YjjZ [Escherichia coli str. K-12 substr. MG1655]
"""
Usage : 
```
python add_fasta_id.py <.fasta.gz file> <id to add>
```

`concatenate_volumes_slurm.sh`
For each volume* directory inside given directory, concatenate all .gz files inside and write in output directory. 
Usage : 
```
bash concatenate_volumes_slurm.sh <volumes directory> <output directory>
```