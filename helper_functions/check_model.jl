using CairoMakie
using Makie
using MCMCChains
using PairPlots

function check_diagnostics(samples)
    divs = sum(samples[:numerical_error])
    if divs > 0 
        @warn "Detected $divs divergences when sampling "
    end
    if any(DataFrame(rhat(samples))[!, :rhat] .> 1.05)
        @warn "Chain has rhat larger than 1.05"
    end
    # Add ESS checks
end

function makie_chainplot(samples)
    par_samples = MCMCChains.Chains(samples, :parameters)
    f_chains = Figure(; size=(1_000, 200 * length(names(par_samples))))
    for (i, var) in enumerate(names(par_samples))
        ax = Axis(f_chains[i, 1]; ylabel=string(var))
        for chn in chains(df_turing)
            values = par_samples[:, var, chn]
            lines!(ax, 1:length(par_samples), values; label=string(chn))
        end
        hideydecorations!(ax; label=false)
        if i < length(names(par_samples)) hidexdecorations!(ax; grid=false) end
    end

    return f_chains
end

function makie_divplot(samples, p1, p2)
    fig = Figure(; size = (400, 400))

    # Scatter - No Numerical Error
    scatter(fig[1,1],
     DataFrame(samples)[!, p1],
     DataFrame(samples)[!, p2],
     alpha = 0.2)

    # Scatter - Numerical Error
    divergent_samples = filter(row -> row.numerical_error == 1,
                            DataFrame(samples))

    if length(divergent_samples[!, p1]) > 0
        scatter!(fig[1,1],
        divergent_samples[!, p1],
        divergent_samples[!, p2],
        color = :red)
    end

    # Return
    return fig
end


function diagnose(modelname, samples;
     chainplot = true,
     posterior_predictive = true,
     pairs_plot = true,
     params_specified = nothing)
    # Warn about divergences in the chain
    check_diagnostics(samples)

    # Plot Chains, Posterior Predictive, PairsPlots with Divs
    if chainplot == true
        

    end
end