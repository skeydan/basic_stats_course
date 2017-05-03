functions {
  vector dgp_rng(matrix X, vector beta, real nu, real sigma) {
    vector[rows(X)] y; 
    for (n in 1:rows(X))
      y[n] <- student_t_rng(nu, X[n] * beta, sigma);
      return y;
    }
}

data {
  int N; 
  int P; 
  matrix[N, P] X; 
  vector[N] y;
}

parameters {
  vector[P] beta;
  real<lower = 0> sigma; 
}

model {
  beta ~ normal(0, 5); 
  sigma ~ cauchy(0, 2.5);
  y ~ normal(X*beta, sigma);
}

generated quantities {
  vector[N] log_lik;
  vector[N] y_sim;
  for(i in 1:N){
    log_lik[i] <- normal_lpdf(y[i], X[i,]*beta, sigma);
    y_sim[i] <- normal_rng(X[i,]*beta, sigma);
  }
}
