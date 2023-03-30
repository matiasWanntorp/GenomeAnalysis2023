#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 18:00:00
#SBATCH -J canu_durian_assembly
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com
#SBATCH --error=canu_durian_assembly.%J.err


#Load modules
module load bioinfo-tools
module load canu/2.0

#Variables
INPUT="/home/matia/genome_analysis/data/DNA_raw_data/pacbio_data/pacbio_scaffold_06.fq.gz"
OUTPUT="/home/matia/genome_analysis/analysis/genome_assembly/assembly_canu/02_canu_assembly"

# commands
canu -p canu_assembly -d $OUTPUT maxThreads=4 genomeSize=28.5m corOutCoverage=200 "batOptions=-dg 3 -db 3 -dr 1 -ca 500 -cp 50"  -pacbio-raw $INPUT
