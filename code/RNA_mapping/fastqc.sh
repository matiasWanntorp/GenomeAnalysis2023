#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 01:00:00
#SBATCH -J fastqc
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#Load modules
module load bioinfo-tools
module load FastQC/0.11.9

#variables
FORWARD="/home/matia/GenomeAnalysis2023/analysis/pre-processing/RNA_pre-processing/trimming_results/RNA_scaffold_06.1P.fastq.gz"
REVERSE="/home/matia/GenomeAnalysis2023/analysis/pre-processing/RNA_pre-processing/trimming_results/RNA_scaffold_06.2P.fastq.gz"

#commands
fastqc $FORWARD
fastqc $REVERSE


