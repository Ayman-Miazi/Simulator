using SimulatorInterfaces
using CSV
using DataFrames

struct standard_atmo <: SimulatorInterfaces.AtmosphereModel
    # Define any parameters needed for the ISA model here
    ground_temperature::Float64
    ground_pressure::Float64
end

function construct_atmosphere_model(::Val{:standard_atmo}, config::Dict{String, Any})
    # Construct the ISA model using the provided configuration
    return isa(config["ground_temperature"], config["ground_pressure"])
end

function get_temperature(state::SimulatorInterfaces.State, atmosphere::ISA)
    # Implement the logic to calculate temperature based on altitude using the ISA model
    if altitude < 11000
        return atmosphere.T0 - atmosphere.lapse_rate * altitude
    else
        return atmosphere.T0 - atmosphere.lapse_rate * 11000
    end
end