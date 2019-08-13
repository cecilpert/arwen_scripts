if [[ $# -ne 1 ]]; then
    echo "usage : bash verif_download.sh <volumes directory>"
    exit
fi

INDIR=$1

for volume in $(ls -d $INDIR/volume*); do
    volume=$(readlink -f $volume)
    du -sh $volume/fasta/* | awk '{if ($1 == 512) print}'
done