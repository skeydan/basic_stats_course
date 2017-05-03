data {
  int<lower=0> J;          // number of schools 
  real y[J];               // measured treatment effects
  real<lower=0> sigma[J];  // s.e. of effect measurements - these are assumed to be known 
}
parameters {
  real mu; 
  real<lower=0> tau;
  vector[J] eta;
}
transformed parameters {
  vector[J] theta;        // standardized effects
  theta = mu + tau * eta; // unstandardized school-level effects, constructed by scaling the the standardized effects by τ and shifting them by μ rather than directly declaring θ as a parameter. 
}
model {
  target += normal_lpdf(eta | 0, 1);
  target += normal_lpdf(y | theta, sigma);
}
