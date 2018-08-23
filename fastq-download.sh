#$ -S /bin/bash
#$ -cwd
#$ -N download_HUGE_dataset
#$ -V
#$ -m bes
#$ -M apclarkva@gmail.com
#$ -q long.q

## declare an array variable

## now loop through the above array
for i in ${arr[@]}; do
  fastq-dump $i --gzip
done

