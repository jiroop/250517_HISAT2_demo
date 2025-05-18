#!/bin/bash

SECONDS=0


# STEP1 Run Fastqc
fastqc ./data/demo.fastq -o data/ 
echo "Fastq has finished running!"

# Run trimmomatic to trim reads with poor quality and remove short  reads, then rerun fastqc

trimmomatic SE data/demo.fastq data/demo_trimmed.fastq SLIDINGWINDOW:4:20 MINLEN:36 -phred33
echo "Trimmomatic has finished running!"

fastqc ./data/demo_trimmed.fastq -o ./data/

# STEP2: Run HISAT2
mkdir -p HISAT2

# Run wget to get the HISAT human genome index
#wget -P ./HISAT2 https://genome-idx.s3.amazonaws.com/hisat/grch38_genome.tar.gz

# extract the tarball
echo "Extracting the Genome index"
tar -xzf  ./HISAT2/grch38_genome.tar.gz -C ./HISAT2/ #&& rm ./HISAT2/grch38_genome.tar.gz
 
# Run alignment
echo "Running HISAT2"
hisat2 -q --rna-strandness R -x ./HISAT2/grch38/genome -U ./data/demo_trimmed.fastq | samtools sort -o ./HISAT2/demo_trimmed.bam
echo "HISAT2 has finished running"


# STEP 3: Run feature Counts for quantification

# Get the human GTF file
wget -P ./  https://ftp.ensembl.org/pub/release-114/gtf/homo_sapiens/Homo_sapiens.GRCh38.114.gtf.gz
gunzip -f Homo_sapiens.GRCh38.114.gtf.gz

# Run feature counts
mkdir -p quants
featureCounts -S 2 -a ./Homo_sapiens.GRCh38.114.gtf -o quants/demo_featurescounts.txt HISAT2/demo_trimmed.bam
echo "featureCounts has finished running"


duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds have elapsed."