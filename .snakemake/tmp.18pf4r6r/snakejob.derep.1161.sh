#!/bin/sh
# properties = {"type": "single", "rule": "derep", "local": false, "input": ["/workdir/data/HUGE_dataset/0-unzipped/SRR2194935_1.fastq", "/workdir/data/HUGE_dataset/0-unzipped/SRR2194935_2.fastq"], "output": ["/workdir/data/HUGE_dataset/1-derep/SRR2194935.derep_1.fastq", "/workdir/data/HUGE_dataset/1-derep/SRR2194935.derep_2.fastq", "/workdir/data/HUGE_dataset/1-derep/out_bad/SRR2194935_1.fastq", "/workdir/data/HUGE_dataset/1-derep/out_bad/SRR2194935_2.fastq"], "wildcards": {"NAME": "SRR2194935"}, "params": {"n": "derep_SRR2194935", "out": "/workdir/data/HUGE_dataset/1-derep/out_bad", "outgood": "/workdir/data/HUGE_dataset/1-derep/SRR2194935.derep", "outbad": "/workdir/data/HUGE_dataset/1-derep/out_bad/SRR2194935"}, "log": [], "threads": 1, "resources": {"mem_mb": 10}, "jobid": 1161, "cluster": {}}
cd /local/workdir/data/HUGE_dataset && \
/usr/local/bin/python3.6 \
-m snakemake /workdir/data/HUGE_dataset/1-derep/SRR2194935.derep_2.fastq --snakefile /workdir/data/HUGE_dataset/QC/Snake_qc \
--force -j --keep-target-files --keep-remote \
--wait-for-files /local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r /workdir/data/HUGE_dataset/0-unzipped/SRR2194935_1.fastq /workdir/data/HUGE_dataset/0-unzipped/SRR2194935_2.fastq --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
   --nocolor \
--notemp --no-hooks --nolock --mode 2  --allowed-rules derep  && touch "/local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r/1161.jobfinished" || (touch "/local/workdir/data/HUGE_dataset/.snakemake/tmp.18pf4r6r/1161.jobfailed"; exit 1)

