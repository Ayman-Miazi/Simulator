module SimulatorCore

using TOML

# Write your package code here.
include("Modules/Aerodynamics/naive_drag.jl")

drag_data = read_drag_data(pwd() * "/resources/drag_data/drag_data.csv", 1.0)

currentstate = SimulatorInterfaces.State((0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 1)
end
