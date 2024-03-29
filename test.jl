include("helper_functions/mockup.jl")
include("models/eight_schools_centered.jl")



df_ref = get_reference_draws("eight_schools-eight_schools_centered")

df_turing = get_turing_draws("eight_schools-eight_schools_centered", eight_schools_centered, ["J", "y", "sigma"])


save("ex1.png", pairplot(df_ref[:, [:mu, :tau]], DataFrame(df_turing)[:, [:mu, :tau]]))
