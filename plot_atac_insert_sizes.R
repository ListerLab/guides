#!/usr/bin/env Rscript

## This script requires samtools to be installed on the command line and in PATH. 

# To run the script
# Rscript plot_atac_insert_sizes.R <in.bam>

# Script will output a pdf file with the basename of the bam file as <in.pdf>

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