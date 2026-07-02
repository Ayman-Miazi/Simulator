abstract type Integrator end

struct EulerIntegrator <: Integrator 
end

struct RK4Integrator <: Integrator 
end

integrate(integrator::Integrator, state::State, dt::Float64) = error("integrate not implemented for $(typeof(integrator))")

function integrate_euler(state::State, acceleration::Tuple{Float64, Float64, Float64}, angular_acceleration::Tuple{Float64, Float64, Float64}, dt::Float64)
    state.time = state.time .+ dt
    state.position = state.position .+ state.velocity .* dt
    state.rotation = state.rotation
    state.velocity = state.velocity .+ acceleration .* dt
    state.angular_velocity = state.angular_velocity .+ angular_acceleration .* dt
    state.motor_mass = state.motor_mass .+ get_mass_flow(state, propulsion) .* dt
    state.cg = calculate_cg(rocket, propulsion)
end

function integrate(::RK4Integrator, state::State, dt::Float64)

end