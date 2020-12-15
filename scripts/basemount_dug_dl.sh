#!/bin/bash

#--- Script to run basemount download

run_path=$1
target_path=$2

#run_path=/d/home/hg19ips/hg19ips_samb/mcc_hg19ips/baseSpace/Runs/methC_ATAC_DP_SB_Lister_2020_12_14/Files/

#anchor dock directory for basemount
ad=/d/home/hg19ips/hg19ips_samb/mcc_hg19ips/baseSpace

# Ensure correct permissions for target path
chmod 777 "$target_path"

# Load the basemount module
module use /p9/mcc_hg19ips/sw/modules
module add basemount

# Mount to the anchor dock directory
basemount -c perkins_basespace.cfg "$ad"

# Download the data using rsync
rsync -ahPr --exclude Thumbnail_Images "$run_path"/* "$target_path" > "$target_path"/copy.log

# unmount
basemount --unmount "$ad"

# Run bcl2fastq
module use /p9/mcc_hg19ips/sw/modules
module add bcl2fastq2
conda deactivate && conda activate /p9/mcc_hg19ips/sw/bcl2fastq2/bcl2fastq2-2.20.0.422/bcl2fastq2.env

cd "$target_path"/Files

bcl2fastq --output-dir "$target_path"/Unaligned

# Generate md5sum
find "$target_path"/Unaligned/ -name "*.fastq.gz" -exec md5sum {} \; > "$target_path"/unaligned_fastq_md5sum.list
