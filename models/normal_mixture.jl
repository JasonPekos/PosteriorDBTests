using Turing
using LinearAlgebra # I
using StatsFuns # logsumexp

#=
// normal mixture, unknown proportion and means, known variance
// p(y|mu,theta) = theta * Normal(y|mu[1],1) + (1-theta) * Normal(y|mu[2],1);

data {
  int<lower=0> N;
  array[N] real y;
}
parameters {
  real<lower=0, upper=1> theta;
  array[2] real mu;
}
model {
  theta ~ uniform(0, 1); // equivalently, ~ beta(1,1);
  for (k in 1 : 2) {
    mu[k] ~ normal(0, 10);
  }
  for (n in 1 : N) {
    target += log_mix(theta, normal_lpdf(y[n] | mu[1], 1.0),
                      normal_lpdf(y[n] | mu[2], 1.0));
  }
}
=#

# This is slightly different than Stan. I think Stan only works for a mixture of two
# Components and requires you to not specify the full probability vector, bc
# in 2d it's fully determined by θ
function log_mix(θs, dists, yi)
  logsumexp(log.(θs) .+ logpdf.(dists, yi))
end

@model function normal_mixture(N, y)
  θ ~ Uniform(0.0, 1.0)
  μ ~ MvNormal([0.0, 0.0], I)

  for yi in y
      Turing.@addlogprob! log_mix([θ, 1.0-θ],
          [Normal(μ[1], 1.0), Normal(μ[2], 1.0)], 
          yi)
  end
end