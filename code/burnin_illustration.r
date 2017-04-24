MCMC <- read.table("../data/Philippe_etal_superalignment_STL.log", header = TRUE)
library(ggplot2)
number_ticks <- function(n) {function(limits) pretty(limits, n)}

pdf("../figures/burnin.pdf")
ggplot(MCMC, aes(x = state, y = likelihood)) + 
  geom_line() +
  scale_y_continuous("lnL", limits = c(-853950, -853870)) +
  scale_x_continuous("iterations", expand = c(0, 0), breaks = number_ticks(10)) + 
  annotate("rect", xmin = 0, xmax = 2e7, ymin = -Inf, ymax = Inf, alpha = .2, colour = "skyblue2", fill = "skyblue2") +
  theme_bw()
dev.off()