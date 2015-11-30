DATA_PATH_FILES="$1"/*
cd "$2"
for i in $DATA_PATH_FILES; do
for k in $DATA_PATH_FILES; do
./ANIcalculator -genome1fna $i -genome2fna $k -outfile "$3"/ANI_batch_output.txt -outdir "$3" > /dev/null
echo "Calculating ANI between $i and $k"
done
done

#ANI_batch.sh /home/dgshrader/data/test_data2 /home/dgshrader/ANIcalculator_v1/ /home/dgshrader/scripts
