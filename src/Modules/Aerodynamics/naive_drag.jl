using CSV
using DataFrames
using Interpolations
import SimulatorInterfaces: AerodynamicModel, AtmosphereModel, WindModel, construct_aerodynamic_model, get_aerodynamic_forces, get_aerodynamic_moments, get_cp, State, Rocket

struct NaiveDrag <: AerodynamicModel
    # Define the parameters and state variables for the CFD model
    drag_interpolator::AbstractInterpolation
    lateral_cd::Float64
end

function construct_aerodynamic_model(::Val{NaiveDrag}, config::Dict{String, Any}) 
    df = CSV.read(pwd() * config["path"], DataFrame)
    drag_interpolator = linear_interpolation(df[!, "Mach Number"], df[!, "Total C_D"], extrapolation_bc=Flat())
    return NaiveDrag(drag_interpolator, config["lateral_cd"])
end

function get_aerodynamic_forces(state::State, rocket::Rocket, drag_data::NaiveDrag, atmosphere::AtmosphereModel, wind::WindModel)
    # Implement the logic to calculate aerodynamic forces based on the state and model parameters
    velocity_wind = (state.velocity .- get_wind_vector(state, wind))
    velocity_magnitude = sqrt(sum(velocity_wind).^2)
    mach_number = velocity_magnitude / get_sonic_speed(state, atmosphere)
    drag_force = -0.5 .* velocity_wind .* get_density(state, atmosphere) .* velocity_magnitude .* (drag_data.lateral_cd, drag_data.lateral_cd, drag_data.drag_interpolator(mach_number)) .* pi .* rocket.reference_length.^2 ./ 4
    return drag_force # Placeholder for force calculation
end

function get_aerodynamic_moments(state::State, rocket::Rocket, drag_data::NaiveDrag, atmosphere::AtmosphereModel, wind::WindModel)
    # Implement the logic to calculate aerodynamic moments based on the state and model parameters
    moment = (0.0, 0.0, 0.0) # Placeholder for moment calculation
    return moment
end

function get_cp(state::State, drag_data::NaiveDrag)
    # Implement the logic to calculate the pressure coefficient based on the state and model parameters
    cp = -1.0
    return cp
end