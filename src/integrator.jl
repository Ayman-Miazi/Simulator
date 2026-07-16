struct EulerIntegrator <: AbstractIntegrator end
struct RK4Integrator <: AbstractIntegrator end

function integrate_step(::EulerIntegrator, ode::Function, rocket::Rocket, dt::T <: Real)
    return rocket.state + ode(rocket, 0, 0) * dt
end

function integrate_step(::RK4Integrator, ode::Function, rocket::Rocket, dt::T <: Real)
    k1 = ode(rocket, 0)
    k2 = ode(rocket, k1 * dt / 2)
    k3 = ode(rocket, k2 * dt / 2)
    k4 = ode(rocket, k3 * dt, dt)
    return rocket.state + (k1 + 2k2 + 2k3 + k4) * dt / 6
end