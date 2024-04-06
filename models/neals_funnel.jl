# This is NOT in pdb (maybe it should be?) I added this to test diagnsotic plots
# e.g. divergences.

@model function Neal()
    y ~ Normal(0,3)
    x ~ arraydist([Normal(0, exp(y/2)) for i in 1:9])
end