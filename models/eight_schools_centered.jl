using FillArrays, LinearAlgebra

@model function eight_schools_centered(J, y, sigma)
    tau ~ Truncated(Cauchy(0, 5), 0, Inf)
    mu ~ Normal(0, 5)

    theta = Vector{Real}(undef, J)

    for i in 1:J
        theta[i] ~ Normal(mu, tau)

        y[i] ~ Normal(theta[i], sigma[i])
    end
end


@model function eight_schools_centered_2(J, y, sigma)
    tau ~ Truncated(Cauchy(0, 5), 0, Inf)
    mu ~ Normal(0, 5)

    theta ~ MvNormal(Fill(mu, length(sigma)), sqrt(tau)*I)
    y ~ MvNormal(theta, Diagonal(sqrt.(sigma)))
end