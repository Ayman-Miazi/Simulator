module Transformations
    # Make more efficient by using StaticArrays.jl and by precomputing the trigonometric functions
    T_D_G(del::Real) = [cos(del)  0 sin(del); 
                        0         1 0       ; 
                        -sin(del) 0 cos(del)]
    
    T_D_E(latitude::Real, longitude::Real) = [-sin(latitude)*cos(longitude) -sin(latitude)*sin(longitude) cos(latitude) ; 
                                              -sin(longitude)               cos(longitude)                0             ; 
                                              -cos(latitude)*cos(longitude) -cos(latitude)*sin(longitude) -sin(latitude)]

    T_D_I(latitude::Real, longitude::Real) = [-sin(latitude)*cos(longitude) -sin(latitude)*sin(longitude) cos(latitude) ; 
                                              -sin(longitude)               cos(longitude)                0             ; 
                                              -cos(latitude)*cos(longitude) -cos(latitude)*sin(longitude) -sin(latitude)]

    T_W_B(roll::Real, aoa::Real) = [cos(aoa)  sin(aoa)*sin(roll) sin(aoa)*cos(roll); 
                                    0         cos(roll)          -sin(roll)        ; 
                                    -sin(aoa) cos(aoa)*sin(roll) cos(aoa)*cos(roll)]

    T_B_D(pitch::Real, yaw::Real, roll::Real) = [cos(pitch)*cos(yaw)           cos(pitch)*sin(yaw)            -sin(pitch)         ;
                                                 sin(roll)*sin(pitch)*cos(yaw) -sin(roll)*sin(pitch)*sin(yaw) sin(roll)*cos(pitch);
                                                 cos(roll)*sin(pitch)*cos(yaw) -cos(roll)*sin(pitch)*sin(yaw) cos(roll)*cos(pitch)]

    Rot_X(theta::Real) = [1 0          0          ; 
                          0 cos(theta) -sin(theta); 
                          0 sin(theta) cos(theta) ]

    Rot_Y(theta::Real) = [cos(theta)  0 sin(theta); 
                          0           1 0         ; 
                          -sin(theta) 0 cos(theta)]

    Rot_Z(theta::Real) = [cos(theta) -sin(theta) 0; 
                          sin(theta) cos(theta)  0; 
                          0          0           1]

    Ref_XY() = [0 1 0; 
                1 0 0; 
                0 0 1]

    Ref_YZ() = [1 0 0; 
                0 0 1; 
                0 1 0]  
    
    Ref_ZX() = [0 0 1; 
                0 1 0; 
                1 0 0]

    skew_symmetric(v::AbstractVector{<:Real}) = [0     -v[3] v[2] ; 
                                                 v[3]  0     -v[1]; 
                                                 -v[2] v[1]  0    ]

    skew_reduction
end