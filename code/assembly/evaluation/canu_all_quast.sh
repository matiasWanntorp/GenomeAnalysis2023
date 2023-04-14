#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 00:40:00
#SBATCH -J quast_eval_all
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load quast/5.0.2

#variables
INPUT_01="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/assembly_canu/03_canu_assembly/canu_assembly.contigs.fasta" 
OUTPUT_01="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/evaluation_quast/canu_quast_evaluation/canu_raw_quast"

INPUT_02="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/reduction_redundans/CANU_reduced/contigs.reduced.fa" 
OUTPUT_02="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/evaluation_quast/canu_quast_evaluation/canu_redundans_quast"

INPUT_03="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/polishing_pilon/polishing_pilon/pilon.fasta"
OUTPUT_03="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/evaluation_quast/canu_quast_evaluation/canu_pilon_quast"

REFERENCE="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/evaluation_quast/refernce_scaffold/reference_scaffold_06.fa"

#commands
quast.py $INPUT_01 -o $OUTPUT_01 --gene-finding --eukaryote -r $REFERENCE
quast.py $INPUT_02 -o $OUTPUT_02 --gene-finding --eukaryote -r $REFERENCE
quast.py $INPUT_03 -o $OUTPUT_03 --gene-finding --eukaryote -r $REFERENCE

