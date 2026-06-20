function load_aerodynamic_model(name::String, config::Dict)
    include("$(name).jl")

    return construct_aerodynamic_model(config)
end