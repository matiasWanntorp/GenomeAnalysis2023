#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 10:00:00
#SBATCH -J structural_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load htseq/2.0.2

#variables
GTF_PATH="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/annotation_BRAKER_canu/braker/braker.gff3"
BAM_DIR="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/RNA_mapping"
OUT_DIR="/home/matia/GenomeAnalysis2023/analysis/de_analysis/htseq"

#commands

#arils
htseq-count -f bam -r pos -i ID -n 2  -c ${OUT_DIR}/aril.tsv ${BAM_DIR}/arils.sorted.bam $GTF_PATH 

#stem
htseq-count -f bam -r pos -i ID -n 2  -c ${OUT_DIR}/stem.tsv ${BAM_DIR}/SRR6040096_06.sorted.bamAligned.sortedByCoord.out.bam $GTF_PATH

#root
htseq-count -f bam -r pos -i ID -n 2 -c ${OUT_DIR}/root.tsv ${BAM_DIR}/SRR6040093_06.sorted.bamAligned.sortedByCoord.out.bam $GTF_PATH

#leaf
htseq-count -f bam -r pos -i ID -n 2 -c ${OUT_DIR}/leaf.tsv ${BAM_DIR}/SRR6040092_06.sorted.bamAligned.sortedByCoord.out.bam $GTF_PATH
