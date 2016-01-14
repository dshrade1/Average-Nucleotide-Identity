#151201_ANI_Bacteroidetes

library(plyr)
library(igraph)

# read file containing the af calculator output
af <- read.table("~/Desktop/McMahon Lab/data/ANIoutput_151124_v2.txt",sep="\t", header=T)

# remove even rows
af <- af[seq(1,nrow(af),2),]
# to renumber the row names, run the following lines
# write.csv(af,"~/Desktop/McMahon Lab/ani_workflow/ani_af.txt")
# af <- read.csv("~/Desktop/McMahon Lab/ani_workflow/ani_af.txt")[,-1]

# create full un-duplicated AF table.
af1 <- af[,c(1,2,5)] # af, 1->2 order
af2 <- af[,c(2,1,6)] # af, 2->1 order
names(af2) <- names(af1)
af1 <- rbind(af1,af2) 
af1 <- af1[-which(duplicated(af1[,1:2])==T),] #remove duplicates
af1$AF.1..2. <- as.numeric(as.character(af1$AF.1..2.)) #converts column 3 of ani1 to factor


#create weighted ADJACENCY matrix
af_graph <- graph.data.frame(af1)
E(af_graph)$weight <- af1$AF.1..2
af_adj_matrix <- as_adjacency_matrix(af_graph,attr="weight")
diag(af_adj_matrix) <- rep(1,nrow(af_adj_matrix)) # the adjacency matrix is complete

# create a regular matrix
af_matrix <- as.matrix(af_adj_matrix)
# replace the diagonal with 1
diag(af_matrix) <- rep(1,nrow(af_matrix))

# create clustered heat map
#af_heat <- heatmap(af_matrix,Colv=NA,Rowv=NA,symm=F,col=gray.colors(100,0.86,1), scale="column",margins=c(13,13))
heatmap(af_matrix,symm=T,col=gray.colors(10000,0,1),scale="column",labRow=rep("",1204),labCol=rep("",1204)) #this removes names in the heat map

# af_heat2 <- heatmap(af_matrix,symm=T,Colv=NA, Rowv=NA,col=heat.colors(256),margins=c(13,13))
# af_matrix[nrow(af_matrix):1,]
# af_matrix2 <- apply(af_matrix,2,rev)
# af_matrix2
# t(af_matrix2)

# histogram of AF
hist(af1$AF.1..2,main="",xlab="")
hist(af1$AF.1..2[which(af1$AF.1..2>0)],main="Histogram of AF values > 0",xlab="AF values > 0")
hist(af1$AF.1..2[which(af1$AF.1..2>0.4)],main="Histogram of AF values > 0.4",xlab="AF values > 0.4",breaks=50)

# how many had AF=0?
nrow(af1[which(af1$AF.1..2==0),]) #66705
nrow(af1[which(af1$AF.1..2==0),])/nrow(af1) #4.6% of comparisons had 0% AF

# Compare AF to ANI 
plot(ani1$ANI.1..2,af1$AF.1..2,main="ANI v. AF values",xlab="ANI",ylab="AF")