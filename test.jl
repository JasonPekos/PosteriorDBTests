include("helper_functions/mockup.jl")
include("helper_functions/check_model.jl")
include("models/eight_schools_centered.jl")
include("models/normal_mixture.jl")




df_ref = get_reference_draws("normal_2-normal_mixture")

df_turing = get_turing_draws("eight_schools-eight_schools_centered", eight_schools_centered_2, ["J", "y", "sigma"])

makie_divplot(df_turing, :mu, "theta[1]")


(df_turing)

