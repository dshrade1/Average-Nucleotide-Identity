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

#VERSION3
#PARAMETERS
DATA_PATH=/home/dgshrader/data/test_data
ANI_PATH=/home/dgshrader/ANIcalculator_v1


DATA_PATH_FILES=$DATA_PATH/*
cd $ANI_PATH
for i in $DATA_PATH_FILES; do
for k in $DATA_PATH_FILES; do
./ANIcalculator -genome1fna $i -genome2fna $k -outfile outfile20151102.txt -outdir /home/dgshrader/ANIoutput
done
done
