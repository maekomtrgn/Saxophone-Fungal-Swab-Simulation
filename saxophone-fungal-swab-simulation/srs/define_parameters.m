function params = define_parameters()
    % --- Realistic Saxophone Constants ---
    params.r_max = 0.038;     % Maximum growth rate (cm/day equivalent)
    params.K = 1000;          % Carrying capacity (CFU/cm²)
    params.B0 = 10;           % Initial biomass (CFU/cm²) - detection limit
    params.eta = 0.30;        % Standard swab efficacy (30% removal per pass)
    
    % --- Thresholds ---
    params.thresh_hygiene = 10;    % CFU/cm² (Hygiene failure / Detection limit)
    params.thresh_danger = 1000;   % CFU/cm² (Active contamination)

    % --- Dynamic Environment (Time) ---
    params.days_total = 180;       % Simulate for 6 months
    params.hours_total = params.days_total * 24;
    
    % --- Nutrient Parameters (Saliva) ---
    params.N0 = 1.0;          % Initial nutrient level
    params.nutrient_rate = 0.05; % Nutrient added per hour of playing
    params.K_s = 0.5;         % Half-saturation constant for Monod growth
    
    % --- Fungal Environmental Tolerances ---
    params.T_opt = 25;        % Optimal temp (C)
    params.RH_min = 70;       % Minimum RH for growth (%)
end
