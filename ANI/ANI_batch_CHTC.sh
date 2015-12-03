# ./ANI_batch_CHTC.sh

#!/bin/bash
#
# ANI_batch_CHTC.sh
# Pairwise ANI calculations
#

wget http://proxy.chtc.wisc.edu/SQUID/dgshrader/Bacteroidetes1205cds.tar.gz
tar -xzvf Bacteroidetes1205cds.tar.gz

rm Bacteroidetes1205cds.tar.gz
#rm -r Bacteroidetes_cds_1204

DATA_PATH_FILES="$1"/*
for k in $DATA_PATH_FILES; do
./ANIcalculator -genome1fna $4 -genome2fna $k -outfile ANI_output_$2_$3
done


