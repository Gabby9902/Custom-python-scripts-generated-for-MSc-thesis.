library(vegan)

abund = read.csv("Spirochete_KEGG_DATA.txt", header= TRUE, sep="\t")

#ANOSIM
# Create an empty data frame to store results
result_df <- data.frame(Host1 = character(), Host2 = character(), Rvalue = numeric(), Pvalue = numeric(), stringsAsFactors = FALSE)

groups = unique(abund[c("Broad_host")])
group_list = as.list(groups$Broad_host)

for (i in group_list) {
  for (j in group_list) {
    if (i==j) next
    sub_df1 = subset(abund, subset=(Broad_host==i))
    sub_df1_rows = nrow(sub_df1)
    if (sub_df1_rows == 1) next
    sub_df2 = subset(abund, subset=(Broad_host==j))
    sub_df2_rows = nrow(sub_df2)
    if (sub_df2_rows == 1) next
    sub_df = rbind(sub_df1, sub_df2)
    nums = sub_df[,4:ncol(sub_df)]
    nums_matrix = as.matrix(nums)
    set.seed(123)
    ano = anosim(nums_matrix, sub_df$Broad_host, distance = "bray", permutations = 9999)
    Rvalue = ano$statistic
    pvalue = ano$signif
    result_df <- rbind(result_df, data.frame(Host1 = i, Host2 = j, Rvalue = Rvalue, Pvalue = pvalue))
  }
}

write.table(result_df, "ANOSIM_results.txt", sep = "\t", row.names = FALSE)

