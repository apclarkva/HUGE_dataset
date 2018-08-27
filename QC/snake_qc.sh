#$ -S /bin/bash
#$ -N snake_qc
#$ -V
#$ -t 1
#$ -pe parenv 10
#$ -e /workdir/data/HUGE_dataset/QC/err/snakemake_$JOB_ID.err
#$ -o /workdir/data/HUGE_dataset/QC/log/snakemake_$JOB_ID.out
#$ -wd /workdir/data/HUGE_dataset
#$ -l h_vmem=1G
#$ -q long.q@cbsubrito2

#this script launches snakemake for our metagenomic QC
#you will need to set up a folder that has raw_fastq with your raw fastq files read 1 and read 2
#also make a log folder and an error folder in the same place
#I put the two snake files snake_qc.sh and Snake_qc in the same folder for convenience

# if you are doing genomes you don't need bmtagger---so modify this script or ask Alyssa for hers

#to test: "snakemake -s Snake_qc -np" when you are in the folder
#this will go through dry run outputting commands -n if you want just the jobs or give you errors if files aren't specified correctly
#if you have been running and deleting the jobs, then you might be locked
# cd to the wd (it seemed to be very specific to where you were) 
#then run this: snakemake -s Snake_qc -unlock
#should unlock the run directory

SNAKEFILE=/workdir/data/HUGE_dataset/QC/Snake_qc #so change this after you move the snakefile
RESTARTS=5
JOBS=10 # max number of jobs you want running at a given time
LOG=/workdir/data/HUGE_dataset/QC/err/ #change this
ERR=/workdir/data/HUGE_dataset/QC/err/ #change this


#and remember to change your snake file so it points to your directory first main line with samples
snakemake -s $SNAKEFILE --restart-times $RESTARTS --jobs $JOBS --cluster "qsub -q long.q@cbsubrito2 -S /bin/bash -e $ERR -o $LOG -N {params.n} -l h_vmem={resources.mem_mb}G"