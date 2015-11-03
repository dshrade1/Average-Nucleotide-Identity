#PARAMETERS
DATA_PATH=/home/dgshrader/data/test_data
ANI_PATH=/home/dgshrader/ANIcalculator_v1
#THE REST
DATA_PATH_FILES=$DATA_PATH/*
cd $ANI_PATH
for i in $DATA_PATH_FILES; do
for k in $DATA_PATH_FILES; do
./ANIcalculator -genome1fna $i -genome2fna $k -outfile outfile20151102.txt -outdir /home/dgshrader/ANIoutput
done
done
# The only thing is that this file does not save to the output directory 
# Instead, it always saves to a results file within ANIcalculator_v1 folder
