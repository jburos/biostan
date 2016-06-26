data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
} model {
  sigma ~ cauchy(0, 2.5);
  y ~ normal(alpha + beta * x, sigma);
  # (almost) same as: target += normal_lpdf(y | alpha + beta * x, sigma);
}
