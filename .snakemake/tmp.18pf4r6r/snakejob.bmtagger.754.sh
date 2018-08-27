#!/bin/sh
# properties = {"type": "single", "rule": "bmtagger", "local": false, "input": ["/workdir/data/HUGE_dataset/1-derep/SRR2193858.derep_1.fastq", "/workdir/data/HUGE_dataset/1-derep/SRR2193858.derep_2.fastq"], "output": ["/workdir/data/HUGE_dataset/2-bmtagger/SRR2193858.human_1.fastq", "/workdir/data/HUGE_dataset/2-bmtagger/SRR2193858.human_2.fastq"], "wildcards": {"NAME": "SRR2193858"}, "params": {"n": "bmt_SRR2193858", "out": "/workdir/data/HUGE_dataset/2-bmtagger", "config": "/workdir/refdbs/QC/bmtagger.conf", "name": "SRR2193858", "base": "/workdir/data/HUGE_dataset", "REFGENOME": "/workdir/refdbs/QC/Homo_sapiens_assembly19.fasta"}, "log": [], "threads": 1, "resources": {"mem_mb": 10}, "jobid": 754, "cluster": {}}
cd /local/workdir/data/HUGE_dataset && \
/usr/local/bin/python3.6 \
-m snakemake /workdir/data/HUGE_dataset/2-bmtagger/SRR2193858.human_1.fastq --snakefile /workdir/data/HUGE_dataset/QC/Snake_qc \
--force -j --keep-target-files --keep-remote \
--wait-for-files /local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r /workdir/data/HUGE_dataset/1-derep/SRR2193858.derep_1.fastq /workdir/data/HUGE_dataset/1-derep/SRR2193858.derep_2.fastq --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules bmtagger  && touch "/local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r/754.jobfinished" || (touch "/local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r/754.jobfailed"; exit 1)

