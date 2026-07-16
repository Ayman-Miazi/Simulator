using YAML
using .Transformations

include("types.jl")
include("integrator.jl")

module Simulator
    function initialise(simulation_config::String)

        function construct_vehicle(vehicle_config::String)
            # Maybe replace eval(Meta.parse) with get_field to do it better
            # Allow for frame MOI to be gotten from a calculator in future
            config = YAML.load_file(vehicle_config * ".yaml")
            
            force_list = [config["models"]["gravity"]["type"], config["models"]["aerodynamics"]["type"]]
            append!(force_list, config["models"]["motors"])
            append!(force_list, config["models"]["force_effectors"])

            return Vehicle(
                config["vehicle_parameters"]["name"],
                initial_conditions,
                DataFrame(time=Float64[], sB_E_E=SVector{3, Float64}[], T_B_I=SMatrix{3, 3, Float64}[], vB_E_B=SVector{3, Float64}[], wB_I_B=SVector{3, Float64}[]),
                config["vehicle_parameters"]["total_length"],
                config["vehicle_parameters"]["reference_length"],
                config["vehicle_parameters"]["frame_mass"],
                config["vehicle_parameters"]["frame_cg"],
                config["vehicle_parameters"]["frame_moi"],
                eval(Meta.parse(config["models"]["atmosphere"]["type"])),
                eval(Meta.parse(config["models"]["wind"]["type"])),
                map((x) -> eval(Meta.parse(x)), force_list),
                eval(Meta.parse(config["models"]["control_systems"]["type"])),
                eval(Meta.parse(config["models"]["parachutes"]["type"]))
            )
        end
        config = YAML.load_file(simulation_config * ".yaml")

        initial_position = Transformations.T_D_I(config["simulation_parameters"]["initial_conditions"]["latitude"],
                                                 config["simulation_parameters"]["initial_conditions"]["longitude"]) / Transformations.T_D_G(config["simulation_parameters"]["initial_conditions"]["altitude"]) * SA[0 0 -(R0 + config["simulation_parameters"]["initial_conditions"]["altitude"])]
        initial_angular_position = Transformations.T_D_B(yaw, pitch, 0) * Transformations.T_D_I(config["simulation_parameters"]["initial_conditions"]["latitude"],
                                                                        config["simulation_parameters"]["initial_conditions"]["longitude"])
        initial_velocity = Transformations.T_D_B(yaw, pitch, 0) * speed * SA[cos(azimuth)*cos(altitude) sin(altitude) sin(azimuth)*cos(altitude)]
        initial_angular_velocity = config["simulation_parameters"]["initial_conditions"]["angular_velocity"] # MAYBE INITIALISE SO THAT IT CAN BE NONZERO, WITH HOW ZIPFEL DOES IT

        initial_conditions = State(
            initial_position,
            initial_velocity,
            initial_angular_position,
            initial_angular_velocity
        )
        
        #Alter code to dynamically create new vehicle instances with a function based on the vehicles list in the config file,
        return Simulation(
            initial_conditions,
            eval(Symbol(config["simulation_parameters"]["stopping_condition"]["type"])),
            eval(Symbol(config["simulation_parameters"]["dof"]["type"])),
            config["simulation_parameters"]["timestep"],
            config["simulation_parameters"]["launch_rod_length"],
            eval(Meta.parse(config["simulation_parameters"]["integrator_ascent"]["type"])),
            eval(Meta.parse(config["simulation_parameters"]["integrator_descent"]["type"])),
            eval(Meta.parse(config["simulation_parameters"]["interpolator"]["type"])),
            map((x) -> construct_vehicle(x["config"]), config["vehicles"])
        )

    end

    # SEPARATE AERODYNAMICS, GRAVITY, MOTORS, AND EFFECTORS? MAKE IT EASIER TO GET THINGS LIKE MASS, MOI, CONVERTING FORCES IF DO SO
    # ADD PROPERTY GETTER AND SETTERS FOR MASS, MOI, CG
    function get_acceleration(rocket::Rocket)
        net_force = sum(map((x) -> x.get_force(rocket), rocket.forces))

        return net_force / rocket.mass
    end

    function get_angular_acceleration(rocket::Rocket)
        net_moment = sum(map((x) -> x.get_moment(rocket), rocket.forces))
        
        return rocket.moi \ (-cross(rocket.state.wB_I_B, rocket.moi * rocket.state.wB_I_B) + net_moment)
    end

    function get_direction_cosine_matrix(rocket::Rocket)
        return -rocket.state.wB_I_B * rocket.state.T_B_I
    end

    function iterate(simulation::Simulation)
        
    end

    function run_simulation(simulation::Simulation)

    end

    function post_process(simulation::Simulation)

    end
end