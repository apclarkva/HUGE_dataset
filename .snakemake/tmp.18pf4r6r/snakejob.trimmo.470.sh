#!/bin/sh
# properties = {"type": "single", "rule": "trimmo", "local": false, "input": ["/workdir/data/HUGE_dataset/2-bmtagger/SRR2199612.human_1.fastq", "/workdir/data/HUGE_dataset/2-bmtagger/SRR2199612.human_2.fastq"], "output": ["/workdir/data/HUGE_dataset/3-trimmo/SRR2199612.1.fastq", "/workdir/data/HUGE_dataset/3-trimmo/SRR2199612.2.fastq", "/workdir/data/HUGE_dataset/3-trimmo/SRR2199612.1.solo.fastq", "/workdir/data/HUGE_dataset/3-trimmo/SRR2199612.2.solo.fastq"], "wildcards": {"NAME": "SRR2199612"}, "params": {"n": "trim_SRR2199612", "out": "/workdir/data/HUGE_dataset/3-trimmo", "ADAPTER": "/workdir/refdbs/QC/nextera_truseq_adapters.fasta"}, "log": [], "threads": 1, "resources": {"mem_mb": 20}, "jobid": 470, "cluster": {}}
cd /local/workdir/data/HUGE_dataset && \
/usr/local/bin/python3.6 \
-m snakemake /workdir/data/HUGE_dataset/3-trimmo/SRR2199612.1.fastq --snakefile /workdir/data/HUGE_dataset/QC/Snake_qc \
--force -j --keep-target-files --keep-remote \
--wait-for-files /local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r /workdir/data/HUGE_dataset/2-bmtagger/SRR2199612.human_1.fastq /workdir/data/HUGE_dataset/2-bmtagger/SRR2199612.human_2.fastq --latency-wait 5 \
 --attempt 2 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules trimmo  && touch "/local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r/470.jobfinished" || (touch "/local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r/470.jobfailed"; exit 1)

