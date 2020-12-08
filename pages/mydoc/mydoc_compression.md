---
title: "Data compression and clean-up guide"
summary: "The goal of this guide is to assist you in finding uncompressed files in your folders and effectively compressing your data."
sidebar: mydoc_sidebar
folder: browser
permalink: compression.html
author: Sam Buckberry
last_updated: December 8, 2020
---

### Background
Disk space on our servers will always be a limited resource, and therefore we need to effectively manage the data we keep and how it is stored. It is important that we ensure we erase unnecessary files and effectively compress the files we need to keep.

### File compression
File compression is a data compression method in which the size of a file is reduced to save disk space and for faster transmission over a network or the internet. One of the most effective ways to compress files on our servers is using a tool called `pigz` which quickly any uncompressed file into `.gz` files.

To compress a file using the best (highest) level of compression  
```
pigz --best my_file.txt
```
It is good practice to run the above command, or similar for any uncompressed files that you have that are over 100Mb in size (not binary data like BAM files).

### Cleaning up your data

First, create a list of large files you may have stored on the server.

To generate a list of files over 100 megabytes, use the following command  and substitute `your_username` on the first line for your username on the server. Be patient... This command might take some time to run.
```
name=your_username
find /dd_userdata/usrdat0*/userdata//${name}/ -size +100M -type f -exec ls -lh {} \; > ${name}_allfiles.txt
```

Remove files from list that have common extensions of compressed or binary data files. If there are other file extensions you want to ignore, just modify the code for your own purposes.
```
cat ${name}_allfiles.txt | grep -vE "\.bz2|fa\.\w+$|\.rds$|\.Rds$|bam$|bw$|bigwig$|\.gz$|\.zip$|\.tar$|hdf5$|bt2$|bigWig$|index|\.Robj$|ebwt$|.Rdata$" > ${name}_suspected_uncompressed_files.txt
```

Make sure you have a look through the files in this list with the suffix `_suspected_uncompressed_files.txt`, since some files are sometimes better uncompressed (e.g. genome fasta files that need to be uncompressed for some aligners).

When you have checked, and curated the list, use the following command to compress all of the files in the `_suspected_uncompressed_files.txt` file using `pigz`:

```
cat ${name}_suspected_uncompressed_files.txt | awk '{print $9}' | xargs pigz --best
```

Now all of the files in the `_suspected_uncompressed_files.txt` list should be compressed and now have the `.gz` suffix.

---
