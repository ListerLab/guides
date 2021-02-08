---
title: "Plotting ATAC-seq insert histograms"
tags: [ATAC-seq, R]
keywords: ATAC-seq, histogram, R, samtools
summary: "The goal of this guide is to assist plotting insert size histograms of from aligned ATAC-seq data for the purposes of quality control."
sidebar: mydoc_sidebar
folder: ATAC
permalink: atac_histogram.html
author: Sam Buckberry
last_updated: February 4, 2021
---

### The fast way

Download an R script that will generate the histogram plotsand
```
wget https://listerlab.github.io/guides/scripts/R/plot_atac_insert_sizes.R
```

Download a test ATAC-seq BAM file
```
wget https://listerlab.github.io/guides/test_data/test.bam
```

Run the downloaded R script with the `test.bam` file to generate the histogram plots. This R script is written using pure base R, and therefore has no library dependencies. 
```
Rscript plot_atac_insert_sizes.R test.bam
```

This will return a pdf named `test_insertDistribution.pdf`

### The details

The above script basically calls samtools from inside R, and streams the data output from samtools into a vector. Then the base R functions `hist()` and `density()` are used to create the plots, and then output to a pdf file.

Here is how to do it without using the script linked above.

First, use samtools to calculate insert sizes. 
```
samtools view -f66 test.bam | cut -f 9 | sed 's/^-//' > test.sizes
```
This will output a file with one number per line, representing the insert size for each read pair in the BAM file. 

Then Start an R session
```
R
```

Within the R session, read in the insert size data file created above.
```{r}
inserts <- scan("test.sizes")

# make sure the contents of this vector are of class `numeric`
inserts <- as.numeric(inserts)
```


Then plot the insert size histogram
```{r}
hist(x = inserts, breaks = 200, xlim = c(0,800),
     xlab="Fragment length", ylab = "Fragment counts",
     main = bquote(atop(.(prefix), "Fragment size histogram")))
```

![](images/atac_histogram.png)

and calculate the density data and plot (Gives a nice line plot)
```{r}
dens <- density(x = inserts, width = 1)

plot(dens, xlim = c(0,800),
     xlab="Fragment length", ylab = "Fragment counts",
     main = bquote(atop(.(prefix), "Fragment size density")))
```
![](images/atac_density.png)


### The code in the R script

```{r}
## Set command line arguments
args <- commandArgs(TRUE)

bam <- args[1]

# Check that the BAM file exists
stopifnot(file.exists(bam))

# Set the output file prefix
prefix <- gsub(pattern = ".bam$", replacement = "", x = bam)

out_pdf <- paste(prefix, "_insertDistribution.pdf", sep = "")

# Create the argument to extract the insert sizes using samtools
samtools_arg <- paste("samtools view -f66 ",
                      bam,
                      " | cut -f 9 | sed 's/^-//'", sep = "")

# Get the insert sizes
message("###### Calculating insert sizes using samtools...")
inserts <- system(command = samtools_arg, intern = TRUE)
inserts <- as.numeric(inserts)

# Calculate the density data
dens <- density(x = inserts, width = 1)
message(paste("###### Wrting pdf file to ", out_pdf, sep = ""))

# Plot the data and write to pdf 
pdf(file = out_pdf)

hist(x = inserts, breaks = 200, xlim = c(0,800),
     xlab="Fragment length", ylab = "Fragment counts",
     main = bquote(atop(.(prefix), "Fragment size histogram")))

plot(dens, xlim = c(0,800),
     xlab="Fragment length", ylab = "Fragment counts",
     main = bquote(atop(.(prefix), "Fragment size density")))

dev.off()

message("###### Done! ")
```
