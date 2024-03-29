include("helper_functions/mockup.jl")
include("models/eight_schools_centered.jl")



df_ref = get_reference_posterior("eight_schools-eight_schools_centered")

df_turing = get_turing_draws("eight_schools-eight_schools_centered", eight_schools_centered, ["J", "y", "sigma"])


pairplot(df_ref, df_turing)
