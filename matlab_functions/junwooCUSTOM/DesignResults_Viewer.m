function DesignResults_Viewer(vars,plane,environment,params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%m_solar m_mppt m_central m_distr m_struct masses thicknesses velocities
%polar Can be PLOTTED....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ctr = 0;
    for i = 1:numel(vars(3).values)
        for k = 1:numel(vars(2).values)
            for j = 1:numel(vars(1).values)

                ctr = ctr+1;
                varval(3)=vars(3).values(i);
                varval(2)=vars(2).values(k);
                varval(1)=vars(1).values(j);

                %Assign variables dynamically
                idx = find(vars == VAR.WING_SPAN,1,'first');
                if ~isempty(idx) ; plane.struct.b = varval(idx); end
                idx = find(vars == VAR.BATTERY_MASS,1,'first');
                if ~isempty(idx) ; plane.bat.m = varval(idx); end
                idx = find(vars == VAR.ASPECT_RATIO,1,'first');
                if ~isempty(idx) ; plane.struct.AR = varval(idx); end
                idx = find(vars == VAR.CLEARNESS,1,'first');
                if ~isempty(idx) ; environment.clearness = varval(idx); end
                idx = find(vars == VAR.TURBULENCE,1,'first');
                if ~isempty(idx) ; environment.turbulence = varval(idx); end
                idx = find(vars == VAR.DAY_OF_YEAR,1,'first');
                if ~isempty(idx) ; environment.dayofyear = varval(idx); end
                idx = find(vars == VAR.LATITUDE,1,'first');
                if ~isempty(idx) ; environment.lat = varval(idx); end
                
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              %% set the masses of the various components
                % ========================================

                % Solar module
                m_solar(i,k,j) = plane.struct.b^2/plane.struct.AR*params.solar.rWngCvrg*...
                    (params.solar.k_sc+params.solar.k_enc);

                % MPPT
                I_max = 1000; %[W/m^2]
                m_mppt(i,k,j) = params.solar.k_mppt*I_max*plane.struct.b^2/plane.struct.AR ...
                    *params.solar.eta_sc*params.solar.eta_cbr;

                % total point mass
                m_central(i,k,j) = m_mppt(i,k,j) + plane.payload.mass+plane.avionics.mass...
                    +(1-params.bat.distr)*plane.bat.m;

                % total distributed mass
                m_distr(i,k,j) = m_solar(i,k,j) + plane.bat.m * params.bat.distr;
                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %% Save Design Results
                if(params.structure.shell==1)
                    [m_struct(i,k,j),masses(i,k,j),thicknesses(i,k,j),velocities(i,k,j),polar(i,k,j)]=StructureDesigner(plane.struct.b,...
                    plane.struct.AR, m_central(i,k,j),m_distr(i,k,j),params.propulsion.number,environment.usemars,params.structure.corr_fact);
                else
                    [m_struct(i,k,j),masses(i,k,j),thicknesses(i,k,j),velocities(i,k,j),polar(i,k,j)]=StructureDesignerRibWing(plane.struct.b,...
                    plane.struct.AR, m_central(i,k,j),m_distr(i,k,j),params.prop.number,environment.usemars,params.structure.corr_fact);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
        end
        str = strcat( vars(3).shortname , '=' , num2str(vars(3).values(i)) , ' bat_distr=' , num2str(params.bat.distr) );
        figure('Name',str);
        FontSize = 10;
        vmargin = 0.10;
        hmargin = 0.05;
        Xval = vars(1).values;
        LegendArray = {}; % Cell Array.
        Yval = [];
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ax(1) = subplot_tight(2,2,1,[vmargin hmargin]);
        
        for k = 1:numel(vars(2).values)
            Yval = m_struct(i,k,:);
            LegendArray{k} = strcat(vars(2).shortname,'=',num2str(vars(2).values(k)));
            plot(Xval,Yval(:));
            hold on; % For next Plotting.
        end
        legend(LegendArray');%Transposed array.
        %ylabel('m_struct');
        xlabel(vars(1).name);
        title('M struct');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ax(end+1) = subplot_tight(2,2,2,[vmargin hmargin]);
        
        for k = 1:numel(vars(2).values)
            Yval = [thicknesses(i,k,:).t_sp_wing];
            LegendArray{k} = strcat(vars(2).shortname,'=',num2str(vars(2).values(k)));
            plot(Xval,Yval);
            hold on; % For next Plotting.
        end
        legend(LegendArray');%Transposed array.
        %ylabel('');
        xlabel(vars(1).name);
        title('t sp wing');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ax(end+1) = subplot_tight(2,2,3,[vmargin hmargin]);
        
        for k = 1:numel(vars(2).values)
            Yval = [thicknesses(i,k,:).t_f_wing];
            LegendArray{k} = strcat(vars(2).shortname,'=',num2str(vars(2).values(k)));
            plot(Xval,Yval);
            hold on; % For next Plotting.
        end
        legend(LegendArray');%Transposed array.
        %ylabel('');
        xlabel(vars(1).name);
        title('t f wing');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        ax(end+1) = subplot_tight(2,2,4,[vmargin hmargin]);
        
        for k = 1:numel(vars(2).values)
            Yval = [velocities(i,k,:).v_cn];
            LegendArray{k} = strcat(vars(2).shortname,'=',num2str(vars(2).values(k)));
            plot(Xval,Yval);
            hold on; % For next Plotting.
        end
        legend(LegendArray');%Transposed array.
        %ylabel('');
        xlabel(vars(1).name);
        title('v cn');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        set(ax,'FontSize',FontSize);
    
    end
    
end
        
