include("wind_profile.jl")

function load_wind_model(name::String, config::Dict{String, Any})
    
    return construct_wind_model(Val(WindProfile), config)
end