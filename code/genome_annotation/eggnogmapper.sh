#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 2
#SBATCH -t 08:00:00
#SBATCH -J functional_annotation
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load module
module load bioinfo-tools
module load eggNOG-mapper/2.1.9

#variable
PROT="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/annotation_BRAKER_canu/braker/prot.fa"
OUT_DIR="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/annotation_BRAKER_canu/eggnog"
GFF="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/annotation_BRAKER_canu/braker/braker.gff3"

#commands
/sw/bioinfo/eggNOG-mapper/2.1.9/snowy/bin/emapper.py \
-i $PROT --itype proteins --output func_annot --output_dir $OUT_DIR \
--decorate_gff $GFF --cpu 2

