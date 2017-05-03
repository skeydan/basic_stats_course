# Eight schools, from Gelman et al. (2003) 
schools_data <- list(
  J = 8,
  y = c(28,  8, -3,  7, -1,  1, 18, 12),
  sigma = c(15, 10, 16, 11,  9, 11, 10, 18)
)

library(rstan)
fit1 <- stan(
  file = "schools.stan",  # Stan program
  data = schools_data,    # named list of data
  chains = 4,             # number of Markov chains
  warmup = 1000,          # number of warmup iterations per chain
  iter = 2000,            # total number of iterations per chain
  cores = 2,              # number of cores (using 2 just for the vignette)
  refresh = 1000          # show progress every 'refresh' iterations
)

print(fit1, pars=c("theta", "mu", "tau", "lp__"), probs=c(.1,.5,.9))
plot(fit1, pars=c("theta", "mu", "tau", "lp__"))

plot(fit1, show_density = TRUE, ci_level = 0.5, fill_color = "purple")
plot(fit1, plotfun = "hist", pars = "theta", include = FALSE)
plot(fit1, plotfun = "trace", pars = c("mu", "tau"), inc_warmup = TRUE)
plot(fit1, plotfun = "rhat") + ggtitle("Example of adding title to plot")

print(fit1, pars = c("mu", "tau"))

sampler_params <- get_sampler_params(fit1, inc_warmup = TRUE)
summary(do.call(rbind, sampler_params), digits = 2)

lapply(sampler_params, summary, digits = 2)