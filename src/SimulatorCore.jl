module SimulatorCore

using TOML
using SimulatorInterfaces

config = TOML.parsefile(pwd() * "/resources/vehicle_configs/vehicle_config.toml")

# Write your package code here.
include("Modules/Aerodynamics/model_loader.jl")
include("Modules/Atmosphere/model_loader.jl")
include("Modules/Gravity/model_loader.jl")
include("Modules/Propulsion/model_loader.jl")
include("Modules/Wind/model_loader.jl")

include("constants.jl")

function load_rocket_properties(config::Dict{String, Any})
    frame_mass = config["frame_mass"]
    total_length = config["total_length"]
    reference_length = config["reference_length"]
    frame_cg = config["frame_cg"]
    return SimulatorInterfaces.Rocket(frame_mass, total_length, reference_length, frame_cg)
end

function load_initial_conditions(config::Dict{String, Any})
    position = config[]
end

rocket = load_rocket_properties(config["rocket"])

aerodynamic_model = load_aerodynamic_model(config["models"]["aerodynamics"], config["aerodynamics"])
atmosphere_model = load_atmosphere_model(config["models"]["atmosphere"], config["atmosphere"])
gravity_model = load_gravity_model(config["models"]["gravity"], config["gravity"])
propulsion_model = load_propulsion_model(config["models"]["propulsion"], config["propulsion"])
wind_model = load_wind_model(config["models"]["wind"], config["wind"])

currentstate = SimulatorInterfaces.State((0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), (0.0, 0.0, 0.0), 1, -1)
end
