using PosteriorDB, DataFrames, CairoMakie, PairPlots, MCMCChains, FillArrays, OrderedCollections, Turing

function smush_reference_posterior(ref_post)
    return DataFrame(map(c -> vcat(ref_post[!, c]...), names(ref_post)), names(ref_post))
end

function get_reference_posterior(pdb_model_name::String, smush = true)
    pdb = PosteriorDB.database()
    post = PosteriorDB.posterior(pdb, pdb_model_name)
    df = DataFrame(PosteriorDB.load(PosteriorDB.reference_posterior(post)))

    if smush 
        return smush_reference_posterior(df)
    else
        return df
    end
end

function parse_stan_data_names(model_code::String) # Unused
    data_block_match = match(r"data\s*\{([\s\S]*?)\}", model_code)
    data_block = data_block_match === nothing ? "" : data_block_match[1]
    
    # Find all data variable declarations within the data block
    variable_names = match.(r"\b(\w+)\s*[\[\]]*", data_block)
    data_names = unique(filter(!isnothing, variable_names))
    
    # Extract just the name part of the matched regex
    data_names = [match[1] for match in data_names]
    
    return data_names
end 

function get_data(pdb_model_name::String)
    pdb = PosteriorDB.database()
    dataset_name, model_name = split(pdb_model_name, "-")
    return PosteriorDB.load(PosteriorDB.dataset(pdb, String(dataset_name)))
end

function test_pairs(pbd_model_draws = nothing, turing_model_draws = nothing, pars = nothing)
    return pairplot(pbd_model_draws)  
end

function get_turing_draws(pdb_model_name, turing_model, data_arg_names; samples = 10000, sampler = NUTS())
    data_full = get_data(pdb_model_name)  
    pdb = PosteriorDB.database()

    filtered_args = OrderedDict{String, Any}()
    for key in data_arg_names
        if haskey(data_full, key)
            filtered_args[key] = data_full[key]
        end
    end

    turing_post = sample(turing_model(values(filtered_args)...), sampler, samples)

    # Get samples DataFrame
    return turing_post
end


@model function eight_schools_centered(J, y, sigma)
    tau ~ Cauchy(0, 5)
    mu ~ Normal(0, 5)

    theta = Vector{Real}(undef, J)
    for i in 1:J
        theta[i] ~ Normal(mu, tau) # Vector
    end

    for i in 1:J
        y[i] ~ Normal(theta[i], sigma[i])
    end
end

df_ref = get_reference_posterior("eight_schools-eight_schools_centered")

df_turing = get_turing_draws("eight_schools-eight_schools_centered", eight_schools_centered, ["J", "y", "sigma"])


pairplot(df_ref)





