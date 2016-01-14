# In this script, I aim to do the following:

# read in the family names:

b <- read.csv("~/Desktop/McMahon Lab/data/151204_Bacteroidetes_Bacteroidia_genomes.csv") #nrow(b)=
c <- read.csv("~/Desktop/McMahon Lab/data/151204_Bacteroidetes_Cytophagia.csv")
f <- read.csv("~/Desktop/McMahon Lab/data/151204_Bacteroidetes_Flavobacteriia.csv")
s <- read.csv("~/Desktop/McMahon Lab/data/151204_Bacteroidetes_Sphingobacteriia.csv")

# read in the ANI/AF table; create inclusive table
afani <- read.table("~/Desktop/McMahon Lab/data/ANIoutput_151124_v2.txt",sep="\t", header=T) #took a few seconds
afani <- afani[seq(1,nrow(afani),2),] # remove even rows

# read in the mag & sag IDs
magsag <- read.csv("~/Desktop/McMahon Lab/data/Bacteroidetes_SAGs_MAGs_IMG_OIDs_from_Google_doc.csv")

# create full un-duplicated ANI table.
ani1 <- afani[,c(1,2,3)] # ANI, 1->2 order
ani2 <- afani[,c(2,1,4)] # ANI, 2->1 order
names(ani2) <- names(ani1)
ani <- rbind(ani1,ani2) #nrow(ani) =  2896610
ani <- ani[-which(duplicated(ani[,1:2])==T),] #remove duplicates #nrow(ani1) = 1448412 # this is 1204*1204-1204.
#ani[,3] <- as.numeric(levels(afani[,3]))[afani[,3]]
ani$ANI.1..2. <- as.numeric(as.character(ani$ANI.1..2.)) #converts column 3 of ani1 to factor
names(ani) <- c("GENOME1","GENOME2","ANI")
ani$GENOME1 <- as.character(ani$GENOME1)
ani$GENOME2 <- as.character(ani$GENOME2)
# remove ".fna" from genome name
ani$GENOME1 <- gsub(".fna","",ani$GENOME1)
ani$GENOME2 <- gsub(".fna","",ani$GENOME2)
ani$GENOME1 <- as.factor(ani$GENOME1)
ani$GENOME2 <- as.factor(ani$GENOME2)


# create full un-duplicated AF table.
af1 <- afani[,c(1,2,5)] # af, 1->2 order
af2 <- afani[,c(2,1,6)] # af, 2->1 order
names(af2) <- names(af1)
af <- rbind(af1,af2) 
af <- af[-which(duplicated(af[,1:2])==T),] #remove duplicates
af$AF.1..2. <- as.numeric(as.character(af$AF.1..2.)) #converts column 3 of ani1 to factor
names(af) <- c("GENOME1","GENOME2","AF")
af$GENOME1 <- as.character(af$GENOME1)
af$GENOME2 <- as.character(af$GENOME2)
af$GENOME1 <- gsub(".fna","",af$GENOME1)
af$GENOME2 <- gsub(".fna","",af$GENOME2)
af$GENOME1 <- as.factor(af$GENOME1)
af$GENOME2 <- as.factor(af$GENOME2)



# identify which of the names of the genomes in the ani table & af table are in the ani table & af tables

length(which(b$taxon_oid %in% af$GENOME1)) #535
length(b$taxon_oid) #545
length(which(c$taxon_oid %in% af$GENOME1)) #96
length(c$taxon_oid) #111
length(which(f$taxon_oid %in% af$GENOME1)) #406
length(f$taxon_oid) #445
length(which(s$taxon_oid %in% af$GENOME1)) #95
length(s$taxon_oid) #111

length(which(af$GENOME1 %in% b$taxon_oid)) #643605
length(which(af$GENOME1 %in% c$taxon_oid)) #115488
length(which(af$GENOME1 %in% f$taxon_oid)) #488418
length(which(af$GENOME1 %in% s$taxon_oid)) #114285
length(which(af$GENOME1 %in% b$taxon_oid)) +
length(which(af$GENOME1 %in% c$taxon_oid)) + 
length(which(af$GENOME1 %in% f$taxon_oid)) +
length(which(af$GENOME1 %in% s$taxon_oid)) # sum of these is close to 1204*1204-1204. makes sense.

# explore
length(af$GENOME1 %in% b$taxon_oid)
head(which(b$taxon_oid %in% af$GENOME1))
head(b$taxon_oid %in% af$GENOME1)
length(which(af$GENOME2 %in% b$taxon_oid)) #643605

# create af tables for individual families

#bacteroidia
af_b <- af[which(af$GENOME1 %in% b$taxon_oid),] #dim(af_b) = 643605      3
af_b <- af_b[which(af_b$GENOME2 %in% b$taxon_oid),] #dim(af_b) = 285690      3
ani_b <- ani[which(ani$GENOME1 %in% b$taxon_oid),] #dim(af_b) = 643605      3
ani_b <- ani_b[which(ani_b$GENOME2 %in% b$taxon_oid),] #dim(af_b) = 285690      3

#flavobacteria
af_f <- af[which(af$GENOME1 %in% f$taxon_oid),] #dim(af_f) = 488418      3
af_f <- af_f[which(af_f$GENOME2 %in% f$taxon_oid),] #dim(af_f) = 164430      3
ani_f <- ani[which(ani$GENOME1 %in% f$taxon_oid),] #dim(ani_f) = 488418      3
ani_f <- ani_f[which(ani_f$GENOME2 %in% f$taxon_oid),] #dim(ani_f) = 164430      3
sqrt(dim(af_f)[1]) # 405.4997 perfect

#cytophagia
af_c <- af[which(af$GENOME1 %in% c$taxon_oid),] 
af_c <- af_c[which(af_c$GENOME2 %in% c$taxon_oid),] 
ani_c <- ani[which(ani$GENOME1 %in% c$taxon_oid),] 
ani_c <- ani_c[which(ani_c$GENOME2 %in% c$taxon_oid),]

#sphingobacteriia
af_s <- af[which(af$GENOME1 %in% s$taxon_oid),] 
af_s <- af_s[which(af_s$GENOME2 %in% s$taxon_oid),] 
ani_s <- ani[which(ani$GENOME1 %in% s$taxon_oid),] 
ani_s <- ani_s[which(ani_s$GENOME2 %in% s$taxon_oid),]

# create ANI maps for individual families

library(plyr)
library(igraph)

# bacteroidia
#create weighted ADJACENCY matrix
ani_graph_b <- graph.data.frame(ani_b)
E(ani_graph_b)$weight <- ani_b$ANI
adj_matrix_b <- as_adjacency_matrix(ani_graph_b,attr="weight")
diag(adj_matrix_b) <- rep(100,nrow(adj_matrix_b)) # the adjacency matrix is complete
# create a regular matrix
ani_matrix_b <- as.matrix(adj_matrix_b)
# replace the diagonal with 100
diag(ani_matrix_b) <- rep(100,nrow(ani_matrix_b))
heatmap(ani_matrix_b,symm=T,col=gray.colors(10000,min(ani_matrix_b)/100,1),scale="column", main = "Bacteroidia")

#cytophagia
#create weighted ADJACENCY matrix
ani_graph_c <- graph.data.frame(ani_c)
E(ani_graph_c)$weight <- ani_c$ANI
adj_matrix_c <- as_adjacency_matrix(ani_graph_c,attr="weight")
diag(adj_matrix_c) <- rep(100,nrow(adj_matrix_c)) # the adjacency matrix is complete
# create a regular matrix
ani_matrix_c <- as.matrix(adj_matrix_c)
# replace the diagonal with 100
diag(ani_matrix_c) <- rep(100,nrow(ani_matrix_c))
heatmap(ani_matrix_c,symm=T,col=gray.colors(10000,0,1),scale="column", main = "Cytophagia")

#flavobacteriia
ani_graph_f <- graph.data.frame(ani_f)
E(ani_graph_f)$weight <- ani_f$ANI
adj_matrix_f <- as_adjacency_matrix(ani_graph_f,attr="weight")
diag(adj_matrix_f) <- rep(100,nrow(adj_matrix_f)) # the adjacency matrix is complete
# create a regular matrix
ani_matrix_f <- as.matrix(adj_matrix_f)
# replace the diagonal with 100
diag(ani_matrix_f) <- rep(100,nrow(ani_matrix_f))
heatmap(ani_matrix_f,symm=T,col=gray.colors(10000,0,1),scale="column", main = "Flavobacteriia")

#sphingobacteriia
ani_graph_s <- graph.data.frame(ani_s)
E(ani_graph_s)$weight <- ani_s$ANI
adj_matrix_s <- as_adjacency_matrix(ani_graph_s,attr="weight")
diag(adj_matrix_s) <- rep(100,nrow(adj_matrix_s)) # the adjacency matrix is complete
# create a regular matrix
ani_matrix_s <- as.matrix(adj_matrix_s)
# replace the diagonal with 100
diag(ani_matrix_s) <- rep(100,nrow(ani_matrix_s))
heatmap(ani_matrix_s,symm=T,col=gray.colors(10000,0,1),scale="column", main = "Sphingobacteriia")

#all bacteroidetes

#create weighted ADJACENCY matrix
ani_graph <- graph.data.frame(ani)
E(ani_graph)$weight <- ani$ANI
adj_matrix <- as_adjacency_matrix(ani_graph,attr="weight")
diag(adj_matrix) <- rep(100,nrow(adj_matrix)) # the adjacency matrix is complete
# create a regular matrix
ani_matrix <- as.matrix(adj_matrix)
# replace the diagonal with 100
diag(ani_matrix) <- rep(100,nrow(ani_matrix))
# replace the absent values become 0
heatmap(ani_matrix,symm=T,col=gray.colors(10000,0,1),scale="column",labRow=rep("",1204),labCol=rep("",1204)) 
# replace ANI=0 with NA
ani_matrix_NA <- ani_matrix
ani_matrix_NA[which(ani_matrix==0)] <- NA
heatmap(ani_matrix_NA,symm=T,col=gray.colors(10000,0,1),scale="column",labRow=rep("",1204),labCol=rep("",1204)) #this removes names in the heat map


# create AF maps for individual families

library(plyr)
library(igraph)

# bacteroidia
#create weighted ADJACENCY matrix
af_graph_b <- graph.data.frame(af_b)
E(af_graph_b)$weight <- af_b$AF
adj_matrix_b <- as_adjacency_matrix(af_graph_b,attr="weight")
diag(adj_matrix_b) <- rep(100,nrow(adj_matrix_b)) # the adjacency matrix is complete
# create a regular matrix
af_matrix_b <- as.matrix(adj_matrix_b)
# replace the diagonal with 1
diag(af_matrix_b) <- rep(1,nrow(af_matrix_b))
heatmap(af_matrix_b,symm=T,col=gray.colors(10000,min(af_matrix_b)/100,1),scale="column", main = "Bacteroidia")

#cytophagia
#create weighted ADJACENCY matrix
af_graph_c <- graph.data.frame(af_c)
E(af_graph_c)$weight <- af_c$AF
adj_matrix_c <- as_adjacency_matrix(af_graph_c,attr="weight")
diag(adj_matrix_c) <- rep(1,nrow(adj_matrix_c)) # the adjacency matrix is complete
# create a regular matrix
af_matrix_c <- as.matrix(adj_matrix_c)
# replace the diagonal with 1
diag(af_matrix_c) <- rep(1,nrow(af_matrix_c))
heatmap(af_matrix_c,symm=T,col=gray.colors(10000,min(af_matrix_c)/100,1),scale="column", main = "Cytophagia")

#flavobacteriia
af_graph_f <- graph.data.frame(af_f)
E(af_graph_f)$weight <- af_f$AF
adj_matrix_f <- as_adjacency_matrix(af_graph_f,attr="weight")
diag(adj_matrix_f) <- rep(1,nrow(adj_matrix_f)) # the adjacency matrix is complete
# create a regular matrix
af_matrix_f <- as.matrix(adj_matrix_f)
# replace the diagonal with 1
diag(af_matrix_f) <- rep(1,nrow(af_matrix_f))
heatmap(af_matrix_f,symm=T,col=gray.colors(10000,min(af_matrix_f)/100,1),scale="column", main = "Flavobacteriia")

#sphingobacteriia
af_graph_s <- graph.data.frame(af_s)
E(af_graph_s)$weight <- af_s$AF
adj_matrix_s <- as_adjacency_matrix(af_graph_s,attr="weight")
diag(adj_matrix_s) <- rep(1,nrow(adj_matrix_s)) # the adjacency matrix is complete
# create a regular matrix
af_matrix_s <- as.matrix(adj_matrix_s)
# replace the diagonal with 1
diag(af_matrix_s) <- rep(1,nrow(af_matrix_s))
heatmap(af_matrix_s,symm=T,col=gray.colors(10000,min(af_matrix_s)/100,1),scale="column", main = "Sphingobacteriia")

#all bacteroidetes

#create weighted ADJACENCY matrix
af_graph <- graph.data.frame(af)
E(af_graph)$weight <- af$AF
adj_matrix <- as_adjacency_matrix(af_graph,attr="weight")
diag(adj_matrix) <- rep(1,nrow(adj_matrix)) # the adjacency matrix is complete
# create a regular matrix
af_matrix <- as.matrix(adj_matrix)
# replace the diagonal with 1
diag(af_matrix) <- rep(1,nrow(af_matrix))
heatmap(af_matrix,symm=T,col=gray.colors(10000,min(af_matrix)/100,1),scale="column", main = "All Bacteroidetes")



heatmap(ani_matrix_NA,symm=T,col=gray.colors(10000,0,1),scale="column",labRow=rep("",1204),labCol=rep("",1204)) #this removes names in the heat map


#histograms of ANI
par(mfrow=c(2,2))
hist(ani_b$ANI, xlim=c(0,100),breaks=18, xlab="ANI", main = "Bacteroidia") #ANI distribution")
text(40,140000/2,paste("n =",length(unique(ani_b$GENOME1))))
text(40,140000*3/8,paste("mean =",round(mean(ani_b$ANI),2)))
text(40,140000/4,paste("sd =",round(sd(ani_b$ANI),2)))
hist(ani_c$ANI, breaks=50, xlab="ANI (%)", main = "Cyptophagia ") #ANI distribution")
text(40,4000/2,paste("n =",length(unique(ani_c$GENOME1))))
text(40,4000*3/8,paste("mean =",round(mean(ani_c$ANI),2)))
text(40,4000/4,paste("sd =",round(sd(ani_c$ANI),2)))
hist(ani_f$ANI, breaks=50, xlab="ANI (%)", main = "Flavobacteriia") # ANI distribution")
text(40,80000/2,paste("n =",length(unique(ani_f$GENOME1))))
text(40,80000*3/8,paste("mean =",round(mean(ani_f$ANI),2)))
text(40,80000/4,paste("sd =",round(sd(ani_f$ANI),2)))
hist(ani_s$ANI, breaks=50, xlab="ANI (%)", main = "Sphingobacteriia ") #ANI distribution")
text(40,3000/2,paste("n =",length(unique(ani_s$GENOME1))))
text(40,3000*3/8,paste("mean =",round(mean(ani_s$ANI),2)))
text(40,3000/4,paste("sd =",round(sd(ani_s$ANI),2)))
par(mfrow=c(1,1))
# compare individual to total Bacteroidetes ANI heatmaps.
hist(ani$ANI, breaks=50, xlab="ANI (%)", main="All Bacteroidetes")
text(40,600000/2,paste("n =",length(unique(ani$GENOME1))))
text(40,600000*3/8,paste("mean =",round(mean(ani$ANI),2)))
text(40,600000/4,paste("sd =",round(sd(ani$ANI),2)))

#histograms of AF
par(mfrow=c(2,2))
hist(af_b$AF, breaks=50, xlab="AF", main = "Bacteroidia") #ANI distribution")
hist(af_c$AF, breaks=50, xlab="AF", main = "Cyptophagia ") #ANI distribution")
hist(af_f$AF, breaks=50, xlab="AF", main = "Flavobacteriia") # ANI distribution")
hist(af_s$AF, breaks=50, xlab="AF", main = "Sphingobacteriia ") #ANI distribution")
par(mfrow=c(1,1))
# compare individual to total Bacteroidetes ANI heatmaps.
hist(af$AF, breaks=50, xlab="AF", main="All Bacteroidetes")

distributions of ANI
mean(ani_b$ANI)
sd(ani_b$ANI)

# run the heat maps by highlighting 

m
sag <- as.factor(magsag[which(magsag$MAG.or.SAG=="SAG"),3])
mag <- as.factor(magsag[which(magsag$MAG.or.SAG=="MAG"),3])

# where do our sags & mags fall?
length(which(ani_b$GENOME1 %in% sag)) #0
length(which(ani_b$GENOME1 %in% mag)) #0
length(which(mag %in% ani_b$GENOME1)) #0
length(which(sag %in% ani_b$GENOME1)) #0
# conclusion: there are no sags/mags in Bacteroidia
length(which(ani$GENOME1 %in% sag)) #4812
length(which(ani$GENOME1 %in% mag)) #52932
length(which(mag %in% ani$GENOME1)) #44
length(which(sag %in% ani$GENOME1)) #4


#hierarchical clustering for AF
hc_af <- hclust(dist(af_matrix),method="complete") #complete linkage/furthest neighbor
#the following is to answer the question of whether the order of the labels is the way it's plotted
labs <- c(hc_af$labels[1:10], rep("",1194))
plot(hc_af,labels=labs)
# this plotted the first 10 labels all over the plot. 
# conclusion: need to use the hc$order to put the labels in the right order.

#hierarchical clustering for ANI
library(sparcl)
library(ggdendro)
library(dendextend)
hc_ani <- hclust(dist(ani_matrix),method="complete") #complete linkage/furthest neighbor
plot(hc_ani, main = "Bacteroidetes ANI Tree",cex=0.5,xlab = "",sub="")
#alternatively, color the different parts
y <- cutree(hc_ani,4)
ColorDendrogram(hc_ani, y=y,main = "Bacteroidetes ANI Tree",cex=0.5,xlab = "",sub="")
dend <- as.dendrogram(hc_ani)
labels_colors(dend) <- "red"
plot(dend,leaflab="none",main = "Bacteroidetes ANI Tree")

#plot only MAG labels on Bacteroidetes ANI tree
labs_mag <- hc_ani$labels
labs_mag[-which(labs_mag %in% as.character(mag))] <- ""
plot(hc_ani,labels=labs_mag, main = "MAGs in Bacteroidetes ANI Tree",cex=0.5,xlab = "",sub="")
# using dendrograms, which enables highlighting the genomes
hc_ani_mag <- hc_ani
labs_mag <- hc_ani$labels
labs_mag[-which(labs_mag %in% as.character(mag))] <- ""
hc_ani_mag$labels <- labs_mag
dend_mag <- as.dendrogram(hc_ani_mag)
labels_colors(dend_mag) <- "red"
plot(dend_mag,main = "MAGs in Bacteroidetes ANI Tree")


#plot only sag labels on Bacteroidetes ANI tree
labs_sag <- hc_ani$labels
labs_sag[-which(labs_sag %in% as.character(sag))] <- ""
plot(hc_ani,labels=labs_sag, main = "SAGs in Bacteroidetes ANI Tree",cex=0.5,xlab = "",sub="")
# using dendrograms, which enables highlighting the genomes
hc_ani_sag <- hc_ani
labs_sag <- hc_ani$labels
labs_sag[-which(labs_sag %in% as.character(sag))] <- ""
hc_ani_sag$labels <- labs_sag
dend_sag <- as.dendrogram(hc_ani_sag)
labels_colors(dend_sag) <- "red"
plot(dend_sag,main = "SAGs in Bacteroidetes ANI Tree")

# plot only flavo labels on Bacteroidetes ANI tree
labs_f <- hc_ani$labels
labs_f[-which(labs_f %in% as.character(ani_f$GENOME1))] <- ""
plot(hc_ani,labels=labs_f, main = "Flavobacteriia in Bacteroidetes ANI Tree",cex=0.5,xlab = "",sub="")
# using dendrograms, which enables highlighting the genomes
hc_ani_f <- hc_ani
labs_f <- hc_ani$labels
labs_f[-which(labs_f %in% as.character(ani_f$GENOME1))] <- ""
hc_ani_f$labels <- labs_f
dend_f <- as.dendrogram(hc_ani_f)
labels_colors(dend_f) <- "red"
plot(dend_f,main = "Flavobacteriia in Bacteroidetes ANI Tree")


# plot only Bacteroidia labels on Bacteroidetes ANI tree
labs_b <- hc_ani$labels
labs_b[-which(labs_b %in% as.character(ani_b$GENOME1))] <- ""
plot(hc_ani,labels=labs_b, main = "Bacteroidia in Bacteroidetes ANI Tree",cex=0.5,xlab = "",sub="")
# using dendrograms, which enables highlighting the genomes
hc_ani_b <- hc_ani
labs_b <- hc_ani$labels
labs_b[-which(labs_b %in% as.character(ani_b$GENOME1))] <- ""
hc_ani_b$labels <- labs_b
dend_b <- as.dendrogram(hc_ani_b)
labels_colors(dend_b) <- "red"
plot(dend_b,main = "Bacteroidia in Bacteroidetes ANI Tree")

# plot only Cytophagia labels on Bacteroidetes ANI tree
labs_c <- hc_ani$labels
labs_c[-which(labs_c %in% as.character(ani_c$GENOME1))] <- ""
plot(hc_ani,labels=labs_c, main = "Cytophagia in Bacteroidetes ANI Tree",cex=0.5,xlab = "",sub="")
# using dendrograms, which enables highlighting the genomes
hc_ani_c <- hc_ani
labs_c <- hc_ani$labels
labs_c[-which(labs_c %in% as.character(ani_c$GENOME1))] <- ""
hc_ani_c$labels <- labs_c
dend_c <- as.dendrogram(hc_ani_c)
labels_colors(dend_c) <- "red"
plot(dend_c,main = "Cytophagia in Bacteroidetes ANI Tree")

# plot only Sphingobacteriia labels on Bacteroidetes ANI tree
labs_s <- hc_ani$labels
labs_s[-which(labs_s %in% as.character(ani_s$GENOME1))] <- ""
plot(hc_ani,labels=labs_s, main = "Sphingobacteriia in Bacteroidetes ANI Tree",cex=0.5,xlab = "",sub="")
# using dendrograms, which enables highlighting the genomes
hc_ani_s <- hc_ani
labs_s <- hc_ani$labels
labs_s[-which(labs_s %in% as.character(ani_s$GENOME1))] <- ""
hc_ani_s$labels <- labs_s
dend_s <- as.dendrogram(hc_ani_s)
labels_colors(dend_s) <- "red"
plot(dend_s,main = "Sphingobacteriia in Bacteroidetes ANI Tree")

#all dendrograms in different colors
plot(dend,leaflab="none",main = "Bacteroidetes ANI Tree")
labels_colors(dend_mag) <- "black"
plot(dend_mag)
labels_colors(dend_f) <- "yellow"
plot(dend_f)
labels_colors(dend_b) <- "red"
plot(dend_b)
labels_colors(dend_c) <- "green"
plot(dend_c)
labels_colors(dend_s) <- "orange"
plot(dend_s)
labels_colors(dend_sag) <- "blue"
plot(dend_sag)

labs <- as.factor(hc$labels)
labs[which(mag %in% labs)]
length(which(mag %in% labs))
length(mag %in% labs) #45
length(labs %in% mag) #1204
length(which(labs %in% mag)) #44

# plot the AF tree with only MAGs labels showing
labs_mag <- hc$labels
labs_mag[-which(labs_mag %in% as.character(mag))] <- ""
plot(hc,labels=labs_mag)

Change it to look %in% the hc_ani$labels, not ani_s$GENOME1!...?