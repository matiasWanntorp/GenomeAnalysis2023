#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 02:00:00
#SBATCH -J maskrepeats
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#Load modules
module load bioinfo-tools
module load RepeatMasker/4.1.2-p1

#variables
INPUT="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/polishing_pilon/polishing_pilon/pilon.fasta"
OUTDIR="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/repeat_masked_assembly"

#commands
RepeatMasker -pa 2 -xsmall -species durian -dir $OUTDIR $INPUT
