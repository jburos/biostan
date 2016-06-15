/*  Variable naming:
 obs       = observed
 cen       = (right) censored
 N         = number of samples
 M         = number of covariates
 bg        = established risk (or protective) factors
 biom      = candidate biomarkers (candidate risk factors)
 tau       = scale parameter
*/
// adapted from https://github.com/to-mi/stan-survival-shrinkage/blob/master/wei_gau.stan
// Tomi Peltola, tomi.peltola@aalto.fi

functions {
  vector sqrt_vec(vector x) {
    vector[dims(x)[1]] res;

    for (m in 1:dims(x)[1]){
      res[m] <- sqrt(x[m]);
    }

    return res;
  }

  vector gau_prior_lp(real r1_global, real r2_global, vector ones_biom) {
    r1_global ~ normal(0.0, 1.0);
    r2_global ~ inv_gamma(0.5, 0.5);

    return (r1_global * sqrt(r2_global)) * ones_biom;
  }

  vector bg_prior_lp(real r_global, vector r_local) {
    r_global ~ normal(0.0, 10.0);
    r_local ~ inv_chi_square(1.0);

    return r_global * sqrt_vec(r_local);
  }
}

data {
  int<lower=0> Nobs;
  int<lower=0> Ncen;
  vector[Nobs] yobs;
  vector[Ncen] ycen;
}

transformed data {
  real<lower=0> tau_mu;
  real<lower=0> tau_al;

  tau_mu <- 10.0;
  tau_al <- 10.0;
}

parameters {
  real alpha_raw;
  real mu;
}

transformed parameters {
  real alpha;
  alpha <- exp(tau_al * alpha_raw);
}

model {
  yobs ~ weibull(alpha, exp(-(mu)/alpha));
  increment_log_prob(weibull_ccdf_log(ycen, alpha, exp(-(mu)/alpha)));

  alpha_raw ~ normal(0.0, 1.0);
  mu ~ normal(0.0, tau_mu);
}

