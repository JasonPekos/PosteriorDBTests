
# Inferring a common rate
@model function Rate_2_model(n1, n2, k1, k2)
    theta ~ Beta(1, 1)

    k1 ~ binomial(n1, theta)
    k2 ~ binomial(n2, theta)
end