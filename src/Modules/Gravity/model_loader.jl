include("naive_gravity.jl")

function load_gravity_model(name::String, config::Dict{String, Any})
    
    return construct_gravity_model(Val(Symbol(name)), config)
end