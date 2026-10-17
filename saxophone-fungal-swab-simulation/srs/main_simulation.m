% main_simulation.m
clear; clc; close all;

% 1. Load parameters
params = define_parameters();

% 2. Setup Time Vector (Hourly resolution for smooth plots)
t = linspace(0, params.days_total, params.hours_total);
initial_conditions = [params.B0; params.N0];

% 3. Simulate Baseline Growth (NO swabbing)
[t_base, y_base] = ode45(@(t,y) growth_model(t, y, params), t, initial_conditions);
B_baseline = y_base(:,1);

% 4. Simulate WITH Daily Swabbing
% We run the simulation hour-by-hour to apply the swab at the end of each day
B_swabbed = zeros(size(t));
B_swabbed(1) = params.B0;
y_current = initial_conditions;

for i = 1:length(t)-1
    % Integrate from current hour to next hour
    [~, y_next] = ode45(@(t,y) growth_model(t, y, params), [t(i), t(i+1)], y_current);
    y_current = y_next(end,:)';
    
    % Apply Swab at the end of the day (midnight)
    % t(i+1) will be a whole number when a day is completed
    if mod(t(i+1), 1) == 0 && t(i+1) > 0
        y_current(1) = swab_model(y_current(1), params.eta, 1); % 1 swab per day
    end
    
    B_swabbed(i+1) = y_current(1);
end

% 5. Plotting (Log Scale with Thresholds)
figure('Position', [100, 100, 900, 600]);
semilogy(t, B_baseline, 'r-', 'LineWidth', 2, 'DisplayName', 'No Cleaning'); 
hold on;
semilogy(t, B_swabbed, 'b-', 'LineWidth', 1.5, 'DisplayName', 'Daily Standard Swab (30%)');

% Add Threshold Lines
yline(params.thresh_hygiene, 'k--', 'Hygiene Failure (10 CFU/cm²)', 'LineWidth', 1.5, 'DisplayName', 'Hygiene Threshold');
yline(params.thresh_danger, 'k:', 'Active Contamination (1000 CFU/cm²)', 'LineWidth', 1.5, 'DisplayName', 'Danger Threshold');

% Formatting
xlabel('Time (Days)', 'FontSize', 12);
ylabel('Fungal Load (CFU/cm²)', 'FontSize', 12);
title('Saxophone Fungal Growth: 6-Month Simulation', 'FontSize', 14);
legend('Location', 'northwest', 'FontSize', 11);
grid on;
set(gca, 'FontSize', 11);

% Save the figure
if ~exist('../results', 'dir')
    mkdir('../results');
end
saveas(gcf, '../results/saxophone_simulation_realistic.png');
disp('Simulation complete. Graph saved to the results folder.');
title('Fungal Regrowth After Swabbing (at Day 7)');
legend('show');
grid on;
hold off;
saveas(gcf, '../results/swab_comparison.png');

disp('Simulation complete. Plots saved to the results/ folder.');
