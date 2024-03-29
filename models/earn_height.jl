using Turing

#= STAN MODEL
data {
  int<lower=0> N;
  vector[N] earn;
  vector[N] height;
}
parameters {
  vector[2] beta;
  real<lower=0> sigma;
}
model {
  earn ~ normal(beta[1] + beta[2] * height, sigma);
}
=#

# @model function earn_height(N, earn, height)
#     beta .~ Uniform(-100, 100) # Need to look up stan default priors
#     sigma .~ Uniform(0, 100)
#     earn .~ Normal(beta[1] + beta[2] * height, sigma)
# end