function [P_prop] = New_Method(P_elec_level,P_av,P_pld,E_bat_max,h_max,h_0,climbAllowed,h,P_solar,E_bat)
    
    extraP = P_solar - P_elec_level - P_av - P_pld;
    if(E_bat >= E_bat_max)
        if(extraP >= 0 && h < h_max) % Enough Power, Not Maximum Altitude
            P_prop = climbAllowed * extraP + P_elec_level;
        elseif(extraP >= 0 && h >= h_max) % Enough Power, Maximum Altitude
            P_prop = P_elec_level;
        elseif(extraP < 0 && h > h_0) % Not Enough Power, Higher than Needed
            P_prop = max( 0 , P_elec_level + extraP );
        elseif(extraP < 0 && h <= h_0) % Not Enough Power, Lower than Needed
             P_prop = P_elec_level;
        end
    else
        if(h>h_0) % Not Fully Charged, Altitude Higher than Needed
            P_prop = 0;
        else % Not Fully Charged, Altitude Lower than Needed
            P_prop = P_elec_level;
        end
    end
    
end
