# arwen_scripts
Little scripts working on arwen, mostly using slurm to manage data. 

* `add_fasta_id.py`

Script to add some id information in fasta header.  
Example :
">YP_588478.1 protein YjjZ [Escherichia coli str. K-12 substr. MG1655]"  
Call : `python add_fasta_id.py seq.fasta GCF_000005845.2`  
Header will become  
">GCF_000005845.2|YP_588478.1 protein YjjZ [Escherichia coli str. K-12 substr. MG1655]"  

**Usage** : 
```
python add_fasta_id.py <.fasta.gz file> <id to add>
```

* `concatenate_volumes_slurm.sh`

For each volume* directory inside given directory, concatenate all .gz files inside and write in output directory. 

**Usage** : 
```
bash concatenate_volumes_slurm.sh <volumes directory> <output directory>
```

* `download_assembly_summary_proteins.sh`

Script to download *_protein.faa.gz files from ncbi ftp for assemblies in assembly_summary given file. Also use `add_fasta_id.py` to add assembly accession inside fasta header. 

**Usage :**
````
bash download_assembly_summary_proteins.sh <assembly_summary file> <output directory>
````

* `download_proteins_from_assembly_summary_slurm.sh`

Divide download work in several sbatch scripts and launch this scripts. You can precise size of volumes (number of assemblies per volume). Use `download_assembly_summary_proteins.sh` script.

**Usage :**
````
bash download_proteins_from_assembly_summary_slurm.sh <assembly_summary file> <download directory> <volumes size>
````

* `verif_download.sh`
Look inside volumes if some .gz file are empty (have a size of 512). Print them to stdout

**Usage :**
````
bash verif_download.sh <volumes directory>
````

