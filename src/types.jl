using DataFrames

abstract type AbstractForceModel end
abstract type AbstractAtmosphereModel end
abstract type AbstractWindModel end
abstract type AbstractParachuteModel end
abstract type AbstractControlModel end
abstract type AbstractIntegrator end
abstract type AbstractInterpolator end

@enum StoppingCondition apogee landing
@enum VehicleType rocket stage booster
@enum DOF six_dof three_dof 

struct Vehicle{T1 <: Real}
    name::String
    state::State
    state_history::DataFrame
    total_length::T1
    reference_length::T1
    frame_mass::T1
    frame_cg::T1
    atmosphere::T2 <: AbstractAtmosphereModel
    wind::T3 <: AbstractWindModel
    forces::Array{T4 <: AbstractForceModel}
    control_systems::Array{T5 <: AbstractControlModel}
    parachutes::Array{T6 <: AbstractParachuteModel}
end

struct State{T <: Real}
    time::T
    sB_E_E::NTuple{3, T}
    euler_angles::NTuple{3, T}
    vB_E_B::NTuple{3, T}
    wB_I_B::NTuple{3, T}
end

struct Simulation{T1 <: Real}
    initial_conditions::InitialConditions
    stopping_condition::StoppingCondition
    dof::DOF
    timestep::T1
    launch_rod_length::T1
    integrator_ascent::T2 <: AbstractIntegrator
    integrator_descent::T3 <: AbstractIntegrator
    interpolator::T4 <: AbstractInterpolator
    vehicles::Dict{String, Vehicle}
end

struct InitialConditions{T <: Real}
    initial_position::NTuple{3, T}
    initial_euler_angles::NTuple{3, T}
    initial_velocity::NTuple{3, T}
    initial_angular_velocity::NTuple{3, T} 
end