import SimulatorInterfaces: GravityModel, construct_gravity_model, get_gravity_forces, get_gravity_moments, State

struct NaiveGravity <: GravityModel
    # Define any parameters needed for the ISA model here
end

function construct_gravity_model(::Val{NaiveGravity}, config::Dict{String, Any})
    # Construct the ISA model using the provided configuration
    return NaiveGravity()
end

function get_gravity_forces(state::State)
    gravity = state.mass * GRAVITY * R_EARTH ^ 2 / (R_EARTH + state.position[3]) ^ 2 
    return (0.0, 0.0, -gravity)
end

function get_gravity_moments(state::State)
    # Implement the logic to calculate gravity moments based on the state and model parameters
    moment = (0.0, 0.0, 0.0) # Placeholder for moment calculation
    return moment
end