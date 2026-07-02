using CSV
using DataFrames
import SimulatorInterfaces: AtmosphereModel, construct_atmosphere_model, get_density, get_pressure, get_sonic_speed, get_temperature, State

struct StandardAtmo <: AtmosphereModel
    # Define any parameters needed for the ISA model here
    ground_temperature::Float64
    ground_pressure::Float64
    
end

function construct_atmosphere_model(::Val{StandardAtmo}, config::Dict{String, Any})
    # Construct the ISA model using the provided configuration
    return StandardAtmo(config["ground_temperature"], config["ground_pressure"])
end

function get_temperature(state::State, atmosphere::StandardAtmo)
    # Implement the logic to calculate temperature based on altitude using the ISA model
    altitude = state.position[3]

    if altitude < 11000
        return atmosphere.ground_temperature - LAPSE_RATE * altitude
    else
        return atmosphere.T0 - atmosphere.lapse_rate * 11000
    end
end

function get_pressure(state::State, atmosphere::StandardAtmo)
    # Implement the logic to calculate pressure based on altitude using the ISA model
    altitude = state.position[3]

    if altitude < 11000
        return atmosphere.ground_pressure * (1 - LAPSE_RATE * altitude / atmosphere.ground_temperature) ^ (GRAVITY / (LAPSE_RATE * GAS_CONSTANT))
    else
        return atmosphere.ground_pressure * (1 - LAPSE_RATE * 11000 / atmosphere.ground_temperature) ^ (GRAVITY / (LAPSE_RATE * GAS_CONSTANT)) * exp(-GRAVITY * (state.position[3] - 11000) / (GAS_CONSTANT * get_temperature(state, atmosphere)))
    end
end

function get_density(state::State, atmosphere::StandardAtmo)
    # Implement the logic to calculate density based on altitude using the ISA model
    return get_pressure(state, atmosphere) / (GAS_CONSTANT * get_temperature(state, atmosphere))
end

function get_sonic_speed(state::State, atmosphere::StandardAtmo)
    # Implement the logic to calculate sonic speed based on altitude using the ISA model
    return sqrt(ADIABATIC_INDEX * GAS_CONSTANT * get_temperature(state, atmosphere))
end