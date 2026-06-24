include("naive_drag.jl")
include("cfd.jl")
include("barrowman.jl")

function load_aerodynamic_model(name::String, config::Dict{String, Any})
    
    return construct_aerodynamic_model(Val(Symbol(name)), config)
end