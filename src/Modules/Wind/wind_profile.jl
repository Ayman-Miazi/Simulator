using SimulatorInterfaces
using CSV
using DataFrames

struct WindProfile <: SimulatorInterfaces.WindModel
    # Define any parameters needed for the ISA model here
    data::DataFrames.DataFrame
end

function construct_wind_model(::Val{:wind_profile}, config::Dict{String, Any})
    # Construct the ISA model using the provided configuration
    df = CSV.read(pwd() * config["path"], DataFrame)
    return WindProfile(config["ground_temperature"], config["ground_pressure"])
end