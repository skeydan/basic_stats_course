library(rstan)
library(ggplot2)
library(dplyr)
library(reshape2)
library(loo)

set.seed(42) 
N <- 1000 
P <- 10 
X <- matrix(rnorm(N*P), N, P) 
nu <- 5 
sigma <- 5 
beta <- rnorm(10) 
beta[1] <- abs(beta[1])


compiled_function1 <- stan_model(file = 'model1.stan')
expose_stan_functions(compiled_function1)

compiled_function2 <- stan_model(file = 'model2.stan')
expose_stan_functions(compiled_function2)

y_sim <- dgp_rng(nu = nu, X = X, sigma = sigma, beta = beta)
data_frame(y_sim = y_sim) %>% ggplot(aes( x = y_sim)) +  geom_histogram(binwidth = 3)

data_list_2 <- list(X = X, N = N, y = y_sim, P = P)

incorrect_fit <- stan(file = 'model1.stan', data = data_list_2, cores = 1, chains = 2, iter = 2000)
correct_fit <- stan(file = 'model2.stan', data = data_list_2, cores = 1, chains = 2, iter = 2000)

print(incorrect_fit, pars = c("beta", "sigma"))


##############################################################################

library(loo) # Load the library

# Extract the log likelihoods of both models. Note that we need to declare log_lik in the generated quantities {} block
llik_incorrect <- extract_log_lik(incorrect_fit, parameter_name = "log_lik")
llik_correct <- extract_log_lik(correct_fit, parameter_name = "log_lik")

# estimate the leave-one-out cross validation error 
loo_incorrect <- loo(llik_incorrect)
loo_correct <- loo(llik_correct)

# Print the LOO statistics
print("Incorrect model")
print(loo_incorrect)
sprintf("\n\nCorrect model")
print(loo_correct)

# Print the comparison between the two models
print(compare(loo_incorrect, loo_correct), digits = 2)


####################################################################################

known_parameters <- data_frame(variable = c(paste0("beta[",1:P,"]"),"sigma", "nu"), real_value = c(beta, sigma, nu))


# Extract params as a (draws * number of chains * number of params) array
extract(correct_fit, permuted = F, pars = c("beta", "sigma", "nu")) %>% 
  # Stack the chains on top of one another and drop the chains label
  plyr::adply(2) %>% 
  dplyr::select(-chains) %>% 
  # Convert from wide form to long form (stack the columns on one another)
  melt() %>% 
  # Perform a left join with the known parameters
  left_join(known_parameters, by = "variable") %>%
  # Generate the plot
  ggplot(aes(x = value)) + 
  geom_density(fill = "orange", alpha = 0.5) + # Make it pretty
  facet_wrap(~ variable, scales = "free") +
  geom_vline(aes(xintercept = real_value), colour = "red") +
  ggtitle("Actual parameters and estimates\ncorrectly specified model\n")


extract(incorrect_fit, permuted = F, pars = c("beta", "sigma")) %>% 
  # Extract params as a (draws * number of chains * number of params) array
  plyr::adply(2) %>% 
  dplyr::select(-chains) %>% 
  # Stack the chains on top of one another and drop the chains label
  melt() %>% 
  left_join(known_parameters, by = "variable") %>% # Join the known parameter table
  # Convert from wide form to long form (stack the columns on one another)
  # Write out the plot
  ggplot(aes(x = value)) + 
  geom_density(fill = "orange", alpha = 0.5) + # Make it pretty
  facet_wrap(~ variable, scales = "free") + # small sub-plots of each variable
  geom_vline(aes(xintercept = real_value), colour = "red") + # red vertical lines for the known parameters
  ggtitle("Actual parameters and estimates\nincorrectly specified model\n") # A title



####################################################################################

known_y <- data_frame(variable = paste0("y_sim[",1:N,"]"), real_y = y_sim)


# Extract params as a (draws * number of chains * number of params) array
plot_data <- extract(correct_fit, permuted = F, pars = c("y_sim")) %>%
  plyr::adply(2) %>% 
  dplyr::select(-chains) %>% 
  # Stack the chains on top of one another and drop the chains label
  melt() %>% 
  left_join(known_y, by = "variable") %>% # Join the known parameter table
  # Convert from wide form to long form (stack the columns on one another)
  # Write out the plot
  group_by(variable) %>%
  summarise(median = median(value),
            lower = quantile(value, 0.025),
            upper = quantile(value, 0.975),
            actual = first(real_y)) 

plot_data %>%
  ggplot(aes(x = median)) + 
  geom_ribbon(aes(ymin = lower, ymax = upper), fill = "orange", alpha = 0.5) + 
  geom_line(aes(y = median)) +
  geom_point(aes(y = actual)) +
  ggtitle("Actual outcomes and 95% posterior predictive interval\n") # A title

plot_data %>% summarize(proportion_within_95pc = mean(actual>=lower & actual<=upper))
