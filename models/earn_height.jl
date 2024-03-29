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

@model function earn_height(N, earn, height)
    earn .~ Normal(beta[1] + beta[2] * height, sigma)
end