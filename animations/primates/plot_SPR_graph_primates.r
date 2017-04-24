library(ape)
library(devtools)
library(GGally)
library(network)
library(ggplot2)
library(sna)

##
source_url("https://raw.githubusercontent.com/maxbiostat/sprspace/master/R/read.nexusB.r")
source_url("https://raw.githubusercontent.com/maxbiostat/sprspace/master/R/unique_trees.r")
source_url("https://raw.githubusercontent.com/maxbiostat/sprspace/master/R/sort_trees.r")
source_url("https://raw.githubusercontent.com/maxbiostat/rspr/master/R/rspR.r")
source_url("https://raw.githubusercontent.com/maxbiostat/sprspace/master/R/spRspace_aux.R")
##
mcc.tree <- read.nexus("long/Primates_default.tree")
trees <- read.nexusB("long/Primates_default.trees")
############
#### Manipulating the tree posterior
utrees <- unique_trees(trees)# unique topologies
save(utrees, file = "long/primates_10K_unique_trees.RData")
length(utrees[[1]]) # How many [U]nique trees?
uhits <- utrees[[2]] # How many times each?  
most.sampled <- which(uhits == max(uhits)) # most frequent topology. A rare commodity, though.
rspr(utrees$trees[[most.sampled]], mcc.tree)
png("long/Primates_number_of_occurrences.png")
barplot(table(uhits), xlab = "Number of times appeared in the posterior", ylab = "frequency")
dev.off()
rutrees <- sort_trees(utrees, alpha = .99999) # sorting trees according to their frequency
####
####
WhoAmI <- function(tree, allTs){
  ## takes a tree and finds which tree in the exhaustive list of all topologies it is (i.e. finds its index)
  thatsMe <- FALSE
  index <- 1
  while(thatsMe == FALSE){
    thatsMe <- (rspr(t1 = tree, t2 = allTs[[index]]) == 0)
    index <- index  + 1
  }
  return(index - 1)
}
AllTrees <- phangorn::allTrees(n = Ntip(mcc.tree), rooted = TRUE)  
AllNames <- sprintf(paste(Ntip(mcc.tree), "taxa_tree_%03d", sep = ""), 1:length(AllTrees))
replaceTaxaNames <- function(phy){
  newphy <- phy
  newphy$tip.label <- c("Gorilla", "Homo_sapiens", "Hylobates", "Pan", "Pongo")
  return(newphy)
}
AllTrees <- lapply(AllTrees, replaceTaxaNames)
class(AllTrees) <- "multiPhylo"
Indices <- unlist(parallel::mclapply(rutrees, function(x) WhoAmI(tree = x, allTs = AllTrees), mc.cores = 8))

fullMat <- rspr.matrix(AllTrees, type = "full")
fields::image.plot(fullMat)
IncidenceMat <- binarise.matrix(rspr.matrix(AllTrees, type = "restricted", maxdist = 1))
radius.graph <- network(IncidenceMat, directed = FALSE)
network.vertex.names(radius.graph) <- AllNames
coords <- gplot.layout.fruchtermanreingold(radius.graph, NULL)


Colours <- as.factor(sapply(AllTrees, function(x) rspr(x, mcc.tree)))
hm.palette <- colorRampPalette(RColorBrewer::brewer.pal(4, 'YlOrRd'), space = 'Lab')
Pal <-  hm.palette(4)
names(Pal) <- levels(Colours)

Probs <- rep(1e-7, length(AllTrees))
Probs[Indices] <- uhits/sum(uhits)
Sizes <- cut(Probs, breaks = seq(0, 1, length.out = 10)) 
ggnet2(net = radius.graph, size = Sizes, 
       color = Colours, palette = Pal,
       color.legend = "Distance from mcc", size.legend = "Posterior probability") + 
  theme(panel.background = element_rect(fill = "grey15"))



###########
# AllAddresses <- unlist(parallel::mclapply(trees, function(x) WhoAmI(tree = x, allTs = AllTrees), mc.cores = 8))
# save(AllAddresses , file = "long/tree_indices_primates.RData")
# load(AllAddresses , file = "long/tree_indices_primates.RData")
someAddresses <- as.numeric(unlist(parallel::mclapply(trees[seq(1, length(trees), length.out = 20)],
                                                      function(x) WhoAmI(tree = x, allTs = AllTrees), mc.cores = 8))
)
plotTreeinGraph <- function(tree_index, iter = 0){
  Colours <- rep("gray", length(AllTrees))
  Colours[tree_index] <- "red2"
  graph <- radius.graph
  graph %v% "x" <- coords[, 1]
  graph %v% "y" <- coords[, 2]  
  print(
    ggnet2(net = graph, size = 10,  mode = c("x", "y"), color = Colours) + 
      theme(panel.background = element_rect(fill = "grey15")) +
      ggtitle(paste("iteration:", iter)) +
      theme(plot.title = element_text(hjust = 0.5, size = 22, face = "bold", colour = "white"))
  )
}
MakeMovie <- function(TreeIndices, title, Niter = 100){
  require(animation)
  ani.options(interval = 1, ani.width = 960, ani.height = 960)
  animation::saveGIF({
    lapply(TreeIndices, function(index) plotTreeinGraph(index))
  }, movie.name = paste(title, "_", length(TreeIndices), "iter.gif", sep = ""))
}

MakeMovie(someAddresses, title = "SPR_Graph_primates_default")
