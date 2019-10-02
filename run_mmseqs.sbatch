#!/bin/bash
#SBATCH -J mmseqs
#SBATCH -o mmseqs.out
#SBATCH -e mmseqs.err
#SBATCH -p medium
#SBATCH --qos medium

if [[ $# -lt 3 ]]; then
    echo "bash run_mmseqs.batch <output directory> <output prefix> <fasta files>"
    exit
fi

date

OUTDIR=$1
PREFIX=$2
FASTA=${@:3}

mkdir -p $OUTDIR
mkdir -p $OUTDIR/db
mkdir -p $OUTDIR/cluster

cd /$WORKDIR


/home/chilpert/miniconda3/envs/mmseqs/bin/mmseqs createdb $FASTA $PREFIX.mmseqsdb
/home/chilpert/miniconda3/envs/mmseqs/bin/mmseqs cluster $PREFIX.mmseqsdb $PREFIX.cluster tmp_cluster_$PREFIX --threads 32
/home/chilpert/miniconda3/envs/mmseqs/bin/mmseqs createtsv $PREFIX.mmseqsdb $PREFIX.mmseqsdb $PREFIX.cluster $PREFIX\_cluster.tsv --full-header
mv $PREFIX\_cluster.tsv $OUTDIR
mv $PREFIX.mmseqsdb* $OUTDIR/db
mv $PREFIX.cluster* $OUTDIR/cluster

rm -r *

date