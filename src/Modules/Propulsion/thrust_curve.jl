using SimulatorInterfaces
using CSV
using DataFrames

struct ThrustCurve <: SimulatorInterfaces.PropulsionModel
    # Define the parameters and state variables for the CFD model
    thrust_data::DataFrames.DataFrame
    mass_dry::Float64
    mass_wet::Float64
    length::Float64
end

function construct_propulsion_model(::Val{:thrust_curve}, config::Dict{String, Any})
    # Construct the thrust curve model using the provided configuration
    return ThrustCurve(config["thrust_data"], config["mass_dry"], config["mass_wet"], config["length"])
end
