#Set directory to HUGE_dataset
WRK=/workdir/data/HUGE_dataset/bwa-mem

#Get the name for all of the samples / runs
NAME="$1"

#Path to SAM files and path to output BAM Files
SAM=$WRK/bwa_alignments
BAM=$WRK/bam-alignments

#Convert SAM Files to BAM Files
samtools view -Sb  $SAM/$NAME.sam  >  $BAM/$NAME.bam