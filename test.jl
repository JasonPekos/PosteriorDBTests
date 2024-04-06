include("helper_functions/mockup.jl")
include("models/eight_schools_centered.jl")



df_ref = get_reference_draws("eight_schools-eight_schools_centered")

df_turing = get_turing_draws("eight_schools-eight_schools_centered", eight_schools_centered, ["J", "y", "sigma"])

get_data("normal_2-normal_mixture")

pairplot(df_ref, df_turing)


get_data("normal_2-normal_mixture")["y"]