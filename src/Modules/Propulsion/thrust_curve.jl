struct DragData <: SimulatorInterfaces.AerodynamicModel
    # Define the parameters and state variables for the CFD model
    thrust_data::DataFrames.DataFrame
    mass_dry::Float64
    mass_wet::Float64
    length
end
