
library(rstan)
# set seed for replicability
set.seed(8675309)

# create a N x k matrix of covariates
N = 250
K = 3

covariates = replicate(K, rnorm(n=N))
covariates
colnames(covariates) = c('X1', 'X2', 'X3')

# create the model matrix with intercept
X = cbind(Intercept=1, covariates)
X

# create a normally distributed variable that is a function of the covariates
coefs = c(5,.2,-1.5,.9)
mu = X %*% coefs
mu
sigma = 2
y <- rnorm(N, mu, sigma)
y
# same as
# y = 5 + .2*X1 - 1.5*X2 + .9*X3 + rnorm(N, mean=0, sd=2)

# Run lm for later comparison; but go ahead and examine now if desired
lm_fit = lm(y~., data=data.frame(X[,-1]))
summary(lm_fit)

dat = list(N=N, K=ncol(X), y=y, X=X)


### Run the model and examine results ###
fit = stan(file='linear_regression_bayes.stan', data=dat, iter=12000, 
           warmup=2000, thin=10, chains=3)
fit

stan_trace(fit, pars=c('beta[4]'))
