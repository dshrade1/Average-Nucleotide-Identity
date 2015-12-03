DATA_PATH_FILES="$1"/*
for i in $DATA_PATH_FILES; do
for k in $DATA_PATH_FILES; do
./ANIcalculator -genome1fna $i -genome2fna $k
done
done
# ./test_ANI_batch2.sh /home/dgshrader/ANIcalculator_v1/ANI_data
