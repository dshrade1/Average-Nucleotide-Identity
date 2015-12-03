# convert ANI table to matrix
# first, save the ANI table as a csv.

# what type of clustering to use when clustering?
# complete-linkage, incomplete-linkage, hierarchical, average neighbor, etc.?

library(plyr)
library(igraph)

# I did the ANI on a few genome sets
# Then I copied and pasted the outputs I exported from JGI IMG into a single csv

ani <- read.csv("~/Desktop/McMahon Lab/ANI_workflow/2015-10-05_representatives_ani.csv")
ani <- ani[,c(1,3,5:ncol(ani))]

#ani <- ani[with(ani,order(ANI1..2)),]
ani1 <- ani[,c(1,2,3)]
ani2 <- ani[,c(1,2,4)]
ani2 <- ani2[,c(2,1,3)] #reorder
names(ani2) <- names(ani1)
ani1 <- rbind(ani1,ani2) 
ani1 <- ani1[-which(duplicated(ani1[,1:2])==T),] #remove duplicates

# create matrices

# change the names
genomes <- data.frame(IMGtaxonID=as.numeric(levels(as.factor(ani1$Genome1.ID))))
#genomes
#note, I removed the first 3 lines of the following metadata after downloading as csv but before loading in R
#metadata <- read.csv("~/Desktop/Genomes for ANI/Lake SAGs (meta)data - Metadata.csv")
#metadata <- metadata[,c(1:11,15,19)]
#taxon_name <- merge(genomes,metadata,by.x="IMGtaxonID", by.y="Taxon.ID..NEW.",all.x=T)
#taxon_name <- mutate(taxon_name, name=paste(IMGtaxonID,clade,Tribe,Lake))
#taxon_name <- taxon_name[,c(1,which(names(taxon_name)=="name"))]

#write.csv(taxon_name,"~/Desktop/Genomes for ANI/2015-10-05_ANI_genomes_names.csv")
# next, I edit this csv manually because several genome names were not found in our metadata doc!!!
# I deleted the Pnec that was a symbiont
# then I read it back in 
taxon_name <- read.csv("~/Desktop/McMahon Lab/ANI_workflow/2015-10-05_ANI_genomes_names.csv")
#names(taxon_name)
#head(genomes)
#taxon_name$IMGtaxonID %in% genomes$IMGtaxonID
#genomes$IMGtaxonID %in% taxon_name$IMGtaxonID

#Now, replace the taxonIDs with the names in my ani matrices
ani1$Genome1.name <- with(taxon_name, name[match(ani1$Genome1.ID, IMGtaxonID)])
ani1$Genome2.name <- with(taxon_name, name[match(ani1$Genome2.ID, IMGtaxonID)])
which(is.na(ani1$Genome1.name))
#factor(ani1$Genome1.ID,levels=taxon_name$IMGtaxonID,labels=taxon_name$name) #warning

# reorder to work with graph.data.frame
ani1 <- ani1[,c(4,5,3)]

#create weighted ADJACENCY matrix
ani_graph <- graph.data.frame(ani1)
E(ani_graph)$weight <- ani1$ANI1..2
adj_matrix <- as_adjacency_matrix(ani_graph,attr="weight")
diag(adj_matrix) <- rep(100,nrow(adj_matrix)) # the adjacency matrix is complete

# create a regular matrix
ani_matrix <- as.matrix(adj_matrix)
# replace the diagonal with 100
diag(ani_matrix) <- rep(100,nrow(ani_matrix))
# replace the absent values become 0

# visualize: create heat map
ani_heat <- heatmap(ani_matrix,col=heat.colors(256),scale="column",margins=c(13,13))
ani_heat
