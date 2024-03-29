@model function eight_schools_centered(J, y, sigma)
    tau ~ Truncated(Cauchy(0, 5), 0, Inf)
    mu ~ Normal(0, 5)

    theta = Vector{Real}(undef, J)

    for i in 1:J
        theta[i] ~ Normal(mu, tau)
    end

    y .~ Normal(theta[i], sigma[i])
end