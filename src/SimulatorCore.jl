module SimulatorCore
using TOML
using Plots
using DataFrames
import SimulatorInterfaces: Rocket, State, Simulation

config = TOML.parsefile(pwd() * "/resources/vehicle_configs/vehicle_config.toml")

# Write your package code here.
include("Modules/Aerodynamics/model_loader.jl")
include("Modules/Atmosphere/model_loader.jl")
include("Modules/Gravity/model_loader.jl")
include("Modules/Propulsion/model_loader.jl")
include("Modules/Wind/model_loader.jl")

include("constants.jl")
include("integrator.jl")

global aerodynamic
global atmosphere
global gravity
global propulsion
global wind
global rocket
global state    
global simulation

function Base.getproperty(obj::State, sym::Symbol)
    if sym == :mass
        return obj.frame_mass + obj.motor_mass
    else # fallback to getfield
        return getfield(obj, sym)
    end
end

function load_rocket_properties(config::Dict{String, Any})
    frame_mass = config["frame_mass"]
    total_length = config["total_length"]
    reference_length = config["reference_length"]
    frame_cg = config["frame_cg"]
    return Rocket(frame_mass, total_length, reference_length, frame_cg)
end

function load_initial_state(config::Dict{String, Any}, rocket::Rocket, propulsion::PropulsionModel)
    time = 0.0
    position = (0, 0, config["initial_altitude"])
    rotation = Tuple(config["initial_euler_angles"])
    velocity = (0, 0, 0)
    angular_velocity = (0, 0, 0)
    frame_mass = rocket.frame_mass
    motor_mass = get_mass(propulsion)
    cg = calculate_cg(rocket, propulsion)
    return State(time, position, rotation, velocity, angular_velocity, frame_mass, motor_mass, cg)
end

function load_simulation_properties(config::Dict{String, Any})
    Simulation(config["launch_rod_length"])
end

function calculate_cg(rocket::Rocket, propulsion::PropulsionModel)
    motor_mass = get_mass(propulsion)
    return (rocket.frame_cg * rocket.frame_mass + get_cg(propulsion) * motor_mass) / (motor_mass + rocket.frame_mass)
end

function initialise_simulation()
    global aerodynamic = load_aerodynamic_model(config["models"]["aerodynamics"], config["aerodynamics"])
    global atmosphere = load_atmosphere_model(config["models"]["atmosphere"], config["atmosphere"])
    global gravity = load_gravity_model(config["models"]["gravity"], config["gravity"])
    global propulsion = load_propulsion_model(config["models"]["propulsion"], config["propulsion"])
    global wind = load_wind_model(config["models"]["wind"], config["wind"])

    global rocket = load_rocket_properties(config["rocket"])
    global simulation = load_simulation_properties(config["simulation_conditions"])
    global state = load_initial_state(config["simulation_conditions"], rocket, propulsion)
    global time_step = config["simulation_conditions"]["time_step"]
end 

function get_acceleration(state::State, sim::Simulation)
    acceleration = (get_gravity_forces(state) .+ get_aerodynamic_forces(state, rocket, aerodynamic, atmosphere, wind) .+ get_propulsion_forces(state, propulsion)) ./ state.mass
    
    if state.position[3] >= sim.launch_rod_length 
        acceleration = (0.0, 0.0, acceleration[3])
    end

    return acceleration
end

function step()
    acceleration = get_acceleration(state, simulation)
    integrate_euler(state, acceleration, (0.0, 0.0, 0.0), time_step)
end

function initialise_state_history(state::State)
    
    return DataFrame([(time=state.time, position=state.position, velocity=state.velocity, rotation=state.rotation, angular_velocity=state.angular_velocity, motor_mass=state.motor_mass, cg=state.cg)])
end

function update_state_history!(state_history::DataFrame, state::State)
    push!(state_history, [state.time, state.position, state.velocity, state.rotation, state.angular_velocity, state.motor_mass, state.cg])
end

initialise_simulation()

state_history = initialise_state_history(state)

while state.position[3] >= -10
    step()
    update_state_history!(state_history, state)
end
print(state_history)
end

