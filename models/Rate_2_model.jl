
@model function Rate_2_model(n1, n2, k1, k2)
    theta1 ~ Beta(1, 1)
    theta2 ~ Beta(1, 1)
    k1 ~ binomial(n1, theta1)
    k2 ~ binomial(n2, theta2)

    delta = theta1 - theta2
    return delta
end