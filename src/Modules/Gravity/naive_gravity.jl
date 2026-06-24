using SimulatorInterfaces

struct naive_gravity <: SimulatorInterfaces.GravityModel
    # Define any parameters needed for the ISA model here
    ground_temperature::Float64
    ground_pressure::Float64
end

function construct_atmosphere_model(::Val{:isa}, config::Dict{String, Any})
    # Construct the ISA model using the provided configuration
    return isa(config["ground_temperature"], config["ground_pressure"])
end