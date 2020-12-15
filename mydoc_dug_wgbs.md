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

r1=$(ls "$PWD"/*R1.fastq.gz | sed 's/^/readR1=/')
r2=$(ls "$PWD"/*R2.fastq.gz | sed 's/^/readR2=/')
nrow=$(echo "$r1"| wc -l)
nums=$(seq 1 $nrow)
dt=$(echo "$nums" | sed 's/^/depTasks=/')

paste <(echo "$nums") <(echo "$dt") <(echo "$r1") <(echo "$r2") --delimiters ' ' > input.schema

```

