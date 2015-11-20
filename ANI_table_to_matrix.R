# convert ANI table to matrix

library(plyr)
library(igraph)

# read file containing the ANI calculator output
ani <- read.table("~/Desktop/McMahon Lab/ANI_workflow/testfile.txt",sep="\t", header=T)

# remove even rows
ani <- ani[seq(1,nrow(ani),2),]

# create full un-duplicated ANI table.
ani1 <- ani[,c(1,2,3)] # ANI, 1->2 order
ani2 <- ani[,c(2,1,4)] # ANI, 2->1 order
names(ani2) <- names(ani1)
ani1 <- rbind(ani1,ani2) 
ani1 <- ani1[-which(duplicated(ani1[,1:2])==T),] #remove duplicates

#create weighted ADJACENCY matrix
ani_graph <- graph.data.frame(ani1)
E(ani_graph)$weight <- ani1$ANI.1..2
adj_matrix <- as_adjacency_matrix(ani_graph,attr="weight")
diag(adj_matrix) <- rep(100,nrow(adj_matrix)) # the adjacency matrix is complete

# create a regular matrix
ani_matrix <- as.matrix(adj_matrix)
# replace the diagonal with 100
diag(ani_matrix) <- rep(100,nrow(ani_matrix))
# replace the absent values become 0

# visualize: create heat map
ani_heat <- heatmap(ani_matrix,Colv=NA,Rowv=NA,symm=F,col=gray.colors(10000,.9844,1),scale="column",margins=c(13,13))
ani_heat


# remaining questions
# what type of clustering to use when clustering?
# complete-linkage, incomplete-linkage, hierarchical, average neighbor, etc.?
