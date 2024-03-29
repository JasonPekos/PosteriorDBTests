function parse_stan_data_names(model_code::String)
    # Extract the data block using regex, ensuring we catch the entire block
    data_block_match = match(r"data\s*\{([\s\S]*?)\}", model_code)
    if data_block_match === nothing
        return String[]
    end
    data_block = data_block_match[1]

    # Regex to find variable names: Look for word characters following type declarations up to a semicolon
    variable_matches = match.(r"(?<=\>\s)\w+", data_block)

    # Initialize an empty array for data names
    data_names = []

    # Iterate through matches to extract variable names
    for m in variable_matches
        if !isnothing(m)
            push!(data_names, m.match)
        end
    end

    return data_names
end

# Stan model code example
stan_model_code = """
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
"""

# Call the function and display the result
data_names = parse_stan_data_names(stan_model_code)
println(data_names)
