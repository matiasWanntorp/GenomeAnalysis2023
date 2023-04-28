#!/bin/bash -l
#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 08:00:00
#SBATCH -J polish_pilon
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load Pilon/1.24

#variables
INPUT_GENOME="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/polishing_pilon/polishing_pilon/pilon.fasta"
INPUT_BAM="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/aligningment_bwa/second_round_pilon_alignment_bwa/aln-pe.sorted.bam"
WD="$SNIC_TMP/genomeassemblypilon10"

# make new directory in temporary node storage
mkdir $SNIC_TMP/genomeassemblypilon10

#copy neccesary files there
cp $INPUT_GENOME $WD
cp $INPUT_BAM $WD
cp ${INPUT_BAM}.bai $WD

#change to WD
cd $WD

#Command
java -jar $PILON_HOME/pilon.jar --genome pilon.fasta --frags aln-pe.sorted.bam --diploid --output pilon%J

#copy output files back
cp pilon%J.fasta /home/matia/GenomeAnalysis2023/analysis/genome_assembly/polishing_pilon/test/

