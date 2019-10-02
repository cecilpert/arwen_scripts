if [[ $# -ne 2 ]]; then
    echo "usage: bash concatenate_volumes_slurm.sh <volumes directory> <output directory>"
    exit
fi

INDIR=$1
OUTDIR=$2

for volume in $(ls -d $INDIR/volume*); do 
    volume=$(readlink -f $volume)
    volume_name=$(echo $volume | rev | cut -f 1 -d "/" | rev)
    mkdir -p $OUTDIR/$volume_name
    new_volume=$OUTDIR/$volume_name
    cat << EOF > $new_volume/run_concatenate.sbatch
#!/bin/bash

#SBATCH -J concatenate
#specify nameID for job allocation
#SBATCH -o $new_volume/concatenate_sbatch.out
#connect standart output of Slurm to the file name specified
#SBATCH -e $new_volume/concatenate_sbatch.err
#connect standart error of Slurm to the file name specified
#SBATCH -p medium # Partition to submit to
#specify the core for ressource allocation
#SBATCH --qos medium # Partition to submit to
#QOS value is define for quality of this job

zcat $volume/fasta/*.gz | gzip > $new_volume/$volume_name\_protein.faa.gz

EOF
done

for volume in $(ls -d $OUTDIR/volume*); do
    sbatch $volume/run_concatenate.sbatch
done