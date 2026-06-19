module SimulatorCore

# Write your package code here.
include("Modules/Aerodynamics/cfd.jl")

struct state <: SimulatorInterfaces.State
    # Define the state variables for the simulator
    time::Float64
    position::Tuple{Float64, Float64, Float64}
    velocity::Tuple{Float64, Float64, Float64}
end

currentstate = state(0.0, (0.0, 0.0, 0.0), (0.0, 0.0, 0.0))

cfdmodel = CFDModel(10.0, 101325.0, 1.225)
println(get_aerodynamic_forces(currentstate, cfdmodel))
end
