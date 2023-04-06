#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 03:15:00
#SBATCH -J busco_eval_raw
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load BUSCO

#commands
run_BUSCO.py -l $BUSCO_LINEAGE_SETS/eudicots_odb10 -o canu_raw_BUSCO -i /home/matia/GenomeAnalysis2023/analysis/genome_assembly/assembly_canu/03_canu_assembly/canu_assembly.contigs.fasta -m genome

