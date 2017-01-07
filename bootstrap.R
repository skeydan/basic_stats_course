data("mpg")

cty <- mpg$cty

summary(cty)

num_bootstraps <- 1000
num_obs <- length(cty)

samples <- sample(cty, num_bootstraps * num_obs, replace = TRUE)
resampled <- matrix(samples, num_bootstraps, num_obs)

medians <- apply(resampled, 1, median)

c(median(cty), median(medians))

sd(medians)
