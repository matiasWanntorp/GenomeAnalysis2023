#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 10
#SBATCH -t 06:00:00
#SBATCH -J raw_polish_pilon
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load Pilon/1.17

#variables
INPUT_GENOM="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/assembly_canu/03_canu_assembly/canu_assembly.contigs.fasta "
INPUT_BAM="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/aligningment_bwa/02_alignment_bwa/aln-pe.sorted.bam"

#Command
java -Xmx48G -jar $PILON_HOME/pilon.jar --genome $INPUT_GENOM --bam $INPUT_BAM --outdir /home/matia/GenomeAnalysis2023/analysis/genome_assembly/polishing_pilon/02_polishing_pilon_canu --diploid --chunksize 30000 --output xmx_test


