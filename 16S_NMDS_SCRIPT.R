#Generating barplot of top20 OTUs from only 2019 samples

library(ggplot2)
library(reshape2)
library(RColorBrewer)
library(vegan)
library(grid)

#Generate 3D NMDS plot from all OTUs in 2019
abund = read.csv("Chemotype_NMDS.txt", header= TRUE, sep="\t")

#make community matrix - extract columns with abundance information
nums = abund[,3:ncol(abund)]

#turn abundance data frame into a matrix
nums_matrix = as.matrix(nums)

#Now to create our 3D plot
set.seed(123)
nmds = metaMDS(nums_matrix, k=3, distance = "bray")
scores(nmds, "sites")

#extract NMDS scores (x,y and z coordinates)
data.scores = as.data.frame(scores(nmds, "sites"))

#add columns to data frame 
data.scores$Sample = abund$Sample
data.scores$Species = abund$Species

head(data.scores)

#Load up libraries
library(plotly)

#Generate plot
plot_3D <- plot_ly(data.scores, x = ~NMDS1, y = ~NMDS2, z = ~NMDS3, color = ~Species, marker = list(size = 5), text = ~paste('<br>Sample:', Sample, '<br>Species:', Species)) %>%
  add_markers() %>%
  layout(scene = list(xaxis = list(title = 'NMDS1'),
                      yaxis = list(title = 'NMDS2'),
                      zaxis = list(title = 'NMDS3')))
#Show plot
plot_3D


#Calculate pairwise ANOSIM scores, grouped by Species

#Find unique groups in data
groups = unique(abund[c("Species")])
group_list = as.list(groups$Species)

#Calculate pairwise ANOSIM statistics
for (i in group_list) {
  for (j in group_list) {
    if (i==j) next
    sub_df1 = subset(abund, subset=(Species==i))
    sub_df2 = subset(abund, subset=(Species==j))
    sub_df = rbind(sub_df1, sub_df2)
    nums = sub_df[,3:ncol(sub_df)]
    nums_matrix = as.matrix(nums)
    set.seed(123)
    ano = anosim(nums_matrix, sub_df$Species, distance = "bray", permutations = 9999)
    Rvalue = ano$statistic
    pvalue = ano$signif
    cat(i,"\t",j ,"\tR-value:\t", Rvalue, "\tP-value:\t", pvalue, '\n')
    
  }
}


