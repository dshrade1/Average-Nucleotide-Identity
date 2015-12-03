#!/usr/bin/python
# python ANI_batch.py '/home/dgshrader/ANIcalculator_v1/ANI_data/*.fna' 12
# cp ANI_batch.py /home/dgshrader/ANIcalculator_v1/ANI_batch.py


import sys, os, glob
from multiprocessing import Pool
# sys allows you to take arguments for your stuff
# to call system, import os

def usage():
	print "Usage: ANI_batch.py 'path2fna(glob)' threads(int)"
	# path2fna is like defining bash variable that is a list
	#  but more flexible (allows you to specify, say, .txt

if len(sys.argv) !=3:
# list is 3 long: script name, aata file and threads arg
	usage()
	exit() #stops the script
	
path2fna= glob.glob(sys.argv[1])
threads = int(sys.argv[2])

print path2fna

def call_ANIcalc(params):
	ref1, ref2 = params #these are the 2 fna files to compare #had to do it this way for the map function to work; needs a LIST to work on (2nd arg of p.map)
	outfile = os.path.splitext(os.path.basename(ref1))[0] + 'v' + os.path.splitext(os.path.basename(ref2))[0] + '.txt'
	#logfile = os.path.splitext(os.path.basename(ref1))[0] + 'v' + os.path.splitext(os.path.basename(ref2))[0] + 'log.txt'
	cmd='./ANIcalculator -genome1fna ' + ref1 + ' -genome2fna ' + ref2 + ' -outfile ' + outfile# + ' -logfile ' + logfile
	print cmd
	os.system(cmd)
	
# make a list of all possible combinations of 

if __name__ == '__main__': #
	p=Pool(threads)
	combos = [] #define empty list
	for fna1 in path2fna:
		for fna2 in path2fna:
			combos.append([fna1, fna2])
	p.map(call_ANIcalc,combos) #runs the same function callANICcalss all the stuff in the list coombos
	p.close #closes threads
	
	
	
