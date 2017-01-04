library(manipulate)
library(ggplot2)
library(dplyr)

# example data
mu_0 <- 100
mu_a <- 112
sd <- 11
n <- 12

# example alpha
alpha <- 0.05

# formula to calculate power
(z <- qnorm(1 - alpha))
# probability of obtaining a result at least as extreme as the sample mean, under the alternative hypothesis
# note lower.tail = FALSE
(power <- pnorm(mu_0 + z * sd/sqrt(n), mean = mu_a, sd = sd/sqrt(n), lower.tail <- FALSE))


# illustrate effects of different
myplot <- function(mu_a, sd, n, alpha) {
  g = ggplot(data_frame(mu = c(75, 125)), aes(x = mu))
  g <- g + stat_function(fun = dnorm, geom = "line", args = list(mean = mu_0,
                                                                sd = sd/sqrt(n)), size = 1, col = "cyan")
  g <- g + stat_function(fun = dnorm, geom = "line", args = list(mean = mu_a,
                                                                sd = sd/sqrt(n)), size = 1, col = "violet")
  xitc <- mu_0 + qnorm(1 - alpha) * sd/sqrt(n)
  g <- g + geom_vline(xintercept = xitc, size = 1)
  g
}

manipulate(myplot(mu_a, sd, n, alpha),
           sd = slider(1, 20, step = 1, initial = sd),
           mu_a = slider(70, 120, step = 1, initial = mu_a),
           n = slider(1, 50, step = 1, initial = n),
           alpha = slider(0.01, 0.1, step = 0.01, initial = alpha))


