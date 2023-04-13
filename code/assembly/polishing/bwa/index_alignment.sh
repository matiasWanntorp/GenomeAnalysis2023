#!/bin/sh

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 1
#SBATCH -t 05:00:00
#SBATCH -J index_alignment
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load bwa/0.7.17
module load samtools
module load BEDTools

#variables
OUTPUT="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/aligningment_bwa/test_alignment_bwa"
REF="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/reduction_redundans/CANU_reduced/contigs.reduced.fa"
INPUT1="/home/matia/GenomeAnalysis2023/data/DNA_raw_data/illumina_data/illumina_scaffold_06.1P.fastq.gz"
INPUT2="/home/matia/GenomeAnalysis2023/data/DNA_raw_data/illumina_data/illumina_scaffold_06.2P.fastq.gz"

#Commands

#index reference genome
bwa index $REF

#align reads to indexed reference
bwa mem -P $REF $INPUT1 $INPUT2 > aln-pe.sam

#convert to bam, sort and index
samtools sort aln-pe.sam -o aln-pe.sorted.bam
samtools index aln-pe.sorted.bam

# convert to bed
bedtools bamtobed -i aln-pe.sorted.bam
