---
title: "Genome sequence, annotation and index file storage and use"
summary: "The goal of this guide is to outline the best practices for storing and using genome sequence, annotation and alignment index files."
sidebar: mydoc_sidebar
folder: browser
permalink: genomes.html
author: Sam Buckberry
last_updated: December 9, 2020
---

### 1. Rationale

This guide describes the storage of reference sequences and annotation files for the commonly studied organisms in the Lister Lab. As many people in the lab use the same reference genomes, alignment algorithms and annotation files, it is much more efficient to store these data in a central and organised way. Below is a description of where to find common sequence, annotation and index files, and what to do if the files you need are not in the repository.

### 2. Where to find genome sequence, annotation and index files

#### Genome sequence files (FASTA)

| Organism     | Source | Build | Format | Path                                                                                            |
|--------------|--------|-------|--------|-------------------------------------------------------------------------------------------------|
| Homo Sapiens | UCSC   | hg19  | fasta  | /home/lister/working_data_02/genomes/Homo_sapiens<br>/UCSC/hg19/Sequence/WholeGenomeFasta/genome.fa |
| Homo Sapiens | UCSC   | hg38  |        |                                                                                                 |
|              |        |       |        |                                                                                                 |

#### Gene annotation files (GTF)

| Organism     | Source | Build | Format | Path                                                                                            |
|--------------|--------|-------|--------|-------------------------------------------------------------------------------------------------|
| Homo Sapiens | UCSC   | hg19  | GTF    | /home/lister/working_data_02/genomes/Homo_sapiens<br>/UCSC/hg19/Annotation/genes.gtf            |
| Homo Sapiens | UCSC   | hg38  |        |                                                                                                 |
|              |        |       |        |                                                                                                 |

#### Bowtie Indexes

#### Bowtie2 Indexes

#### BS-Seeker2 Indexes (WGBS)

#### Hisat2 Indexes

#### Other useful files


### 3. What to do if the genome files you need are not on our servers

A great resource for commonly used genomes is Illumina iGenomes. Here, they have complied all the required files for many organisms. These include fasta, gtf, snp and many alignment indexes.

[https://support.illumina.com/sequencing/sequencing_software/igenome.html](https://support.illumina.com/sequencing/sequencing_software/igenome.html)

If you build or download any new indexes, please add them to the repository and inform Sam Buckberry so he can add them to the lists above.

---
