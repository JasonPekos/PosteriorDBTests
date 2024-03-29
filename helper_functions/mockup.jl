using PosteriorDB, DataFrames, CairoMakie, PairPlots, MCMCChains, FillArrays, OrderedCollections, Turing


function smush_reference_posterior(ref_post::DataFrame)
    # PosteriorDB has returns a DF with each column being a variable, 
    # and each row being an entire *chain*. This smushes all the chains together to 
    # make each row a *sample*
    DataFrame([vcat(ref_post[!, c]...) for c in names(ref_post)], names(ref_post))
end

function get_reference_draws(pdb_model_name::String, smush::Bool=true)
    # PDB names models like this: "dataset_name-stan_file_name"
    # (Different models often share datasets)
    # Returns a dataset of reference posterior draws for e.g. plotting.
    pdb = PosteriorDB.database()
    post = PosteriorDB.posterior(pdb, pdb_model_name)
    df = DataFrame(PosteriorDB.load(PosteriorDB.reference_posterior(post)))
    smush ? smush_reference_posterior(df) : df
end


# function parse_stan_data_names(model_code::String) # Unused
#     # See proposal, this is a terrible failed attempt to regex data
#     # names out of the stan model string
#     data_block_match = match(r"data\s*\{([\s\S]*?)\}", model_code)
#     data_block = data_block_match === nothing ? "" : data_block_match[1]
    
#     variable_names = match.(r"\b(\w+)\s*[\[\]]*", data_block)
#     data_names = unique(filter(!isnothing, variable_names))
    
#     data_names = [match[1] for match in data_names]
    
#     return data_names
# end 

function get_data(pdb_model_name::String)
    # Gets the dataset that the model is fit on
    pdb = PosteriorDB.database()
    dataset_name, model_name = split(pdb_model_name, "-")
    PosteriorDB.load(PosteriorDB.dataset(pdb, String(dataset_name)))
end

function get_turing_draws(pdb_model_name, turing_model, data_arg_names; samples = 10000, sampler = NUTS())
    # Defaults are set to match PosteriorDB(?). Though need to check if this is consistent.
    data_full = get_data(pdb_model_name)  
    pdb = PosteriorDB.database()

    # Some models are fit to only parts of the dataset.
    filtered_args = OrderedDict{String, Any}()
    for key in data_arg_names
        if haskey(data_full, key)
            filtered_args[key] = data_full[key]
        end
    end

    turing_post = sample(turing_model(values(filtered_args)...), sampler, samples)
end






