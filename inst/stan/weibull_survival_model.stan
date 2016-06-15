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
  int<lower=0> M_bg;
  int<lower=0> M_biom;
  vector[Nobs] yobs;
  vector[Ncen] ycen;
  matrix[Nobs, M_bg] Xobs_bg;
  matrix[Ncen, M_bg] Xcen_bg;
  matrix[Nobs, M_biom] Xobs_biom;
  matrix[Ncen, M_biom] Xcen_biom;
}

transformed data {
  real<lower=0> tau_mu;
  real<lower=0> tau_al;
  vector[M_biom] ones_biom;

  tau_mu <- 10.0;
  tau_al <- 10.0;

  for (m in 1:M_biom) {
    ones_biom[m] <- 1.0;
  }
}

parameters {
  real<lower=0> tau_s_bg_raw;
  vector<lower=0>[M_bg] tau_bg_raw;

  real<lower=0> tau_s1_biom_raw;
  real<lower=0> tau_s2_biom_raw;

  real alpha_raw;
  vector[M_bg] beta_bg_raw;
  vector[M_biom] beta_biom_raw;

  real mu;
}

transformed parameters {
  vector[M_biom] beta_biom;
  vector[M_bg] beta_bg;
  real alpha;

  if (M_biom > 0) {
      beta_biom <- gau_prior_lp(tau_s1_biom_raw, tau_s2_biom_raw, ones_biom) .* beta_biom_raw;
  }

  if (M_bg > 0) {
      beta_bg <- bg_prior_lp(tau_s_bg_raw, tau_bg_raw) .* beta_bg_raw;
  }

  alpha <- exp(tau_al * alpha_raw);
}

model {
  vector[Nobs] lp_obs;
  vector[Ncen] lp_cen;

  for (i in 1:Nobs) {
    lp_obs[i] <- mu;
  }
  for (i in 1:Ncen) {
      lp_cen[i] <- mu;
  }
  if (M_bg > 0) {
      lp_obs <- lp_obs + Xobs_bg * beta_bg;
      lp_cen <- lp_cen + Xcen_bg * beta_bg;
  }
  if (M_biom > 0) {
      lp_obs <- lp_obs + Xobs_biom * beta_biom;
      lp_cen <- lp_cen + Xcen_biom * beta_biom;
  }

  yobs ~ weibull(alpha, exp(-(lp_obs)/alpha));
  increment_log_prob(weibull_ccdf_log(ycen, alpha, exp(-(lp_cen)/alpha)));

  beta_biom_raw ~ normal(0.0, 1.0);
  beta_bg_raw ~ normal(0.0, 1.0);
  alpha_raw ~ normal(0.0, 1.0);

  mu ~ normal(0.0, tau_mu);
}

