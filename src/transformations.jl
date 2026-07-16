using StaticArrays

module Transformations

# MAKE A GENERIC TRANSFORMATION MATRIX FUNCTION THAT I CAN PUT SPECIFIC TYPES INTO TO CONVERT THEM
    T_G_I(del::Real, latitude::Real, Longitude::Real) = begin
        return T_D_G(del) \ T_D_I(latitude, Longitude)
    end

    T_D_G(del::Real) = begin
        # MAKE THIS FUNCTION TAKE IN HEIGHT
        cos_del = cos(del)
        sin_del = sin(del)

        return SA[ cos_del 0 sin_del; 
                   0       1 0      ; 
                  -sin_del 0 cos_del]
    end
    
    T_D_E(latitude::Real, longitude::Real) = begin
        sin_lat = sin(latitude)
        cos_lat = cos(latitude)
        sin_lon = sin(longitude)
        cos_lon = cos(longitude)

        return SA[-sin_lat*cos_lon -sin_lat*sin_lon  cos_lat; 
                  -sin_lon          cos_lon          0      ; 
                  -cos_lat*cos_lon -cos_lat*sin_lon -sin_lat]
    end

    T_D_I(latitude::Real, longitude::Real) = begin 
        sin_lat = sin(latitude)
        cos_lat = cos(latitude)
        sin_lon = sin(longitude)
        cos_lon = cos(longitude)

        return SA[-sin_lat*cos_lon -sin_lat*sin_lon  cos_lat ; 
                  -sin_lon          cos_lon          0       ; 
                  -cos_lat*cos_lon -cos_lat*sin_lon -sin_lat ]
    end

    T_W_B(roll::Real, aoa::Real) = begin 
        cos_aoa = cos(aoa)
        sin_aoa = sin(aoa)
        cos_roll = cos(roll)
        sin_roll = sin(roll)
        
        return SA[ cos_aoa  sin_aoa*sin_roll  sin_aoa*cos_roll; 
                   0        cos_roll         -sin_roll        ; 
                  -sin_aoa cos_aoa*sin_roll   cos_aoa*cos_roll]
    end

    T_B_D(pitch::Real, yaw::Real, roll::Real) = begin 
        cos_pitch = cos(pitch)
        sin_pitch = sin(pitch)
        cos_yaw = cos(yaw)
        sin_yaw = sin(yaw)
        cos_roll = cos(roll)
        sin_roll = sin(roll)

        return SA[cos_pitch*cos_yaw           cos_pitch*sin_yaw           -sin_pitch         ;
                  sin_roll*sin_pitch*cos_yaw -sin_roll*sin_pitch*sin_yaw   sin_roll*cos_pitch;
                  cos_roll*sin_pitch*cos_yaw -cos_roll*sin_pitch*sin_yaw   cos_roll*cos_pitch]
    end

    Rot_X(theta::Real) = begin 
        cos_theta = cos(theta)
        sin_theta = sin(theta)

        return SA[1 0          0        ; 
                  0 cos_theta -sin_theta; 
                  0 sin_theta  cos_theta]
    end

    Rot_Y(theta::Real) = begin
        cos_theta = cos(theta)
        sin_theta = sin(theta)
        return SA[ cos_theta 0 sin_theta; 
                   0         1 0        ; 
                  -sin_theta 0 cos_theta]
    end

    Rot_Z(theta::Real) = begin
        cos_theta = cos(theta)
        sin_theta = sin(theta)
        return SA[cos_theta -sin_theta 0; 
                  sin_theta  cos_theta 0; 
                  0          0         1]
    end

    Ref_XY() = begin
        return SA[0 1 0; 
                  1 0 0; 
                  0 0 1]
    end

    Ref_YZ() = begin
        return SA[1 0 0; 
                  0 0 1; 
                  0 1 0]  
    end

    Ref_ZX() = begin
        return SA[0 0 1; 
                  0 1 0; 
                  1 0 0]
    end
end