/*  Variable naming:
 obs       = observed
 cen       = (right) censored
 N         = number of samples
 tau       = scale parameter
*/
data {
  int<lower=0> Nobs;
  int<lower=0> Ncen;
  vector[Nobs] yobs;
  vector[Ncen] ycen;
}

transformed data {
  real<lower=0> tau_mu;
  real<lower=0> tau_al;

  tau_mu = 10.0;
  tau_al = 10.0;
}

parameters {
  real alpha_raw;
  real mu;
}

transformed parameters {
  real alpha;
  alpha = exp(tau_al * alpha_raw);
}

model {
  yobs ~ weibull(alpha, exp(-(mu)/alpha));
  target += weibull_lccdf(ycen | alpha, exp(-(mu)/alpha));

  alpha_raw ~ normal(0.0, 1.0);
  mu ~ normal(0.0, tau_mu);
}
