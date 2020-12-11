---
title: "WGBS: Read trimming"
summary: "The goal of this guide is take a brief look at adapter trimming of WGBS fastq files, the differences between different trimming approaches and the downstream impact on mapping."
sidebar: mydoc_sidebar
folder: browser
permalink: wgbs-trimming.html
author: Sam Buckberry
last_updated: December 9, 2020
---

#### Recommended approach



#### Trimmer benchmarking

Trimming of adapter sequences from fastq files is an important first step of pre-processing WGBS data. Although this step is, in principle, a straightforward  operation, the results of different sequence trimming approaches can have a significant impact on downstream results.

Several read trimming tools, such as bbduk and fastp, have an automatic mode that detects adapter sequences. However, if you know the adapter sequences, as is usually the case, it is best to parse this information to the trimming algorithm.
We will see the impact this can have on your data below.

#### bbduk

Here we supply the known adapter sequences to the trimmer.

bbduk trimming command
```
time bbduk.sh threads=12 \
in=test_WGBS_10M_reads_R1.fastq.gz \
in2=test_WGBS_10M_reads_R2.fastq.gz \
out=test_WGBS_10M_reads_R1_trimmed_bbduk.fastq.gz \
out2=test_WGBS_10M_reads_R2_trimmed_bbduk.fastq.gz \
literal="AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC,AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT"
```

bbduk trimming results:
```
Input:                  	20000000 reads 		2240000000 bases.
Contaminants:           	227020 reads (1.14%) 	25426240 bases (1.14%)
Total Removed:          	227020 reads (1.14%) 	25426240 bases (1.14%)
Result:                 	19772980 reads (98.86%) 	2214573760 bases (98.86%)

Time:                         	25.388 seconds.
Reads Processed:      20000k 	787.77k reads/sec
Bases Processed:       2240m 	88.23m bases/sec

real	0m25.689s
user	6m34.066s
sys	0m20.893s
```

Auto mode
```
time bbduk.sh threads=12 \
in=test_WGBS_10M_reads_R1.fastq.gz \
in2=test_WGBS_10M_reads_R2.fastq.gz \
out=test_WGBS_10M_reads_R1_trimmed_bbduk_auto.fastq.gz \
out2=test_WGBS_10M_reads_R2_trimmed_bbduk_auto.fastq.gz \
ref=adapters
```

Auto mode results
```
Input:                  	20000000 reads 		2240000000 bases.
Contaminants:           	235486 reads (1.18%) 	26374432 bases (1.18%)
Total Removed:          	235486 reads (1.18%) 	26374432 bases (1.18%)
Result:                 	19764514 reads (98.82%) 	2213625568 bases (98.82%)

Time:                         	412.229 seconds.
Reads Processed:      20000k 	48.52k reads/sec
Bases Processed:       2240m 	5.43m bases/sec

real	6m53.033s
user	8m30.264s
sys	7m48.675s

```
We can see here that by not supplying the adapter sequence, the algorithm takes >10 times longer to run for a highly comparable result.

And with read merging

```
time bbmerge.sh qtrim=r \
in1=test_WGBS_10M_reads_R1_trimmed_bbduk.fastq.gz \
in2=test_WGBS_10M_reads_R2_trimmed_bbduk.fastq.gz \
out=test_WGBS_10M_reads_trimmed_bbduk_merged.fastq.gz \
outu1=test_WGBS_10M_reads_R1_trimmed_bbduk_unmerged.fastq.gz \
outu2=test_WGBS_10M_reads_R2_trimmed_bbduk_unmerged.fastq.gz
```

```
Pairs:               	9886490
Joined:              	5031674   	50.894%
Ambiguous:           	4852932   	49.087%
No Solution:         	1884       	0.019%
Too Short:           	0       	0.000%

Avg Insert:          	156.9
Standard Deviation:  	31.9
Mode:                	167

Insert range:        	35 - 215
90th percentile:     	199
75th percentile:     	183
50th percentile:     	159
25th percentile:     	133
10th percentile:     	112

real	0m56.066s
user	7m29.903s
sys	1m44.003s
```

Merged mapping
```

```

PE mapping
```
time bs_seeker2-align.py \
--aligner=bowtie2 --bt2--end-to-end --bt2-p 10 -e 300 -X 2000 \
--temp_dir=/scratchfs/sbuckberry/tmp \
--split_line=4000000 \
-1 test_WGBS_10M_reads_R1_trimmed_bbduk_unmerged.fastq.gz \
-2 test_WGBS_10M_reads_R2_trimmed_bbduk_unmerged.fastq.gz \
-o test_WGBS_10M_reads_trimmed_bbduk_unmerged.bam \
-d /home/sbuckberry/working_data_01/genomes/hg19_bsseeker_bt2_index/ \
-g hg19_L_PhiX.fa
```

```
[2020-12-10 15:48:09] Number of raw BS-read pairs: 4854816
[2020-12-10 15:48:09] Number of bases in total: 1087478784
[2020-12-10 15:48:09] Number of reads rejected because of multiple hits: 12347
[2020-12-10 15:48:09] Number of unique-hits reads (before post-filtering): 4181802

[2020-12-10 15:48:09]   2091077 FW-RC pairs mapped to Watson strand (before post-filtering)
[2020-12-10 15:48:09]   2090725 FW-RC pairs mapped to Crick strand (before post-filtering)
[2020-12-10 15:48:09]   3921872 uniquely aligned pairs, where each end has mismatches <= 4
[2020-12-10 15:48:09]   1959260 FW-RC pairs mapped to Watson strand
[2020-12-10 15:48:09]   1962612 FW-RC pairs mapped to Crick strand
[2020-12-10 15:48:09] Mappability = 80.7831%
[2020-12-10 15:48:09] Total bases of uniquely mapped reads : 878499328
[2020-12-10 15:48:09] Unmapped read pairs: 932944
```

Sort the BAM
```
sambamba sort -t 12 test_WGBS_10M_reads_trimmed_bbduk_unmerged.bam
```

Clip the overlapping pairs
```
bam clipOverlap --stats \
--in test_WGBS_10M_reads_trimmed_bbduk_unmerged.sorted.bam \
--out test_WGBS_10M_reads_trimmed_bbduk_unmerged_clipped.bam
```

```
Overlap Statistics:
Number of overlapping pairs: 569467
Average # Reference Bases Overlapped: 13.874
Variance of Reference Bases overlapped: 320.008
Number of times orientation causes additional clipping: 0
Number of times the forward strand was clipped: 284535
Number of times the reverse strand was clipped: 284932
```


SE mapping
```
time bs_seeker2-align.py \
--aligner=bowtie2 --bt2--end-to-end --bt2-p 10 -e 400 \
--temp_dir=/scratchfs/sbuckberry/tmp \
-i test_WGBS_10M_reads_trimmed_bbduk_merged.fastq.gz \
-o test_WGBS_10M_reads_trimmed_bbduk_merged.bam \
-d /home/sbuckberry/working_data_01/genomes/hg19_bsseeker_bt2_index/ \
-g hg19_L_PhiX.fa
```

```
[2020-12-10 15:58:47] Number of raw reads: 5031674
[2020-12-10 15:58:47] Number of bases in total: 789441816
[2020-12-10 15:58:47] Number of reads are rejected because of multiple hits: 569
[2020-12-10 15:58:47] Number of unique-hits reads (before post-filtering): 4641429
[2020-12-10 15:58:47]   2322055 FW reads mapped to Watson strand (before post-filtering)
[2020-12-10 15:58:47]   2319374 FW reads mapped to Crick strand (before post-filtering)
[2020-12-10 15:58:47] Post-filtering 4500924 uniquely aligned reads with mismatches <= 4
[2020-12-10 15:58:47]   2250495 FW reads mapped to Watson strand
[2020-12-10 15:58:47]   2250429 FW reads mapped to Crick strand
[2020-12-10 15:58:47] Mappability = 89.4518%
[2020-12-10 15:58:47] Total bases of uniquely mapped reads : 706825215
```

merge the BAM files before postmap
```
sambamba merge -t 12 test_WGBS_10M_reads_final.bam test_WGBS_10M_reads_trimmed_bbduk_merged.bam test_WGBS_10M_reads_trimmed_bbduk_unmerged_clipped.bam
```




```
/home/sbuckberry/working_data_01/bin/cgmaptools/cgmaptools convert bam2cgmap -b test_WGBS_10M_reads_trimmed_bbduk_unmerged.bam \
-g /home/sbuckberry/working_data_01/genomes/hg19_bsseeker_bt2_index/hg19_L_PhiX.fa \
-o test_WGBS_10M_reads_trimmed_bbduk_unmerged
```
---
#### fastp


fastp trimming command
```
time fastp -Q -L --thread=12 \
adapter_sequence=AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC \
adapter_sequence_r2=AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT \
--in1=test_WGBS_10M_reads_R1.fastq.gz \
--in2=test_WGBS_10M_reads_R2.fastq.gz \
-o test_WGBS_10M_reads_R1_trimmed_fastp.fastq.gz \
-O test_WGBS_10M_reads_R2_trimmed_fastp.fastq.gz
```

results
```
reads passed filter: 19990438
reads failed due to low quality: 0
reads failed due to too many N: 0
reads with adapter trimmed: 1198946
bases trimmed due to adapters: 19528111

real	2m52.192s
user	6m19.099s
sys	0m34.718s
```

fastp auto mode
```
time fastp -Q -L --thread=12 \
--in1=test_WGBS_10M_reads_R1.fastq.gz \
--in2=test_WGBS_10M_reads_R2.fastq.gz \
-o test_WGBS_10M_reads_R1_trimmed_fastp_auto.fastq.gz \
-O test_WGBS_10M_reads_R2_trimmed_fastp_auto.fastq.gz
```

results
```
reads passed filter: 19990438
reads failed due to low quality: 0
reads failed due to too many N: 0
reads with adapter trimmed: 1198946
bases trimmed due to adapters: 19528111

real	2m2.626s
user	6m47.792s
sys	1m11.172s
```


### Results

Lets look at the results where we supplied the adapter sequence to the trimmer.

**bbduk trimming is 488% faster**  
**bbduk removed 1.14% of bases**  
**fastp removed 0.87% of bases**  

So, bbduk removed more bases and reads. Let's have a look to see how this impacts read mapping.

---

### Read trimming impact on mapping


#### bbmap trimmed reads
```
time bs_seeker2-align.py \
--aligner=bowtie2 --bt2--end-to-end --bt2-p 12 -e 300 -X 2000 \
--temp_dir=/scratchfs/sbuckberry/tmp \
--split_line=4000000 \
-1 test_WGBS_10M_reads_R1_trimmed_bbduk.fastq.gz \
-2 test_WGBS_10M_reads_R2_trimmed_bbduk.fastq.gz \
-o test_WGBS_10M_reads_trimmed_bbduk.bam \
-d /home/sbuckberry/working_data_01/genomes/hg19_bsseeker_bt2_index/ \
-g hg19_L_PhiX.fa
```

```
[2020-12-09 17:44:51] --------------------------------
[2020-12-09 17:44:51] Number of raw BS-read pairs: 9886490
[2020-12-09 17:44:51] Number of bases in total: 2214573760
[2020-12-09 17:44:51] Number of reads rejected because of multiple hits: 16276
[2020-12-09 17:44:51] Number of unique-hits reads (before post-filtering): 8397733

[2020-12-09 17:44:51]   4200888 FW-RC pairs mapped to Watson strand (before post-filtering)
[2020-12-09 17:44:51]   4196845 FW-RC pairs mapped to Crick strand (before post-filtering)
[2020-12-09 17:44:51]   8032780 uniquely aligned pairs, where each end has mismatches <= 4
[2020-12-09 17:44:51]   4014918 FW-RC pairs mapped to Watson strand
[2020-12-09 17:44:51]   4017862 FW-RC pairs mapped to Crick strand
[2020-12-09 17:44:51] Mappability = 81.2501%
[2020-12-09 17:44:51] Total bases of uniquely mapped reads : 1799342720
[2020-12-09 17:44:51] Unmapped read pairs: 1853710

[2020-12-09 17:44:51] --------------------------------
[2020-12-09 17:44:51] Methylated C in mapped reads
[2020-12-09 17:44:51]  mCG  78.598%
[2020-12-09 17:44:51]  mCHG 1.773%
[2020-12-09 17:44:51]  mCHH 0.831%
[2020-12-09 17:44:51] --------------------------------

```

#### fastp trimmed reads
```
time bs_seeker2-align.py \
--aligner=bowtie2 --bt2--end-to-end --bt2-p 12 -e 300 -X 2000 \
--temp_dir=/scratchfs/sbuckberry/tmp \
--split_line=4000000 \
-1 test_WGBS_10M_reads_R1_trimmed_fastp.fastq.gz \
-2 test_WGBS_10M_reads_R2_trimmed_fastp.fastq.gz \
-o test_WGBS_10M_reads_trimmed_fastp.bam \
-d /home/sbuckberry/working_data_01/genomes/hg19_bsseeker_bt2_index/ \
-g hg19_L_PhiX.fa
```

```
[2020-12-09 17:24:44] --------------------------------
[2020-12-09 17:24:44] Number of raw BS-read pairs: 9995219
[2020-12-09 17:24:44] Number of bases in total: 2218696873
[2020-12-09 17:24:44] Number of reads rejected because of multiple hits: 17926
[2020-12-09 17:24:44] Number of unique-hits reads (before post-filtering): 8913070

[2020-12-09 17:24:44]   4458315 FW-RC pairs mapped to Watson strand (before post-filtering)
[2020-12-09 17:24:44]   4454755 FW-RC pairs mapped to Crick strand (before post-filtering)
[2020-12-09 17:24:44]   8544257 uniquely aligned pairs, where each end has mismatches <= 4
[2020-12-09 17:24:44]   4270577 FW-RC pairs mapped to Watson strand
[2020-12-09 17:24:44]   4273680 FW-RC pairs mapped to Crick strand
[2020-12-09 17:24:44] Mappability = 85.4834%
[2020-12-09 17:24:44] Total bases of uniquely mapped reads : 1897778877
[2020-12-09 17:24:44] Unmapped read pairs: 1450962

[2020-12-09 17:24:44] --------------------------------
[2020-12-09 17:24:44] Methylated C in mapped reads
[2020-12-09 17:24:44]  mCG  78.442%
[2020-12-09 17:24:44]  mCHG 1.773%
[2020-12-09 17:24:44]  mCHH 0.832%
[2020-12-09 17:24:44] --------------------------------
```
