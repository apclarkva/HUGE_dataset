#!/bin/sh
# properties = {"type": "single", "rule": "bmtagger", "local": false, "input": ["/workdir/data/HUGE_dataset/1-derep/SRR2227949.derep_1.fastq", "/workdir/data/HUGE_dataset/1-derep/SRR2227949.derep_2.fastq"], "output": ["/workdir/data/HUGE_dataset/2-bmtagger/SRR2227949.human_1.fastq", "/workdir/data/HUGE_dataset/2-bmtagger/SRR2227949.human_2.fastq"], "wildcards": {"NAME": "SRR2227949"}, "params": {"n": "bmt_SRR2227949", "out": "/workdir/data/HUGE_dataset/2-bmtagger", "config": "/workdir/refdbs/QC/bmtagger.conf", "name": "SRR2227949", "base": "/workdir/data/HUGE_dataset", "REFGENOME": "/workdir/refdbs/QC/Homo_sapiens_assembly19.fasta"}, "log": [], "threads": 1, "resources": {"mem_mb": 10}, "jobid": 853, "cluster": {}}
cd /local/workdir/data/HUGE_dataset && \
/usr/local/bin/python3.6 \
-m snakemake /workdir/data/HUGE_dataset/2-bmtagger/SRR2227949.human_1.fastq --snakefile /workdir/data/HUGE_dataset/QC/Snake_qc \
--force -j --keep-target-files --keep-remote \
--wait-for-files /local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r /workdir/data/HUGE_dataset/1-derep/SRR2227949.derep_1.fastq /workdir/data/HUGE_dataset/1-derep/SRR2227949.derep_2.fastq --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules bmtagger  && touch "/local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r/853.jobfinished" || (touch "/local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r/853.jobfailed"; exit 1)

