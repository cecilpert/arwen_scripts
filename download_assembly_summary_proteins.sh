if [[ $# -ne 2 ]]; then 
    echo "usage : bash download_assembly_summary_protein.sh <assembly summary file> <download directory>"
fi

ASSEMBLY_SUMMARY_FILE=$1
OUTDIR=$2

echo "download script"
echo "assembly $ASSEMBLY_SUMMARY_FILE"
echo "OUTDIR $OUTDIR"

while read -r line; do 
    gcf=$(echo $line | awk '{print $1}')
    ftp=$(echo $line | rev | awk '{print $1}' | rev) #TO CHANGE, it's not last column, two after but empty most of the time
    if [[ ! -f $OUTDIR/$gcf\_protein.faa.gz ]]; then
        protein_link=$ftp/$(echo $ftp | rev | cut -f 1 -d "/" | rev)_protein.faa.gz
        echo "download $protein_link"
        wget -O $OUTDIR/$gcf\_protein.faa.gz $protein_link  
        /bin/python3.6 /home/chilpert/Dev/add_fasta_id.py $OUTDIR/$gcf\_protein.faa.gz $gcf
    fi

done < $ASSEMBLY_SUMMARY_FILE