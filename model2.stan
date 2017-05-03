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
  real<lower = 0> beta_1;
  vector[P-1] beta_2; 
  real<lower = 0> sigma; 
  real<lower = 0> nu; 
}

transformed parameters {
  vector[P] beta;
  beta <- append_row(rep_vector(beta_1, 1), beta_2);
}

model {
  beta ~ normal(0, 5);
  sigma ~ cauchy(0, 2.5);
  nu ~ cauchy(7, 5);
  y ~ student_t(nu, X*beta, sigma);
}

generated quantities {
  // For model comparison, we'll want to keep the likelihood contribution of each point
  vector[N] log_lik;
  vector[N] y_sim;
  for(i in 1:N){
    log_lik[i] <- student_t_log(y[i], nu, X[i,]*beta, sigma);
    y_sim[i] <- student_t_rng(nu, X[i,]*beta, sigma);
  }
}

