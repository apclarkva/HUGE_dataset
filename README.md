# HUGE_dataset
Download <a href="https://www.ncbi.nlm.nih.gov/Traces/study/?acc=prjna217052&go=go" target="_blank">huge dataset</a> (prjna217052), clean with snakemake quality control protocol, and align with BWA MEM. Before download, I wrote an R script to find the SRR numbers for only samples that were part of the HUGE study, as the prjna217052 bioproject includes far more data.

### Downloading the huge dataset (`./`)
The HUGE dataset includes illumina sequencing reads from two patients over the course of the year. In this project, I will download the fastq files for each sample.

Files, in logical order of execution:
1. **fastq-download.qsub** &mdash; Submits the job to the SGE scheduler. The script calls the **DownloadFastQ.py** file.
2. **DownloadFastQ.py** &mdash; Reads in all SRR codes, then multi-threads (x8) a request to **download-fastq-file.sh**, passing in one SRR code at a time.
3. **download-fastq-file.sh** &mdash; Uses `fastq-dump` from the SRAtoolkit to download the fastq files from ncbi.

### Clean files with snakemake QC protocol (`./QC/Snake_qc`)
The quality control (QC) protocol removes duplicate reads, human reads, and Illumina adapters from metagenomic data, and performs quality trimming. Each step is outlined below. It is important to keep track of read counts at each step (i.e. how many reads are you losing at each step?) and making sure that every file completes each step successfully.

### BWA MEM (`./bwa-mem`)
