

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
