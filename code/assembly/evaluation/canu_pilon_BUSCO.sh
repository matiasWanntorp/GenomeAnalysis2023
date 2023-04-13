#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 03:15:00
#SBATCH -J busco_eval_pilon
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load BUSCO

#Variables
INPUT="/home/matia/GenomeAnalysis2023/analysis/genome_assembly/polishing_pilon/polishing_pilon/pilon.fasta"

#commands
run_BUSCO.py -l $BUSCO_LINEAGE_SETS/eudicots_odb10 -o canu_pilon_BUSCO -i $INPUT -m genome
