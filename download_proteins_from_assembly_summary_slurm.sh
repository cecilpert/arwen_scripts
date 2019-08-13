if [[ $# -ne 3 ]]; then
    echo "usage : bash download_from_assembly_summary.sh <assembly_summary file> <download directory> <volumes size>"
    exit
fi

ASSEMBLY_SUMMARY=$(readlink -f $1)
OUTDIR=$2
VOLUME_SIZE=$3

mkdir -p $OUTDIR

#How much volumes?
nb_download=$(wc -l $ASSEMBLY_SUMMARY | awk '{ print $1 }')
nb_volumes=$(echo $nb_download | awk '{printf "%0.0f", $1/'$VOLUME_SIZE' + 1}')
nb_prefix=$(echo $nb_volumes | wc -c)
nb_prefix=$(echo $nb_prefix | awk '{print $1 - 1}')
#Separate assembly summary
volume_prefix=$(echo $ASSEMBLY_SUMMARY | rev | cut -f 1 -d "/" | rev | cut -f 1 -d ".")_
cd $OUTDIR
split -l $VOLUME_SIZE -d -a $nb_prefix $ASSEMBLY_SUMMARY $volume_prefix
#Create volume dir and write sbatch
for v in $(ls $volume_prefix*);do
    v=$(readlink -f $v)
    nb=$(echo $v | rev | cut -f 1 -d "_" | rev)
    mkdir -p volume$nb
    volume=$(readlink -f volume$nb)
    cat << EOF > $volume/run_download.sbatch
#!/bin/bash

#SBATCH -J $nb
#specify nameID for job allocation
#SBATCH -o $volume/download_sbatch.out
#connect standart output of Slurm to the file name specified
#SBATCH -e $volume/download_sbatch.err
#connect standart error of Slurm to the file name specified
#SBATCH -p medium # Partition to submit to
#specify the core for ressource allocation
#SBATCH --qos medium # Partition to submit to
#QOS value is define for quality of this job

mkdir -p $volume/fasta
bash /home/chilpert/Dev/download_assembly_summary_proteins.sh $v $volume/fasta > $volume/download_script.out 2> $volume/download_script.err

EOF

done

for volume in $(ls -d volume*); do
    sbatch $volume/run_download.sbatch
done

