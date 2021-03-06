## HUGE_dataset with SRID Analysis
In this repo, I take [metagenomic data from two patients over the course of a year](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=prjna217052&go=go) (prjna217052 | HUGE samples), and use [Split Read Insertion Deletion](https://www.biorxiv.org/content/early/2017/12/22/214213) to identify mobile elements in the microbiome. 

The data was downloaded from NCBI, cleaned using a snakemake-implemented quality control protocol, and aligned with BWA MEM, using a [nucleotide file representing the HMP reference genome database](https://www.hmpdacc.org/hmp/HMREFG/). Before download, I wrote an R script to find the SRR numbers for only samples that were part of the HUGE study, as the prjna217052 bioproject includes far more data.

[Check out the presentation](https://docs.google.com/presentation/d/1ODe28m4lEkHiNrr6V5k-g8OlGhgPO_ZcWcc8-MSLFxk/edit?usp=sharing)

#### 1. Download dataset (`./`)
The HUGE dataset includes illumina sequencing reads from two patients over the course of the year. Although the project (prjna217052) has many samples, only ones prefixed with `HUGE-` are metagenomic sampels.

1. **fastq-download.qsub** &mdash; Submits the job to the SGE scheduler. The script calls the **DownloadFastQ.py** file.
2. **DownloadFastQ.py** &mdash; Reads in all SRR codes, then multi-threads (x8) a request to **download-fastq-file.sh**, passing in one SRR code at a time.
3. **download-fastq-file.sh** &mdash; Uses `fastq-dump` from the SRAtoolkit to download the fastq files from ncbi.

#### 2. Pass data through the snakemake QC protocol (`./QC/Snake_qc`)
The quality control (QC) protocol removes duplicate reads, human reads, and Illumina adapters from metagenomic data, and performs quality trimming. Ran with:
```
qsub ./QC/snake_qc.qsub
```
The call above submits the `Snake_qc` job.

OUTPOUT:`./3-trimmo` &mdash; will contain the QC'd files for input into BWA.

#### 3. Realign with BWA MEM (`./bwa-mem`)
[BWA MEM](https://github.com/lh3/bwa) is a technique used to align illumina reads to an existing reference genome. BWA MEM will accept the illumina readouts, in FASTQ format, and use the reference genome to create SAM files for each of the reads. The last step in this process was to convert SAM to BAM files. Note: at the tiem, I didn't realize I could have downleded BAM files directly (oops).
1. Index the FASTQ reference file. This will create ~5 new files that are required for the realignment step.
```sh
qsub ./bwa-mem/run_create_bwa_index.qsub
```
OUTPUT: `./bwa-mem/reference` &mdash; contains five files that are required for realignment.

2. Realign files using BWA MEM. This will queue jobs for realignment with BWA MEM. 
```sh
qsub ./bwa-mem/run_aln_bwa_pe.qsub
```
OUTPUT: `./bwa-mem/bwa-alignments` &mdash; contains SAM-formatted realignment files for each sample.

3. Convert SAM files to BAM files. The SRID method requires BAM files as input.
```
qsub ./bwa-mem/sam-to-bam/run_aln_bwa_pe.qsub
```
OUTPUT: `./bwa-mem/bwa-alignments` &mdash; contains BAM-formatted realignment files for each sample.

#### 4. Identify segments of interest with SRID (`./bwa-mem/SRID`)
The [SRID method](https://github.com/XiaofangJ/SRID) is used to find reads that map to two separate parts of the reference genome. The goal is to identify missing segments in the reference genome.
```
qsub srid.qsub
```
OUTPUT: `./bwa-mem/mobile-elements`

I have moved the `mobile-elements`. You can find them in `./r-data-analysis/mobile-elements`.

#### 5. Analysis (`/r-data-analysis/get-srr.R`)
In this directory, I count the number of MGEs identified in each sample, and determine which MGEs are identified in multiple samples, over time. This file creates graphs that show the frequency of MGEs detected over time for each candidate. Additionally, you can use the data frames to identify which MGEs are detected in multiple samples. Below are a list of variables that are formatted for easy analysis. Each variable below has an equivalent for candidate B.

* `findOverlapA` &mdash; contains the date, scaffold, and start split site for all duplicated elements in the first thirteen samples of candidate A. 
* `tableA` &mdash; contains information about all MGEs in all samples of Candidate A. Use `names(tableA)` to see these names.




