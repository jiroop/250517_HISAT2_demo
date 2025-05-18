# Demo RNA-seq mapping pipeline that uses HISAT2 to make a small set of SE reads

## Features
-Assess read quality with FASTQC
-Trim reads with Trimmomatic
-Reassess read quality post trimmming
-Map reads to the gch38 human genome using HISAT2
-Use Samtools to convert the resulting SAM file to BAM
-Quantify expression counts using featureCounts

## Installation

# Clone this repository
cd 250517_HISAT2_demo

# Download the readfile and place it in the "data" directory
https://drive.usercontent.google.com/download?id=1DGHjbhcRy_zTm6H9C_AUpkzBML-JhtA3&export=download&authuser=0

# Create conda environment
conda env create -f environment.yml
conda activate 250512_RNA-seq_tutorial

# Run the analysis script
./scripts/RNASeqpipeline.sh 
