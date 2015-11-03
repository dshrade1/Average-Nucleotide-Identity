DATA_PATH_FILES="$1"/*
cd "$2"
for i in $DATA_PATH_FILES; do
for k in $DATA_PATH_FILES; do
./ANIcalculator -genome1fna $i -genome2fna $k -outfile outfile20151102.txt -outdir /home/dgshrader/ANIoutput
done
done
# The only thing is that this file does not save to the output directory 
# Instead, it always saves to a results file within ANIcalculator_v1 folder
