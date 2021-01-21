---
title: "Download your data from basespace to DUG using basemount"
summary: "The goal of this guide is to assist you in downloading sequence generated from the NovaSeq that is stored on Illumina's BaseSpace using the basemount software"
sidebar: mydoc_sidebar
folder: browser
permalink: basemount.html
author: Jahnvi Pflüger, Sam Buckberry
last_updated: December 8, 2020
---

### 1. Log into your DUG workspace
Login to the razor server using your usual credentials and authentication methods.

### 2. Create a run folder in the appropriate folder.
Run folder should include the following format: Date_InstrumentName_FlowCellID_RunNumber. You can find flowcellID information from basespace. Open up permissions on the folder by chmod.

For example:
```
mkdir dd_rundata
mkdir dd_rundata/novaseq
mkdir dd_rundata/novaseq/Runs
mkdir test
chmod 777 test
```

### 3. Start a screen session

```
screen -S basemount
```

### Activate BaseMount
```
module use /p9/mcc_hg19ips/sw/modules
module add basemount
basemountPath=/p9/mcc_hg19ips/baseSpace
basemount -c perkins_basespace.cfg "$basemountPath"

```

### 4. Navigate into the home directory


```
cd
```

### 5. Mount the appropriate basespace account using the anchor dock directory

```
basemount baseSpace/
```

You should have successfully mounted the basespace account and see the following message:
```
,-----.                        ,--.   ,--.                         ,--.   
|  |) /_  ,--,--. ,---.  ,---. |   `.'   | ,---. ,--.,--.,--,--, ,-'  '-.
|  .-.  \' ,-.  |(  .-' | .-. :|  |'.'|  || .-. ||  ||  ||      \'-.  .-'
|  '--' /\ '-'  |.-'  `)\   --.|  |   |  |' '-' ''  ''  '|  ||  |  |  |  
`------'  `--`--'`----'  `----'`--'   `--' `---'  `----' `--''--'  `--'
Illumina BaseMount v0.15.96.2155 public  2018-06-04 16:24

Command called:
   basemount -c perkins_basespace.cfg /dd_rundata/novaseq/PerkinsData/
From:
   /dd_rundata/novaseq

Api Server: https://api.basespace.illumina.com/

Mounting BaseSpace account.
To unmount, run: basemount --unmount /mnt/remoteserv/switch/rundata/novaseq/PerkinsData
```


Then cd into anchor directory, followed by the Runs folder / your Run of Interest / Files

```
cd PerkinsData/Runs/MiscLibs_Lister_2019_10_11/Files
```

### 6. Start the download by rsync.
Exclude the thumbnail images. Save the log file as `copy.log` and point to the run folder you have created.

```
rsync -ahPr --exclude Thumbnail_Images * /dd_rundata/novaseq/Runs/191011_A00690_HL7HLDMXX_010 > /dd_rundata/novaseq/Runs/191011_A00690_HL7HLDMXX_010/copy.log
```


```
rsync -ahPr /d/home/hg19ips/hg19ips_samb/mcc_hg19ips/baseSpace/Runs/methylC_SB_DP_Lister_2020_12_31_300/Properties/Output.Samples/*/Files/*.fastq.gz /d/home/hg19ips/hg19ips_samb/mcc_hg19ips/data/unaligned/201231_A00690_0099_AHYNWNDRXX > /d/home/hg19ips/hg19ips_samb/mcc_hg19ips/data/unaligned/201231_A00690_0099_AHYNWNDRXX/copy.log &

rsync -ahPr /d/home/hg19ips/hg19ips_samb/mcc_hg19ips/baseSpace/Runs/methylC_SB_DP_Lister_2020_12_31_200/Properties/Output.Samples/*/Files/*.fastq.gz /d/home/hg19ips/hg19ips_samb/mcc_hg19ips/data/unaligned/201231_A00690_0098_BHJFTGDRXX > /d/home/hg19ips/hg19ips_samb/mcc_hg19ips/data/unaligned/201231_A00690_0098_BHJFTGDRXX/copy.log
```


### 7. Monitor the download by checking the copy.log. You can do this the following way

You can do this the following way:
```
tail -30 copy.log
```

```
jpflueger@PEB-SRVNIX-RAZOR:191011_A00690_HL7HLDMXX_010$ tail -30 copy.log
      4.09M 100% 1023.50kB/s    0:00:03 (xfer#210, to-check=1628/1847)
Data/Intensities/BaseCalls/L001/s_1_1324.filter
      4.09M 100%    1.02MB/s    0:00:03 (xfer#211, to-check=1627/1847)
Data/Intensities/BaseCalls/L001/s_1_1325.filter
      4.09M 100%    1.06MB/s    0:00:03 (xfer#212, to-check=1626/1847)
Data/Intensities/BaseCalls/L001/s_1_1326.filter
      4.09M 100%  942.91kB/s    0:00:04 (xfer#213, to-check=1625/1847)
Data/Intensities/BaseCalls/L001/s_1_1327.filter
      4.09M 100%    1.09MB/s    0:00:03 (xfer#214, to-check=1624/1847)
Data/Intensities/BaseCalls/L001/s_1_1328.filter
      4.09M 100% 1000.76kB/s    0:00:03 (xfer#215, to-check=1623/1847)
Data/Intensities/BaseCalls/L001/s_1_1329.filter
      4.09M 100%  995.73kB/s    0:00:03 (xfer#216, to-check=1622/1847)
Data/Intensities/BaseCalls/L001/s_1_1330.filter
      4.09M 100%    1.02MB/s    0:00:03 (xfer#217, to-check=1621/1847)
Data/Intensities/BaseCalls/L001/s_1_1331.filter
      4.09M 100%    1.05MB/s    0:00:03 (xfer#218, to-check=1620/1847)
Data/Intensities/BaseCalls/L001/s_1_1332.filter
      4.09M 100%    1.05MB/s    0:00:03 (xfer#219, to-check=1619/1847)
Data/Intensities/BaseCalls/L001/s_1_1333.filter
      4.09M 100%  991.50kB/s    0:00:03 (xfer#220, to-check=1618/1847)
Data/Intensities/BaseCalls/L001/s_1_1334.filter
      4.09M 100%  979.74kB/s    0:00:04 (xfer#221, to-check=1617/1847)
Data/Intensities/BaseCalls/L001/s_1_1335.filter
      4.09M 100%  991.50kB/s    0:00:03 (xfer#222, to-check=1616/1847)
```
The `to-check=1616/1847` component of that last line is counting down and once the download is complete should say 0/1847, for example.

Keep in mind, the Download usually takes several hours, depending on the run size.

### 8. What to do when the download is completed
Once download is completed, unmount basemount by returning to the parent folder of the anchor directory JahnviData or PerkinsData.
```
cd ../../../../
```

```
pwd
/dd_rundata/novaseq
```
You should now be in /dd_rundata/novaseq

To unmount:
```
basemount --unmount /mnt/remoteserv/switch/rundata/novaseq/JahnviData/
```
OR
```
basemount --unmount /mnt/remoteserv/switch/rundata/novaseq/PerkinsData/
```

**Dont forget to do this! Only one person can be mounted on basemount at a time!**

### 9. Generate fastq files from bcl files

cd into your run folder
```
cd /dd_rundata/novaseq/Runs/191011_A00690_HL7HLDMXX_010
```

You should have a SampleSheet.csv along with all your bcl files and other run files in this folder. Run bcl2fastq in another screen

```
screen -S demux
bcl2fastq -o Unaligned
```

Other parameters to consider running along with bcl2fastq:
if you have not enough Hamming distances between your barcodes
```
bcl2fastq -o Unaligned --barcode-mismatches 0
```

If you dont want to have your fastq files split by lane
```
bcl2fastq -o Unaligned --no-lane-splitting
```

### Troubleshooting

If your sample got no reads or fewer reads than expected, troubleshoot in the following ways:
 - Check the library log to ensure you entered the correct index sequence
 - Check the samplesheet.csv in the run folder to ensure that the correct index sequence was assigned to your sample
 - If there were no issues with index sequence check the following file in the Stats folder in the Unaligned directory
```
less /dd_rundata/novaseq/Runs/191011_A00690_HL7HLDMXX_010/Unaligned/Stats/demuxSummaryF1L1.txt
```

After first 100 or so lines, you will get a list of most popular unknown indexes sequences:
```
       1.071335        1.063684        1.064676        0.2302424       1.109662        1.049622
L1T2277 7.154946        1.853512        1.881119        1.73506 1.613993        2.027389        2.201867        1.843155        3.079277        4.345834        4.87351 4.078179        3.283837        4.658771        4.500906        3.350256        4.858028        5.569868        4.097549        4.74707 1.452134        1.566415        1.68119 1.679988        1.693067        1.743791        1.304379


### Most Popular Unknown Index Sequences
### Columns: Index_Sequence Hit_Count
GGGGGGGG+TCTTTCCC       14041640
GGGGGGGG+GCTTTCCC       495320
TCTCTACT+CGCGGGGC       167380
GGGGGGGG+TGTTTCCC       133420
AAAAAAAA+AAAAAAAA       92160
GGGGGGGG+GATATCGA       80500
GGGGGGGG+CCAACAGA       79400
GGGGGGGG+GGGGGGGG       68420
GGGGGGGG+TCTTTACC       62920
GGGGGGGG+TTGGTGAG       59180
GGGGGGGG+GAACATAC       57300
GGGGGGGG+TGCCTTAC       56640
GGGGGGGG+TCGTTCCC       56480
GGGGGGGG+TATGAGTA       55520
GGGGGGGG+CGCGGTTC       54260
```

The first set of 8 bp corresponds to the i7 indexes and the second set of 8 bp corresponds to the i5 indexes. Try to see if you can find an index that looks somewhat similar to the one for your missing sample. Sometimes if there are issues with reading the index quality, your data will end up in the `Undetermined.fastq` files.

Contact Jahnvi Pflüger, Daniel Poppe or Christian Pflüger via slack if you have questions or are stuck at some step.
