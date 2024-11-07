library(pheatmap)

#Read in count data
data = read.csv("Sponge_spirochetes.txt", header= TRUE, sep="\t", row.names =1)

#Convert data to matrix
df_num = as.matrix(data)

#Convert to presence/absence
df_num[df_num>0] <-1

#Read in gene info
gene_info = read.csv("Sponge_spirochetes_gene_info.txt", header= TRUE, sep="\t", row.names =1)

#Read in sponge host info 
sample_info = read.csv("Sponge_spirochetes_sample_info.txt", header= TRUE, sep="\t", row.names =1)

#Add in categorical info
my_colours <- c("white", "blue")

final <- pheatmap(df_num, annotation_row = gene_info, annotation_col = sample_info, cluster_rows = FALSE, cutree_cols = 3, col = my_colours, legend = FALSE, fontsize = 2)

