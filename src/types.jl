using DataFrames
using StaticArrays
using .Transformations

# MOVE CONSTRUCTORS HERE

abstract type AbstractForceModel end
abstract type AbstractAtmosphereModel end
abstract type AbstractWindModel end
abstract type AbstractParachuteModel end
abstract type AbstractControlModel end
abstract type AbstractSeparationModel end
abstract type AbstractIntegrator end
abstract type AbstractInterpolator end

@enum StoppingCondition apogee landing
@enum VehicleType rocket stage booster
@enum DOF six_dof three_dof 
@enum CoordinateSystem inertial geocentric geodetic geographic body
@enum Frame heliocentric inertial earth body

struct Vehicle{T1 <: Real}
    name::String
    state::State
    state_history::DataFrame
    total_length::T1
    reference_length::T1
    frame_mass::T1
    frame_cg::T1
    frame_moi::SMatrix{3, 3, T1}
    atmosphere::T2 <: AbstractAtmosphereModel
    wind::T3 <: AbstractWindModel
    forces::Array{T4 <: AbstractForceModel}
    control_systems::Array{T5 <: AbstractControlModel}
    parachutes::Array{T6 <: AbstractParachuteModel}
end

struct Stage
    vehicle::Vehicle
    separation_type::Union{T <: AbstractSeparationModel, Nothing}
    position_offset::SVector{3, Float64}
    rotation_offset::SVector{3, Float64}
end

mutable struct State{T <: Real}
    time::T
    sB_I_I::SVector{3, T}
    vB_I_I::SVector{3, T}
    T_B_I::SMatrix{3, 3, T}
    wB_I_B::SVector{3, T}
end

struct Simulation{T1 <: Real}
    initial_conditions::State
    stopping_condition::StoppingCondition
    dof::DOF
    timestep::T1
    launch_rod_length::T1
    integrator_ascent::T2 <: AbstractIntegrator
    integrator_descent::T3 <: AbstractIntegrator
    interpolator::T4 <: AbstractInterpolator
    vehicles::Dict{String, Vehicle}
end

function Base.push!(c::DataFrame, s::State)
    push!(c, (s.time, s.sB_I_I, s.vB_E_B, s.T_B_I, s.wB_I_B))
end

function Base.:+(a::State, b::State)
    new_T_B_I = a.T_B_I + b.T_B_I
    new_T_B_I[:, 3] = cross(new_T_B_I[:, 1], new_T_B_I[:, 2])
    return State(a.time + b.time,
                 a.sB_I_I + b.sB_I_I,
                 a.vB_I_I + b.vB_I_I,
                 new_T_B_I,
                 a.wB_I_B + b.wB_I_B)
end 

function Base.:-(a::State, b::State)
    new_T_B_I = a.T_B_I - b.T_B_I
    new_T_B_I[:, 3] = cross(new_T_B_I[:, 1], new_T_B_I[:, 2])
    return State(a.time - b.time,
                 a.sB_I_I - b.sB_I_I,
                 a.vB_I_I - b.vB_I_I,
                 new_T_B_I,
                 a.wB_I_B - b.wB_I_B)
end