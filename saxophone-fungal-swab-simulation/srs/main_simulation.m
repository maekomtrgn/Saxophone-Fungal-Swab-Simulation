% main_simulation.m
% Master script to run growth and swab simulations and plot results.

clear; clc; close all;

% 1. Load parameters
params = define_parameters();

% 2. Define time span for baseline growth
tspan = [params.t_start, params.t_end];

% 3. Simulate baseline growth (no swabbing)
[t, B] = ode45(@(t, B) growth_model(t, B, params.r, params.K), tspan, params.B0);

% 4. Plot baseline growth
figure;
plot(t, B, 'b-', 'LineWidth', 2);
xlabel(params.xlabel);
ylabel(params.ylabel);
title('Baseline Fungal Growth (No Swabbing)');
grid on;
saveas(gcf, '../results/baseline_growth.png');

% 5. Simulate swab scenarios (1 to 5 swabs)
% First, find the biomass at the swabbing time (t_swab = 7 days)
B_at_swab_time = interp1(t, B, params.t_swab);

figure;
hold on;
colors = lines(length(params.n_swabs));

for i = 1:length(params.n_swabs)
    n = params.n_swabs(i);
    
    % Calculate biomass immediately after swabbing
    B_after_swab = swab_model(B_at_swab_time, params.eta, n);
    
    % Create a time vector for the post-swab period
    t_post_swab = linspace(params.t_swab, params.t_end, 100);
    
    % Simulate regrowth starting from the post-swab biomass
    [t_regrow, B_regrow] = ode45(@(t, B) growth_model(t, B, params.r, params.K), ...
                                 [params.t_swab, params.t_end], B_after_swab);
    
    % Plot the regrowth curve for this scenario
    plot(t_regrow, B_regrow, 'Color', colors(i,:), 'LineWidth', 1.5, ...
         'DisplayName', sprintf('%d Swab(s)', n));
end

% 6. Format the swab comparison plot
xlabel(params.xlabel);
ylabel(params.ylabel);
title('Fungal Regrowth After Swabbing (at Day 7)');
legend('show');
grid on;
hold off;
saveas(gcf, '../results/swab_comparison.png');

disp('Simulation complete. Plots saved to the results/ folder.');