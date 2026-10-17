% growth_model.m
function dydt = growth_model(t, y, params)
    B = y(1); % Biomass (CFU/cm²)
    N = y(2); % Nutrients
    
    % 1. Determine Environment (24-hour cycle)
    % We assume the player practices from 6:00 PM to 8:00 PM (18:00 to 20:00)
    hour_of_day = mod(t * 24, 24); 
    is_playing = (hour_of_day >= 18) & (hour_of_day <= 20);
    
    if is_playing
        current_RH = 95; % High humidity during playing
        current_T = 30;  % Warmed by breath
    else
        current_RH = 60; % Drying out during rest (below RH_min)
        current_T = 22;  % Room temperature
    end
    
    % 2. Calculate Environmental Penalty (0 to 1)
    if current_RH < params.RH_min
        env_penalty = 0; % Fungus goes dormant if it's too dry
    else
        % Temperature penalty (1 at optimal, 0 at extremes)
        temp_penalty = max(0, 1 - abs(current_T - params.T_opt)/15);
        env_penalty = temp_penalty; 
    end
    
    % 3. Calculate Nutrient Availability (Monod kinetics)
    nutrient_availability = N / (params.K_s + N);
    
    % 4. Calculate Effective Growth Rate
    r_effective = params.r_max * env_penalty * nutrient_availability;
    
    % 5. The ODEs
    % Biomass growth (Logistic)
    dBdt = r_effective * B * (1 - B/params.K);
    
    % Nutrient addition (only when playing) and consumption by fungus
    nutrient_addition = params.nutrient_rate * is_playing;
    nutrient_consumption = 0.1 * dBdt; 
    dNdt = nutrient_addition - nutrient_consumption;
    
    % Prevent nutrients from going negative
    if N <= 0 && dNdt < 0
        dNdt = 0;
    end
    
    dydt = [dBdt; dNdt];
end
