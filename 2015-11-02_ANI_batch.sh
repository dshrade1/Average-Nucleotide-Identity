ANI_PATH=/home/dgshrader/ANIcalculator_v1
DATA_PATH=/home/dgshrader/data/Bacteroidetes_cds_1204/*
NUM_FILES=ls -l $DATA_PATH|wc -l
FILES_NAMES=ls $DATA_PATH

#VERSION1
for i in {1..NUM_FILES}; do
for k in {1..NUM_FILES}; do
./ANIcalculator -genome1fna ${i}.fna -genome2fna ${k}.fna -outfile testfile.txt -outdir /home/dgshrader/ANIoutput/
done
done

#VERSION2
for i in {2506381007..2506381009}; do
for k in {2506381007..2506381009}; do
./ANIcalculator -genome1fna $i -genome2fna ${k}.fna -outfile testfile.txt -outdir /home/dgshrader/ANIoutput/
done
done

#VERSION3 THIS WORRRRRRRRRRRRRRRRRRKS!!!
#PARAMETER to ENTER
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
