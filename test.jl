include("helper_functions/mockup.jl")
include("models/eight_schools_centered.jl")
include("models/normal_mixture.jl")



# df_ref = get_reference_draws("normal_2-normal_mixture")

df_turing = get_turing_draws("normal_2-normal_mixture", normal_mixture, ["N", "y"])


pairplot(df_turing)

