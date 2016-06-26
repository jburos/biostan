data {
  int<lower=1> N;
  vector[N] x;
  vector[N] y;
  real<lower = 0> nu; // we could estimate this from data
}
parameters {
  real alpha;
  real beta;
  real<lower=0> sigma;
 } model {
   sigma ~ cauchy(0, 2.5);
   y ~ student_t(nu, alpha + beta * x,  sigma);
}
