function [P_prop] = Original_Method(P_elec_level,P_av,P_pld,E_bat_max,h_max,h_0,climbAllowed,h,P_solar,E_bat)

    P_elec_level_tot = P_elec_level + P_av + P_pld; % originally calculated in performanceEvaluator

    if(E_bat >= E_bat_max) %fully charged! ->dayflight=> level flight/climb

        %Case 1: Already above h_0, i.e. in climbing or descending flight
        if(h > h_0)
            %CONTROL-LAW: Put P_prop=0 only when P_Solar<P_0
            if(P_solar >= (P_av+P_pld))
                if(h < h_max)
                    P_prop = P_solar - P_av - P_pld;
                elseif(h >= h_max)
                    if(P_solar >= P_elec_level_tot)
                        %Standard control: Only give level power
                        P_prop = P_elec_level;
                    else
                        %Start sinking cause not enough solar energy for level flight
                        P_prop = P_solar - P_av - P_pld;
                    end
                end 
            else
                P_prop=0;
            end
        %Case 2: At h_0, i.e. begin climb now or stay    
        else
            P_prop = P_elec_level + climbAllowed * max(0,P_solar-P_elec_level-P_av-P_pld);
        end
    else
        %Case 3: Above std-altitude: Sinking with propeller power=0->u=-Plevel...
        if h > h_0
            P_prop = 0;
        %Case 4: At std-altitude: charge battery only OR do level flight at night!    
        else
            P_prop = P_elec_level;
        end
    end
    
end
