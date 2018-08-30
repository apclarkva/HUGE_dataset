#Set directory to HUGE_dataset
WRK=/workdir/data/HUGE_dataset
OUT=$WRK/bwa-mem/bwa_alignments #Where I want to save the alignments
if [! -e $OUT]; then mkdir -p $OUT; fi


#Get the name for all of the samples / runs
NAME="$1"

READ1=$WRK/3-trimmo/$NAME.1.fastq
READ2=$WRK/3-trimmo/$NAME.2.fastq

#BWA mem takes the prefix of the header files
#If you have never run this before with a specific reference, you need to index the reference first. Refer to "run_create_bwa_index.qsub"
REF=$WRK/bwa-mem/reference/index

#Export the path to bwa
export PATH=/programs/bwa-0.7.8

# Align
cd $OUT
# This is running BWA MEM with 4 threads and -a (all). refer to the BWA manual for options
bwa mem -a -t 4  $REF $READ1 $READ2 > $NAME.sam