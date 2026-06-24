include("thrust_curve.jl")

function load_propulsion_model(name::String, config::Dict{String, Any})
    
    return construct_propulsion_model(Val(Symbol(name)), config)
end