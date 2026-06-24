using SimulatorInterfaces
using CSV
using DataFrames

struct DragData <: SimulatorInterfaces.AerodynamicModel
    # Define the parameters and state variables for the CFD model
    data::DataFrames.DataFrame
end

function construct_aerodynamic_model(::Val{:naive_drag}, config::Dict{String, Any}) 
    df = CSV.read(pwd() * config["path"], DataFrame)
    return DragData(df)
end

function get_aerodynamic_forces(state::SimulatorInterfaces.State, rocket::SimulatorInterfaces.Rocket, drag_data::DragData, atmosphere::SimulatorInterfaces.AtmosphereModel)
    # Implement the logic to calculate aerodynamic forces based on the state and model parameters
    mach_number = state.velocity[1] / atmosphere.sound_speed
    drag_force = - 0.5 * atmosphere.density * state.velocity^2 * drag_data.data[1, :drag_coefficient] * pi * rocket.reference_length^2 / 4
    force = (0, drag_force, 0)
    return force # Placeholder for force calculation
end

function get_aerodynamic_moments(state::SimulatorInterfaces.State, rocket::SimulatorInterfaces.Rocket, drag_data::DragData, atmosphere::SimulatorInterfaces.AtmosphereModel)
    # Implement the logic to calculate aerodynamic moments based on the state and model parameters
    moment = (0.0, 0.0, 0.0) # Placeholder for moment calculation
    return moment
end

function get_cp(state::SimulatorInterfaces.State, drag_data::DragData)
    # Implement the logic to calculate the pressure coefficient based on the state and model parameters
    cp = -1.0
    return cp
end