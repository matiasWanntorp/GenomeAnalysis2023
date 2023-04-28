#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J trim_RNA
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#Load modules
module load bioinfo-tools
module load trimmomatic/0.39

#variables
FORWARD="/home/matia/GenomeAnalysis2023/data/RNA_raw_data/RNA_scaffold_06.1.fastq.gz"
REVERSE="/home/matia/GenomeAnalysis2023/data/RNA_raw_data/RNA_scaffold_06.2.fastq.gz"
PREFIX="RNA_scaffold_06"

#command
java -jar $TRIMMOMATIC_ROOT/trimmomatic.jar PE $FORWARD $REVERSE \
${PREFIX}.1P.fastq.gz ${PREFIX}.1U.fastq.gz \
${PREFIX}.2P.fastq.gz ${PREFIX}.2U.fastq.gz \
ILLUMINACLIP:$TRIMMOMATIC_ROOT/adapters/TruSeq3-PE.fa:2:30:10:2:True LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36


