default <- read.table("../data/Philippe_etal_superalignment.log", header = TRUE)
stl <- read.table("../data/Philippe_etal_superalignment_STL.log", header = TRUE)

default$operator <- rep("default", nrow(default))
stl$operator <- rep("STL", nrow(stl))

ForPlot <- rbind(default[1:7000, ], stl[1:7000, ])

library(ggplot2)
number_ticks <- function(n) {function(limits) pretty(limits, n)}
p <- ggplot(ForPlot, aes(x = state, y = likelihood, col = operator)) + 
  geom_line() +
  scale_y_continuous("lnL", limits = c(-853950, -853870)) +
  scale_x_continuous("iterations", expand = c(0, 0), breaks = number_ticks(10)) + 
  theme_bw() +
  theme(legend.title = element_text(size = 14),
        legend.text = element_text(size = 14))
p
pdf("../figures/comparison_metazoan.pdf")
p
dev.off()