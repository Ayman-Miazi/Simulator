include("standard_atmo.jl")

function load_atmosphere_model(name::String, config::Dict{String, Any})
    
    return construct_atmosphere_model(Val(StandardAtmo), config)
end