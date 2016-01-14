#151201_ANI_Bacteroidetes

# Step 1: look at heat map of entire group
# convert ANI table to matrix

library(plyr)
library(igraph)

# read file containing the ANI calculator output
ani <- read.table("~/Desktop/McMahon Lab/data/ANIoutput_151124_v2.txt",sep="\t", header=T) #took a few seconds

# remove even rows
ani <- ani[seq(1,nrow(ani),2),]

# create full un-duplicated ANI table.
ani1 <- ani[,c(1,2,3)] # ANI, 1->2 order
ani2 <- ani[,c(2,1,4)] # ANI, 2->1 order
names(ani2) <- names(ani1)
ani1 <- rbind(ani1,ani2) #nrow(ani1) =  2896610
ani1 <- ani1[-which(duplicated(ani1[,1:2])==T),] #remove duplicates #nrow(ani1) = 1448412 # this is 1204*1204-1204.
#ani1[,3] <- as.numeric(levels(ani[,3]))[ani[,3]]
ani1$ANI.1..2. <- as.numeric(as.character(ani1$ANI.1..2.)) #converts column 3 of ani1 to factor

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
heatmap(ani_matrix,Colv=NA,Rowv=NA,symm=F,col=gray.colors(10000,.9844,1),scale="column",margins=c(13,13))
heatmap(ani_matrix,Colv=NA,Rowv=NA,symm=F,col=gray.colors(10000,0,1),scale="column",margins=c(13,13))
heatmap(ani_matrix,symm=F,col=gray.colors(10000,0,1),scale="column",margins=c(13,13))
heatmap(ani_matrix,symm=F,col=gray.colors(10000,0,1),scale="column")
heatmap(ani_matrix,symm=T,col=gray.colors(10000,0,1),scale="column",labRow=rep("",1204),labCol=rep("",1204)) #this removes names in the heat map
heatmap(ani_matrix,symm=T,col=gray.colors(10000,0,1),scale="column",margins=c(13,13))

hist(ani1$ANI.1..2[which(ani1$ANI.1..2>50 & ani1$ANI.1..2!=100)])

hist(ani1$ANI.1..2)
hist(ani1$ANI.1..2[which(ani1$ANI.1..2<60)])
hist(ani1$ANI.1..2[which(ani1$ANI.1..2>50)])
hist(ani1$ANI.1..2[which(ani1$ANI.1..2>50 & ani1$ANI.1..2!=100)])
length(which(ani1$ANI.1..2==100)) #species?
length(ani1$ANI.1..2[which(ani1$ANI.1..2>50 & ani1$ANI.1..2!=100)])


# There are comparisons that have ANI==0
nrow(ani1)
nrow(ani1[which(ani1$ANI.1..2==0),])
#[1] 3150
nrow(ani1[which(ani1$ANI.1..2==0),])/nrow(ani1) #0.2% of comparisons had 0% ANI
# other than the 0-values, there are no ANI values below 59
min(ani1$ANI.1..2[which(ani1$ANI.1..2>0)])
[1] 59.08
# find AF of those comparisons where ANI = 0
head(ani[which(ani$ANI.1..2==0),])

#look at ANI values in the actual range of ANI values.
hist(ani1$ANI.1..2[which(ani1$ANI.1..2>0)],main="Histogram of ANI values > 0",xlab="ANI values > 0")

# edit names in a cluster diag

#for the ANI values that are equal to 0, what are the associated AF?
head(ani[which(ani$ANI.1..2==0),])

# replace ANI=0 with NA
ani_matrix_NA <- ani_matrix[which(ani_matrix==0)] <- NA
heatmap(ani_matrix_NA,symm=T,col=gray.colors(10000,0,1),scale="column",labRow=rep("",1204),labCol=rep("",1204)) #this removes names in the heat map
# remaining questions
# what type of clustering to use when clustering?
# complete-linkage, incomplete-linkage, hierarchical, average neighbor, etc.?
