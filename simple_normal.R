library(rstan)
library(shinystan)

N <- 3
data <- list(y=c(-1,1,2))

fit <- stan(file = 'simple_normal.stan', data = data, cores = 1, chains = 2, iter = 2000)
fit
plot(fit)

plot(fit, show_density = TRUE, pars = c("mu", "sigma"), ci_level = 0.5, fill_color = "purple")
plot(fit, plotfun = "hist", pars = c("mu", "sigma"), include = FALSE)
plot(fit, plotfun = "trace", pars = c("mu", "sigma"), inc_warmup = TRUE)
plot(fit, plotfun = "rhat") # + ggtitle("Example of adding title to plot")

shinystan::launch_shinystan(fit)