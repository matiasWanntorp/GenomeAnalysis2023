#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 04:00:00
#SBATCH -J structural_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load htseq/2.0.2
module load samtools

#variables
GTF_PATH="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/annotation_BRAKER_canu/braker/braker.gff3"
BAM_DIR="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/RNA_mapping"
OUT_DIR="/home/matia/GenomeAnalysis2023/analysis/de_analysis/htseq"

#commands

for file in ${BAM_DIR}/*.bam 
do
samtools index $file

done

echo ${BAM_DIR}/*.bam

htseq-count -f bam -r pos -i ID -n 2 -c ${OUT_DIR}/all.tsv ${BAM_DIR}/*.bam $GTF_PATH
