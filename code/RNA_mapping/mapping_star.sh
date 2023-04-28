#!/bin/bash -l

#SBATCH -A uppmax2023-2-8
#SBATCH -M snowy
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 15:00:00
#SBATCH -J index_map
#SBATCH --mail-type=ALL
#SBATCH --mail-user matiaswanntorp@gmail.com

#load modules
module load bioinfo-tools
module load star/2.7.9a

#Variables
GENOME_DIR="/home/matia/GenomeAnalysis2023/analysis/genome_annotation/repeat_masked_assembly"
RNA_DIR="/home/matia/GenomeAnalysis2023/analysis/pre-processing/RNA_pre-processing/trimming_results"
suffix_1="scaffold_06.1.fastq.gz"
suffix_2="scaffold_06.2.fastq.gz"

#commands

#make index
STAR --runThreadN 4 \
--runMode genomeGenerate \
--genomeDir $GENOME_DIR \
--genomeFastaFiles ${GENOME_DIR}/pilon.fasta.masked

#mapping

declare -a arr=("SRR6040092" "SRR6040093" "SRR6040094" "SRR6040096" "SRR6040097" "SRR6156066" "SRR6156067" "SRR6156069")

for pref in "${arr[@]}"
do

echo $pref
echo ${pref}_${suffix_1}

STAR --runThreadN 4 \
--genomeDir $GENOME_DIR \
--readFilesIn ${RNA_DIR}/${pref}_${suffix_1} ${RNA_DIR}/${pref}_${suffix_2} \
--readFilesCommand zcat \
--outSAMtype BAM SortedByCoordinate \
--outSAMunmapped Within \
--outSAMattributes Standard \
--outFileNamePrefix ${pref}_06.sorted.bam

done

#cp *_06.sorted.bam /home/matia/GenomeAnalysis2023/analysis/genome_annotation/RNA_mapping/

