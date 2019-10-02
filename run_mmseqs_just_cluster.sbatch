#!/bin/bash
#SBATCH -J mmseqs
#SBATCH -o mmseqs.out
#SBATCH -e mmseqs.err
#SBATCH -p medium
#SBATCH --qos medium

if [[ $# -ne 4 ]]; then
    echo "bash run_mmseqs_just_cluster.sbatch <mmseqs database> <sequence identity> <output directory> <output prefix> "
    exit
fi

date
DB=$1
SEQID=$2
OUTDIR=$3
PREFIX=$4

mkdir -p $OUTDIR
mkdir -p $OUTDIR/cluster

cd /$WORKDIR

/home/chilpert/miniconda3/envs/mmseqs/bin/mmseqs cluster $DB $PREFIX.cluster tmp_cluster_$PREFIX --threads 32 --min-seq-id 0.8
/home/chilpert/miniconda3/envs/mmseqs/bin/mmseqs createtsv $DB $DB $PREFIX.cluster $PREFIX\_cluster.tsv --full-header

mv $PREFIX\_cluster.tsv $OUTDIR
mv $PREFIX.cluster* $OUTDIR/cluster

rm -r *

date