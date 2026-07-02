using CSV
using DataFrames
import SimulatorInterfaces: WindModel, construct_wind_model, get_wind_vector, State

struct WindProfile <: WindModel
    # Define any parameters needed for the ISA model here
    speed_interpolator::AbstractInterpolation
    direction_interpolator::AbstractInterpolation
end

function construct_wind_model(::Val{WindProfile}, config::Dict{String, Any})
    # Construct the ISA model using the provided configuration
    df = CSV.read(pwd() * config["path"], DataFrame)
    speed_interpolator = linear_interpolation(df[!, "altitude (m AGL)"], df[!, "velocity (m/s)"], extrapolation_bc=Flat())
    direction_interpolator = linear_interpolation(df[!, "altitude (m AGL)"], df[!, "bearing (degrees clockwise from true north)"], extrapolation_bc=Flat())
    return WindProfile(speed_interpolator, direction_interpolator)
end

function get_wind_vector(state::State, wind_profile::WindProfile)
    # Implement the logic to calculate wind vector based on altitude using the provided wind profile
    altitude = state.position[3] # Assuming altitude is the z-component of position
    speed = wind_profile.speed_interpolator(altitude)
    direction = wind_profile.direction_interpolator(altitude)
    
    # Convert direction from degrees to radians
    direction_rad = deg2rad(direction)
    
    # Calculate wind vector components
    wind_x = speed * sin(direction_rad)
    wind_y = speed * cos(direction_rad)
    
    return (wind_x, wind_y, 0.0) # Assuming no vertical wind component
end