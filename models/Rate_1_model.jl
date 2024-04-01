
@model function Rate_1_model(n, k)
    theta ~ Beta(1, 1)
    k ~ binomial(n, theta)
end