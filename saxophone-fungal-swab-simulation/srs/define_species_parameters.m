function species_list = define_species_parameters()
    % Define the shared environment (Humid Case, High Nutrients)
    env.T_opt = 25;           
    env.RH_min = 70;          
    env.K = 1000;             % Carrying capacity (CFU/cm²)
    env.B0 = 10;              % Starting load (CFU/cm²)
    env.N0 = 1.0;             
    env.nutrient_rate = 0.15; % High nutrient rate
    env.K_s = 0.5;            
    env.eta = 0.30;           % Standard swab removes 30%
    env.days_total = 180;
    env.hours_total = env.days_total * 6; % 4-hour resolution to prevent freezing
    
    % Define the species
    species_list = struct();
    
    % 1. Phialophora
    species_list(1).name = 'Phialophora';
    species_list(1).r_max = 0.038; 
    species_list(1).env = env;
    
    % 2. Penicillium (Fast grower, wide temp range)
    species_list(2).name = 'Penicillium';
    species_list(2).r_max = 0.060; 
    species_list(2).env = env;
    
    % 3. Phoma (Dominant on wind instruments)
    species_list(3).name = 'Phoma';
    species_list(3).r_max = 0.050;
    species_list(3).env = env;
    
    % 4. Rhodotorula (Yeast, optimal 20-30C)
    species_list(4).name = 'Rhodotorula';
    species_list(4).r_max = 0.045;
    species_list(4).env = env;
    
    % 5. Alternaria (Allergen, optimal 25-30C)
    species_list(5).name = 'Alternaria';
    species_list(5).r_max = 0.035;
    species_list(5).env = env;
    
    % 6. Curvularia (Plant pathogen, needs high humidity)
    species_list(6).name = 'Curvularia';
    species_list(6).r_max = 0.040;
    species_list(6).env = env;
    
    % 7. Exophiala (Black yeast, tolerates high heat)
    species_list(7).name = 'Exophiala';
    species_list(7).r_max = 0.030;
    species_list(7).env = env;
end