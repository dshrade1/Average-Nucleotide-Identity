DATA_PATH_FILES="$1"/*
for k in $DATA_PATH_FILES; do
./ANIcalculator -genome1fna ${DATA_PATH_FILES[0]} -genome2fna $k
done

# ./ANI_batch_CHTC.sh /home/dgshrader/ANIcalculator_v1/ANI_data
