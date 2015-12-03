DATA_PATH_FILES="$1"/*
for i in $DATA_PATH_FILES; do
for k in $DATA_PATH_FILES; do
./ANIcalculator -genome1fna $i -genome2fna $k  -outdir "$3" >> test_results.txt
echo "Calculating ANI between $i and $k"
done
done
