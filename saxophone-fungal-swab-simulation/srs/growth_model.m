function dydt = growth_model(t, y, r_max, env)
    B = y(1); 
    N = y(2); 
    
    % Playing cycle (14:00 to 20:00 = 6 hours)
    hour_of_day = mod(t * 24, 24); 
    is_playing = (hour_of_day >= 14) & (hour_of_day <= 20);
    
    % Humid closed case (85% RH) vs Playing (95% RH)
    if is_playing
        current_RH = 95; 
        current_T = 30;  
    else
        current_RH = 85; % Closed case
        current_T = 22;  
    end
    
    % Environmental Penalty
    if current_RH < env.RH_min
        env_penalty = 0; 
    else
        temp_penalty = max(0, 1 - abs(current_T - env.T_opt)/15);
        env_penalty = temp_penalty; 
    end
    
    % Nutrient Availability
    nutrient_availability = N / (env.K_s + N);
    
    % Effective Growth Rate
    r_effective = r_max * env_penalty * nutrient_availability;
    
    % ODEs
    dBdt = r_effective * B * (1 - B/env.K);
    
    nutrient_addition = env.nutrient_rate * is_playing;
    nutrient_consumption = 0.1 * dBdt; 
    dNdt = nutrient_addition - nutrient_consumption;
    
    if N <= 0 && dNdt < 0
        dNdt = 0;
    end
    
    dydt = [dBdt; dNdt];
end
