using CSV
using DataFrames
using Interpolations
import SimulatorInterfaces: PropulsionModel, construct_propulsion_model, get_propulsion_forces, get_propulsion_moments, State

struct ThrustCurve <: PropulsionModel
    # Define the parameters and state variables for the CFD model
    thrust_interpolator::AbstractInterpolation
    thrust_data::DataFrames.DataFrame
    dry_mass::Float64
    prop_mass::Float64
    length::Float64
    diameter::Float64
end

function construct_propulsion_model(::Val{ThrustCurve}, config::Dict{String, Any})
    # Construct the thrust curve model using the provided configuration
    raw_data = readlines(pwd() * config["path"])
    motor_info = split.(raw_data[2])

    diameter = parse.(Float64, motor_info[2])
    length = parse.(Float64, motor_info[3])
    prop_mass = parse.(Float64, motor_info[5])
    dry_mass = parse.(Float64, motor_info[6]) - prop_mass
    
    thrust_data = transpose(parse.(Float64,reduce(hcat, split.(raw_data[3:end]))))
    thrust_data = DataFrame(thrust_data, ["time", "thrust"])

    thrust_interpolator = linear_interpolation(thrust_data.time, thrust_data.thrust, extrapolation_bc=Flat())
    
    return ThrustCurve(thrust_interpolator, thrust_data, dry_mass, prop_mass, length, diameter)
end

function get_mass(thrust_curve::ThrustCurve)
    return thrust_curve.dry_mass + thrust_curve.prop_mass
end

function get_cg(thrust_curve::ThrustCurve)
    return -thrust_curve.length/2
end

function get_propulsion_forces(state::State, thrust_curve::ThrustCurve)
    return (0.0, 0.0, thrust_curve.thrust_interpolator(state.time))
end

function get_propulsion_moments(state::State, thrust_curve::ThrustCurve)
    # Implement the logic to calculate propulsion moments based on the state and model parameters
    moment = (0.0, 0.0, 0.0) # Placeholder for moment calculation
    return moment
end

function get_mass_flow(state::State, thrust_curve::ThrustCurve)
    time_bounds = thrust_curve.thrust_data.time
    if state.time > time_bounds[end]
        return 0
    else
       return -thrust_curve.prop_mass / (time_bounds[end] - time_bounds[1])
    end
end