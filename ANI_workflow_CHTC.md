#Workflow for performing ANI calculations in high-throughput on CHTC.  
This is a workflow for performing a large number of ANI comparisons using CHTC (not Zissou or your local machine).

**1. Obtain sequences for comparison**  
Sarah Stevens (sstevens2@wisc.edu) has a back door into getting either genome scaffolds or protein-coding genes from JGI.  
Given the IMG Taxon OID numbers, she was able to quickly obtain 1204 Bacteroidetes genomes (scaffolds and CDSs) from JGI.  

**2. Deposit sequences in CHTC**  
a. Obtain CHTC account by filling out http://aci.wisc.edu/large-scale-request/. You may meet with a CHTC rep (such as Christina Koch or Lauren Michael) who will provide you with an account.  
b. Download CyberDuck or another SFTP tool to transfer the files. Set up the connection with your CHTC home folder selecting “SFT (SSH File Transfer Protocol)” rather than the default “FTP (File Transfer Protocol)”. Connection should look something like dgshrader@submit-5.chtc.wisc.edu.  
c. Drag your file of genomes into your CHTC home folder.  
d. CHTC rep will probably request that, if your genome set is large, you ALSO create a tar ball of the directory containing your genome files and transfer it to the SQUID folder on CHTC. Create a tar ball in Zissou or on your local machine using something like the following line:  
```
tar -czvf name-of-tarfile.tar.gz input_directory/  
```
Then drag it to your personal folder in the CHTC SQUID directory using CyberDuck or another SFTP tool.  

**3. Deposit ANI calculator software into CHTC.**  
a. Download ANI calculator from https://ani.jgi-psf.org/html/download.php?  
b. Copy the programs ANIcalculator and nsimscan, as well as the directory Log, into your home folder in CHTC, using, for example, CyberDuck SFTP.  

**4. Change ANIcalculator program file permissions**  
Before running, you need to edit the “execute” permissions for ANIcalculator and nsimscan:  
```
cd /home/dgshrader/ANIcalculator_v1 # navigate to ANIcalculator_v1 folder  
ls -l
chmod u+x nsimscan # changes permissions so that the user (“u”, me) can execute (“x”) nsimscan  
chmod g+x nsimscan changes permissions so that the group (“g”) can execute (“x”) nsimscan  
chmod u+x ANIcalculator # changes permissions so that the user (“u”, me) can execute (“x”) ANIcalculator  
chmod g+x ANIcalculator # changes permissions so that the group (“g”) can execute (“x”) ANIcalculator  
```

**5. Create the submit file.**  
It may help to go through the “hello-chtc” tutorial at chtc.cs.wisc.edu/helloworld.shtml. Then enter the following code:  
```
touch ANI_batch_CHTC.sub  
nano ANI_batch_CHTC.sub  
```
“nano” will take you to a text editor where you can copy and paste the following:  
```
# ANI_batch submit file  
universe = vanilla  
log = /home/dgshrader/log_151124/ANI-batch-chtc_$(Cluster).log  
# create log_151124 folder first  
error = /home/dgshrader/log_151124/ANI-batch-chtc_$(Cluster)_$(Process).err  
executable = ANI_batch_CHTC.sh  
arguments = Bacteroidetes_cds_1204 $(Cluster) $(Process) $(file)  
output = /home/dgshrader/log_151124/ANI-batch-chtc_$(Cluster)_$(Process).out  
should_transfer_files = YES  
when_to_transfer_output = ON_EXIT  
transfer_input_files = /home/dgshrader/ANIcalculator,/home/dgshrader/nsimscan,/home/dgshrader/Log  
initialdir = ANIoutput_151124  
# Tell HTCondor what amount of compute resources  
request_cpus = 1  
request_memory = 2GB  
request_disk = 6GB  
# possible flocking line, +WantFlocking = true  
# Tell HTCondor to run 1 instances of our job:  
queue file matching Bacteroidetes_cds_1204/*  
```  
Note: the first argument after “arguments=“ is the name of the folder of genomes. This allows the program to iterate pairwise comparisons by column in your all-by-all genome matrix. Change this argument to match the name of your genome file.  
Note: initialdir is the name of the folder you want all your files to go into.  
Use ctrl+x, then y, then enter to exit the text editor.  

**6. Create the executable file.**  
```
touch ANI_batch_CHTC.sh  
nano ANI_batch_CHTC.sh  
```
Then, paste the following code in the text editor:  
```
#!/bin/bash  
# ANI_batch_CHTC.sh  
# Pairwise ANI calculations  
wget http://proxy.chtc.wisc.edu/SQUID/dgshrader/Bacteroidetes1205cds.tar.gz  
tar -xzvf Bacteroidetes1205cds.tar.gz  
rm Bacteroidetes1205cds.tar.gz  
#rm -r Bacteroidetes_cds_1204  
DATA_PATH_FILES="$1"/*  
for k in $DATA_PATH_FILES; do  
./ANIcalculator -genome1fna $4 -genome2fna $k -outfile ANI_output_$2_$3  
done  
```  
Then replace the arguments of the wget, tar, and rm commands with the name of your tar ball.  
Note that the name of the tar ball may be different than the name of the folder zipped up in the tar ball.  
Use ctrl+x, then y, then enter to exit the text editor.  

**7. Change permissions for the execution of the submit and execute files.**  
```
chmod +x ANI_batch_CHTC.sh  
chmod +x ANI_batch_CHTC.sub  
```

**8. Submit the submit file.**  
```
condor_submit ANI_batch_CHTC.sub  
```

**9. Check the status of your jobs.**  
The total number of jobs should be the number of genomes you’re comparing with one another.  
```
condor_q $USER  
```
For ~1.5 million comparisons, the 1204 jobs all in all took ~6 h total to finish.  
When the program is done executing, condor_q $USER should have 0 jobs running. Some jobs may remain in the hold state. OK to ignore these if the jobs are not mission-critical.  
All files should be placed in a folder called ANIoutput_151124.  

**10. Transfer your output files to your home directory or Zissou or both.**  
When the files are done running, copy the output folder ANIoutput_151124 to your machine or Zissou using CyberDuck or another SFTP tool.  

**11. Concatenate the contents of the output folder into a single file.**  
a. Move the log, and tar files (and possibly error file) that were output into the output folder ANIoutput_151124 to a new location.  
You can find these using the following lines:  
```
ls -l ANIoutput_151124 | head  
ls -l ANIoutput_151124 | tail  
```
Note: the transfer of the tar ball that gets output into the ANIoutput_151124 output folder is what takes up the vast majority of the transfer time. It may make sense to rm this tar ball with rm command first, then transfer the remaining output files. Or, keep it if you don’t have a copy of the tar ball on your Zissou or local machine’s drive already.  
You can move these using some variation of the following lines:  
```
cd /home/dgshrader/ANIoutput/ANIoutput_151124  
mv ANIcalculator.log /home/dgshrader/ANIoutput/ANIoutput_1124_log/ANIcalculator.log  
mv Bacteroidetes1205cds.tar.gz /home/dgshrader/data/Bacteroidetes1205cds.tar.gz  
```
b. While in that directory, concatenate the remaining contents of the folder using the command. This is a tip from unix.stackexchange.com/questions/3770/how-to-merge-all-text-files-in-a-directory-into-one:  
```
cat * > merged-file.txt  
```
This creates the file merged-file.txt within the folder whose files were merged.  

**12. Read the file into R and transfer to a matrix using the following script.**  
https://github.com/dshrade1/freshwater/blob/master/ANI_table_to_matrix.sh  
This will produce a heat map with tree of ANI relatedness of all your genomes.  
Note, if you want to use a list of names to label your matrix (i.e., if you want to relate the rows on your matrix to the names of the organisms) you can use https://github.com/dshrade1/freshwater/blob/master/ANI_table_to_matrix_NAMES.R  
