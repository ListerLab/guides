# WGBS mapping on DUG

Get a DUG login
```

```

Sign into DUG and test login credientials
```
ssh-add

ssh -vv -J hg19ips_samb@perth.mccloud.dug.com hg19ips_samb@mcc_hg19ips
```

Transfer fastq files to me mapped to DUG
```
rsync -vrtD --stats --human-readable --rsh=ssh RL1991_2019_12_30_38F_p12p18_N2P_MethylC_S7_all_lanes* dug:/d/home/hg19ips/hg19ips_samb/mcc_hg19ips/data/
```



Create schema
```
#!/bin/bash

r1=$(ls "$PWD"/*_R1_00*.fastq.gz | sed 's/^/readR1=/')
r2=$(ls "$PWD"/*_R2_00*.fastq.gz | sed 's/^/readR2=/')
nrow=$(echo "$r1"| wc -l)
nums=$(seq 1 $nrow)
dt=$(echo "$nums" | sed 's/^/depTasks=/')

paste <(echo "$nums") <(echo "$dt") <(echo "$r1") <(echo "$r2") --delimiters ' ' > input.schema

```

Run the PE mapping
```

```

Merge BAM files
```
bams=$(ls "$PWD"/*/RL23*_R1_001.bam)

L1=$(echo "$bams" | grep L001)
L2=$(echo "$bams" | grep L002)

base=$(basename -a $L1 | sed 's/_L001_R1_001.bam/_merged_lanes.bam/g')

out=$(for i in $(echo "$base"); do paste <(echo "$PWD") <(echo "2020_12_14_merged_lanes") <(echo "$i") --delimiters '/'; done)

paste <(echo "$out") <(echo "$L1") <(echo "$L2") --delimiters ' ' > merge.manifest

while read i j k; do sambamba merge -t 32 $i $j $k; done < merge.manifest
```

Run the postmap
```
bams=$(ls "$PWD"/RL23*_merged_lanes.bam)

nrow=$(echo "$bams"| wc -l)
nums=$(seq 1 $nrow)

paste <(echo "$nums") <(echo "file=") <(echo "$bams") --delimiters ' ' > input.schema



```
