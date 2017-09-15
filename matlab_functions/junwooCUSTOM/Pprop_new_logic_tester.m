function Pprop_new_logic_tester(P_elec_level,P_av,P_pld,E_bat_max,h_max,h_0,climbAllowed)
    hList = [0:(h_0/4):(3*h_0/4),h_0:(h_max-h_0)/5:h_max,h_max*1.1,h_max*1.2]
    P_elec_level_tot = P_elec_level + P_av + P_pld;
    PList = [0:(P_elec_level_tot/5):P_elec_level_tot*1.5] % Need 1.5 Sun Goddess times Energy LOL
    EList = [0.5*E_bat_max,E_bat_max]
    disp(strcat('LengthDATA : ',num2str(numel(EList)),',',num2str(numel(hList)),',',num2str(numel(PList))));
    %junwoo = Original_Method(P_elec_level,P_av,P_pld,E_bat_max,h_max,h_0,climbAllowed,hList(11),PList(3),EList(2))
    for i = 1:numel(EList)
        E_bat = EList(i);
       for j = 1:numel(hList)
           h = hList(j);
          for k=1:numel(PList)
              P_solar = PList(k);
              temp_data_new(j,k) = New_Method(P_elec_level,P_av,P_pld,E_bat_max,h_max,h_0,climbAllowed,h,P_solar,E_bat);
              temp_data_original(j,k) = Original_Method(P_elec_level,P_av,P_pld,E_bat_max,h_max,h_0,climbAllowed,h,P_solar,E_bat);
              %disp(strcat(num2str(i),',',num2str(j),',',num2str(k)));
          end
       end
       %End of One Run...
       for j = 1:numel(hList)
           for k = 1:numel(PList)
               if(temp_data_new(j,k)~=temp_data_original(j,k))
                  Str = strcat('ConFlict',' E',num2str(E_bat),' h',num2str(hList(j)),' P',num2str(PList(k)),' New/Old= ',num2str(temp_data_new(j,k)),'/',num2str(temp_data_original(j,k)));
                  disp(Str);
               end
           end
       end
  
    end
    
end
