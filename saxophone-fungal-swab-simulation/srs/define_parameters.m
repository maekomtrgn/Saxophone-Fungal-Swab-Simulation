% define_parameters.m
% Stores all constants and parameters for the simulation.

function params = define_parameters()
    % --- Fungal Growth Constants ---
    params.r = 0.35;          % Intrinsic growth rate (derived from radial growth)
    params.K = 100;           % Carrying capacity (arbitrary units for max biomass)
    params.B0 = 0.1;          % Initial biomass (e.g., from a single spore)

    % --- Swab Efficacy Constants ---
    params.eta = 0.60;        % Swab efficacy (60% removal per swab)
    params.n_swabs = 1:5;     % Number of swabs to simulate (1 to 5)

    % --- Simulation Time Settings ---
    params.t_start = 0;       % Start time (days)
    params.t_end = 30;        % End time (days)
    params.t_swab = 7;        % Time (days) when swabbing occurs
    
    % --- Plotting Settings ---
    params.plot_title = 'Fungal Biomass in Saxophone Bore';
    params.xlabel = 'Time (days)';
    params.ylabel = 'Fungal Biomass (a.u.)';
end