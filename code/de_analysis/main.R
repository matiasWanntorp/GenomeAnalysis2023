#set seed for reproducability
set.seed(5)
#Differential expression analysis on differetn plant organs of Durio zibethinus
#############---Library + installations---#############
if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("DESeq2")
BiocManager::install("sva")
BiocManager::install("fgsea")
BiocManager::install("ReportingTools")

#load libraries
library(tidyverse)
library(airway)
library(DESeq2)
library(sva)
library(tibble)
library(dplyr)

#############---pre-processing---#############
#read count file
read_count <- read.delim("../htseq/all.tsv", row.names = 1)
head(read_count)

#only include musang_king as to exclude any confounding factors (we only have arils from monthong)
read_count <- read_count[,0:5]
head(read_count)

#remove ".exon" part of count file (counts were made for separate exons but we are interested in genes)
read_count_no_exon <- tibble::rownames_to_column(read_count, var="X.query")
read_count_no_exon$X.query <- sub("\\.exon.*", "", read_count_no_exon$X.query)

#collapse counts for a gene
read_count_no_exon %>%
  group_by(X.query) %>%
  summarise_all(sum) %>%
  data.frame() -> gene_read_counts

#remove rows with alignment data ex "__alignment_not_unique".. etc..
gene_read_counts <- tail(gene_read_counts, -5)
rownames(gene_read_counts)[1] <- ""

#set rownames
rownames(gene_read_counts) <- gene_read_counts[, 1]
gene_read_counts[, 1] <- NULL

#read meta-data (what plant organs etc.)
column_info <- read.delim("../htseq/column.data.tsv", row.names = 1)
column_info <- column_info[0:5,]

#check that all samples are in column_info
all(colnames(read_count) %in% rownames(column_info))
#check that they're in the same order in both files
all(colnames(read_count) == rownames(column_info))

#############---make dds-object---#############
#create dds object
dds <- DESeqDataSetFromMatrix(countData = gene_read_counts,
                              colData = column_info,
                              design = ~ tissue)
#############---PCA---#############
rld <- rlog(dds)
plotPCA(rld, intgroup=c("tissue", "organ") )

#############---DESeq2---#############
#remove rows with less than 10 reads (?)
keep <- rowSums(counts(dds)) >= 10
dds <- dds[keep,]

#relevel to make sure nonfruit is reference (this means that genes shown as downregulated are downregulated in fruits compared to nonfruits)
dds$tissue <- relevel(dds$tissue, ref = "nonfruit")

#run DESeq
dds <- DESeq(dds)
res <- results(dds, contrast = c("tissue", "fruit", "nonfruit"))

#plot log2 fold change
plotMA(res, alpha = 0.1, main="MA Plot", xlab = "mean of normalized counts", colNonSig = "gray60",
       colSig = "#00AFBB",
       colLine = "grey40",
       returnData = FALSE,
       MLE = FALSE, ylim = c(-12,12))

#Sort genes by log2 fold change after shrinkage(shrinkage is default in DESeq2)
resOrdered <- res[order(res$padj),]
resOrdered <- res[order(res$log2FoldChange, decreasing = TRUE),]
#############---substitute BRAKER annotations with eggNOG annotations (seed_orthologs)---#############
#read annotations file
annotations <- read.delim("../../genome_annotation/func_annot.emapper.annotations", header=TRUE,  sep="\t")
seed_orthologs <- annotations[, c("X.query", "seed_ortholog")]
head(seed_orthologs)

#make DESeq results object into data frame
# Convert DESeq results object to a data frame
res_df <- as.data.frame(resOrdered)

# Print the first few rows of the data frame
res_df <- tibble::rownames_to_column(res_df, var="X.query")

#merge data on seed_ortholog 
merged_data <- merge(seed_orthologs, res_df)
head(merged_data)

rownames(merged_data) <- merged_data[,1]
merged_data$X.query <- NULL
#############---Visualisation of DE---#############
library(tidyverse)
library(RColorBrewer)
library(ggrepel)

#VOLCANO PLOT
vc.df <- merged_data
vc.df$diffexpressed <- 'NO'
vc.df$diffexpressed[vc.df$log2FoldChange > 1 & vc.df$padj < 0.05] <- 'UP'
vc.df$diffexpressed[vc.df$log2FoldChange < -1 & vc.df$padj < 0.05] <- 'DOWN'

# Create a new column "delabel" to de, that will contain the name of up regulated genes
vc.df$delabel <- ifelse(vc.df$diffexpressed == 'UP', vc.df$seed_ortholog, NA)

#theme
theme_set(theme_classic(base_size = 20) +
            theme(
              axis.title.y = element_text(face = "bold", margin = margin(0,20,0,0), size = rel(1.1), color = 'black'),
              axis.title.x = element_text(hjust = 0.5, face = "bold", margin = margin(20,0,0,0), size = rel(1.1), color = 'black'),
              plot.title = element_text(hjust = 0.5, size = 20, face = 'bold')
            ))

ggplot(data = vc.df, aes(x = log2FoldChange, y = -log10(padj), col = diffexpressed)) +
  geom_vline(xintercept = c(0), col ='gray', linetype ='dashed') +
  geom_hline(yintercept = c(-log10(0.05)), col = 'gray', linetype = 'dashed') +
  geom_point() +
  scale_color_manual(values = c("#00AFBB","grey", "#bb0c00"), labels = c("Downregulated", "Not significant", "Upregulated")) +
  coord_cartesian(ylim = c(0, 4), xlim = c(-12, 12)) + # since some genes can have minuslog10padj of inf, we set these limits
  labs(color = 'Aril', #legend_title, 
       x = expression("log"[2]*"FC"), y = expression("-log"[10]*"p-value")) + 
  scale_x_continuous(breaks = seq(-10, 10, 2)) +
  ggtitle("Diffrentially expressed genes in fruit tissue vs non fruit tissue")

#HEAT MAP
BiocManager::install("ComplexHeatmap")
library(ComplexHeatmap)
library("org.Hs.eg.db")
library(AnnotationDbi)

#extract significant genes only
alpha <- 0.05
sig_genes <- merged_data[which(merged_data$padj < alpha),]
summary(sig_genes)
head(sig_genes)

#make sig genes a data frame
sigs.df <- as.data.frame(sig_genes)

#extract top up and down regulated and add to a new data frame
top_upregulated <- head(sigs.df[order(sigs.df$log2FoldChange, decreasing=TRUE),], 7)
top_downregulated <- head(sigs.df[order(sigs.df$log2FoldChange, decreasing=FALSE),], 10)
top_genes <- rbind(top_upregulated, top_downregulated)

#create a matrix
mat <- counts(dds, normalized = T)[rownames(top_genes),]
mat.z <- t(apply(mat, 1, scale))
colnames(mat.z) <- rownames(column_info)
head(mat)
head(mat.z)

#name columns
column_names <- c("leaf", "root", "aril1", "stem", "aril2")
row_names <- c("EOY23274", "Gorai.008G195400.1", "Gorai.004G182900.1", "Gorai.008G193900.1", "EOY24996",
               "EOY22273", "EOY24808", "EOY24623", "EOY24868", "Gorai.006G046200.1",
               "EOY22696", "EOY24979", "EOY24979", "EOY20890", "EOY24422",
               "EOY24871", "EOY23760")

#color
library(circlize)
col_fun = colorRamp2(c(-2, 0, 2), c("#00AFBB", "white", "#bb0c00"))

#plot heatmap
Heatmap(mat.z, cluster_rows = T, cluster_columns = T, column_labels = column_names, row_labels = row_names,
        name = "Z-score", col = col_fun)

#############---analysis of metabolic pathways---#############
# I need to extract all gene names and there ko numbers from sig genes
KEGG_ko <- annotations[, c("X.query", "KEGG_ko")]
head(KEGG_ko)

#make DESeq results object into data frame
# Convert DESeq results object to a data frame
df.sig_genes <- as.data.frame(sig_genes)

# Print the first few rows of the data frame
df.sig_genes <- tibble::rownames_to_column(df.sig_genes, var="X.query")

#merge data on seed_ortholog 
sig_KEGG <- merge(KEGG_ko, df.sig_genes, by = "X.query")

#get up regulated
sig_KEGG_up <- head(sig_KEGG[order(sig_KEGG$log2FoldChange, decreasing=TRUE),], 7)

#get down regulated
sig_KEGG_down <- head(sig_KEGG[order(sig_KEGG$log2FoldChange, decreasing=FALSE),], 158)

#extract column and make tab delimited
library(dplyr)
new_df_up <- data.frame(sig_KEGG_up$seed_ortholog, sig_KEGG_up$KEGG_ko)
new_df_down <- data.frame(sig_KEGG_down$seed_ortholog, sig_KEGG_down$KEGG_ko)

write.table(new_df_up, "upregul_kegg.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
write.table(new_df_down, "downregul_kegg.txt", sep = "\t", row.names = FALSE, col.names = FALSE, quote = FALSE)
