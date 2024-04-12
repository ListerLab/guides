# Plasmid-seq Lister Lab pipeline HOWTO 


Login to kaya with ssh
```sh
username@kaya.hpc.uwa.edu.au
```
Navigate to the shared Plasmid\-\-seq location
```sh
cd /group/llshared/PlasmidSeq/
```
Edit or copy the `PL_to_fasta.tsv` file such that it reflects the entry of the plasmid\-seq tab on the google drive `PL_to_tsv`\. Check with the following command that it has updated\.
```sh
head PL_to_fasta.tsv
```
PL11051	pGE\_366\.fa
PL11052	pGE\_366\.fa
PL11053	pGE\_367\.fa
\.\.\.
Download the `Fasta_Reference` folder from google drive and scp it to Kaya shared Plasmid\-Seq location (Execute this command in a different terminal to Kaya)
```sh
scp /Users/computer_username/Downloads/Fasta_Reference_Files.zip username@kaya.hpc.uwa.edu.au:/group/llshared/PlasmidSeq/
```
Unzip the files (From here on execute these commands back on the Kaya terminal)
```sh
unzip Fasta_Reference_Files.zip

```
Request an interactive session to download files from basespace onto Kaya server
```sh
srun --time=1:00:00 --account={{username}} --partition=peb --nodes=1 --ntasks=1 --cpus-per-task=2 --mem-per-cpu=10G --pty /bin/bash -l
```
Navigate to the sequencing data location
```sh
cd /group/llshared/sequencing_data/Miseq/
```
Check for the run on basespace with the basespace command line interface `bs`\. 
**NOTE\:** The first time you run any `bs` command you will need to authenticate with\. Skip this step if you have already done that\.
```sh
mkdir $HOME/bin
wget "https://launch.basespace.illumina.com/CLI/latest/amd64-linux/bs" -O $HOME/bin/bs
chmod +x /home/username/bin/bs
export PATH="$HOME/bin:$PATH"
bs auth --api-server https://api.aps2.sh.basespace.illumina.com (Then login on browser)
```
```sh
bs runs list
```
Create a folder with the name of the last run \(Miseq\)\. Check that the numbering adds up after the Instrument identifier `M01769`
```sh
mkdir 240411_M01769_0145_000000000-DNWNM
cd 240411_M01769_0145_000000000-DNWNM
```
Get the run ID from basespace which is shown in the 2nd column 
```sh
bs runs list
240411_M01769_0147_000000000-DNWNM | 3933946
```
Download the run from BaseSpace
```sh
bs runs download --concurrency=high --exclude="Thumbnail*" -i 3933946
```
Run BCLconvert to get the fastq files
```sh
bcl-convert --bcl-input-directory .  --bcl-num-conversion-threads 8 --bcl-num-parallel-tiles 3 --bcl-num-compression-threads 4 --output-directory ./fastqs --bcl-sampleproject-subdirectories true
```
**Important**\: change the permissions so everyone in the lister group can access the run
```sh
chmod -R 771 /group/llshared/sequencing_data/Miseq/240411_M01769_0145_000000000-DNWNM/
```
## Final checks
- [ ] Fastq files have been created
- [ ]  PL\_to\_fastq\.tsv file has been updated
- [ ] fasta reference files haven been downloaded\, unzipped and the folder name is `Fasta_Reference_Files`
## Launch plasmid\-seq SLURM pipeline
Get the path to the fastq files e\.g\. `/group/llshared/sequencing_data/Miseq/240411_M01769_0145_000000000-DNWNM/fastqs`
**IMPORTANT\:** Navigate to the shared plasmid\-seq folder\: 
```sh
cd /group/llshared/PlasmidSeq/
```
schedule plasmid\-seq with your email address and the path to the fastq files 
```sh
sbatch  --mail-user={{yourname@uwa.edu.au}} --cpus-per-task=24 plasmidseq_SLURM.sh /group/llshared/sequencing_data/Miseq/240411_M01769_0145_000000000-DNWNM/fastqs
```
- [ ] create the `Aligned` folder\:
```sh
mkdir /group/llshared/sequencing_data/Miseq/240411_M01769_0145_000000000-DNWNM/Aligned
```
- [ ] copy mapped Plasmid\-seq data from your directory to the Aligned folder
```sh
cp ~/work/plasmidSeq_2024-04-12/438830/* /group/llshared/sequencing_data/Miseq/240411_M01769_0145_000000000-DNWNM/Aligned
```
- [ ] open up permissions
```sh
chmod -R 771 /group/llshared/sequencing_data/Miseq/240411_M01769_0145_000000000-DNWNM/Aligned
```
Share results with the plasmid\-seq channel on SLACK \- Hooray\!