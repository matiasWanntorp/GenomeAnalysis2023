#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 8
#SBATCH -t 20:00:00
#SBATCH -J structural_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load braker/2.1.6

#variables
GENOME="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/repeat_masked_assembly/pilon.fasta.masked"
bam_DIR="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/RNA_mapping"
declare -a bam_list=("SRR6040092_06.sorted.bamAligned.sortedByCoord.out.bam" "SRR6040093_06.sorted.bamAligned.sortedByCoord.out.bam" "SRR6040094_06.sorted.bamAligned.sortedByCoord.out.bam" "SRR6040096_06.sorted.bamAligned.sortedByCoord.out.bam" "SRR6040097_06.sorted.bamAligned.sortedByCoord.out.bam" "SRR6156066_06.sorted.bamAligned.sortedByCoord.out.bam" "SRR6156067_06.sorted.bamAligned.sortedByCoord.out.bam" "SRR6156069_06.sorted.bamAligned.sortedByCoord.out.bam")

#${bam_DIR}/${bam_list[1]}, ${bam_DIR}/${bam_list[2]}, ${bam_DIR}/${bam_list[3]}, ${bam_DIR}/${bam_list[4]}, \
#${bam_DIR}/${bam_list[5]}, ${bam_DIR}/${bam_list[6]}, ${bam_DIR}/${bam_list[7]}, ${bam_DIR}/${bam_list[8]}

#commands
 braker.pl \
--AUGUSTUS_CONFIG_PATH /home/matia/augustus_config \
--species durian  --genome $GENOME \
--bam=${bam_DIR}/finalBamFile.bam \
--cores 8 \
--gff3 \
--softmasking 
