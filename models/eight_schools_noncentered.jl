using LinearAlgebra, FillArrays


# Naive Implementation
@model function eight_schools_noncentered(J, y, sigma)
    tau ~ Truncated(Cauchy(0, 5), 0, Inf)
    mu ~ Normal(0, 5)

    theta_trans = Vector{Real}(undef, J)
    theta = Vector{Real}(undef, J)

    for i in 1:J
        theta_trans[i] ~ Normal(0, 1)
        theta[i] = tau * theta_trans[i] + mu

        y[i] ~ Normal(theta[i], sigma[i])
    end

    return theta
end

# No loops, with MvNormals
@model function eight_schools_noncentered_2(J, y, sigma)
    tau ~ Truncated(Cauchy(0, 5), 0, Inf)
    mu ~ Normal(0, 5)

    theta_trans ~ MvNormal(Fill(0, length(sigma)), I)

    theta = [tau * s + mu for s in theta_trans]
        
    y ~ MvNormal(theta, sqrt.(sigma))

    return theta
end