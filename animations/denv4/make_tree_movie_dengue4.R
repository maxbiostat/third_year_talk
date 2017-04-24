library(ape)
Default <- read.nexus("Dengue4_default.trees")
STL <- read.nexus("Dengue4_STL.trees")
dd <- data.frame(tip = STL[[1]]$tip.label,
                 place = gsub("[0-9*]", "", gsub("D4", "", STL[[1]]$tip.label)))
############################################
############################################
plotTree <- function(tree, iter = 0){
  require(ape)
  require(ggtree)
  fullTr <- phylobase::phylo4d(tree, dd)
  print(
    ggtree(fullTr, mrsd = "1994-06-15", size = 2) +
      # geom_point(aes(shape = isTip), size = 5, colour = "blue") +
      ggtitle(paste("iteration:", iter)) +
      geom_tippoint(aes(size = 5, color = place), alpha = 0.95) +
      # theme_tree2() + 
      theme(plot.title = element_text(hjust = 0.5, size = 22, face = "bold"),
            axis.text.x = element_text(size = 16, face = "bold"))
  )
}
# plotTree(STL[[23]])
MakeMovie <- function(Trees, title){
  require(animation)
  ani.options(interval = .5, ani.width = 960, ani.height = 960)
  animation::saveGIF({
    lapply(seq_along(Trees), function(index) plotTree(Trees[[index]], iter = index))
  }, movie.name = paste(title, "_", length(Trees), "iter.gif", sep = ""))
}
###
MakeMovie(Default[seq(1, length(Default) , length.out = 10)], "default_mix")
MakeMovie(STL[seq(1, length(Default) , length.out = 10)], "STL")
