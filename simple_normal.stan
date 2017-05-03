data{
  int<lower=1> N;
  real y[N];
}
parameters{
  real mu;
  real<lower=0> sigma;
}
model{
  sigma ~ cauchy( 0 , 1 );
  mu ~ normal( 0 , 10 );
  y ~ normal( mu , sigma );
}

#generated quantities{
#  
#}

