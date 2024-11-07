library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(vegan)
library(grid)
#Load data
chem <- read.csv('chem_data.txt', row.names=1, header=T, sep="\t")
otus <- read.csv('otu_data.txt', row.names=1, header=T, sep="\t")

#Run correlation analysis between two datasets
corr_matrix <- cor(chem,otus)

#Write out results
write.table(corr_matrix,file="correlation_matrix.txt")


#Generate heatmap of results
library(tidyr)
library(ggplot2)
library(colorspace)

melted = melt(as.matrix(corr_matrix))

ggplot(data = melted, mapping = aes(x = Var2, y = Var1, fill = value),fill = "transparent") +
  geom_tile() +
  xlab(label = "OTU") + xlab(label = "Compound group") +
  scale_fill_continuous_diverging(palette = "Blue-Red 2") +
  theme(axis.text.y = element_text(size = 10, color="black"), 
        axis.text.x = element_text(angle=90, hjust=1, size =10, color="black"), 
        axis.title.x =element_text(size=10, color="black"), 
        axis.title.y =element_text(size=10, color ="black"),
        panel.background = element_rect(fill = "transparent"),
        plot.background = element_rect(fill = "transparent"), 
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
