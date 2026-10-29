% main_simulation.m
clear; clc; close all;

% 1. Load the database of 7 fungi
species_list = define_species_parameters();
num_species = length(species_list);

% Setup figure
figure('Position', [100, 100, 1000, 700]);
colors = lines(num_species); 
hold on;

legend_entries = cell(1, num_species);

% 2. Loop through each fungus
for i = 1:num_species
    env = species_list(i).env;

    % Run for 365 days
    env.days_total = 365; 
    t = linspace(0, env.days_total, env.days_total * 4); 
    initial_conditions = [env.B0; env.N0];

    % Define the specific ODE for this fungus
    ode_fun = @(t, y) growth_model(t, y, species_list(i).r_max, env);

    % Run Simulation WITH Daily Swabbing
    B_swabbed = zeros(size(t));
    B_swabbed(1) = env.B0;
    y_current = initial_conditions;

    for j = 1:length(t)-1
        [~, y_next] = ode45(ode_fun, [t(j), t(j+1)], y_current);
        y_current = y_next(end,:)';

        % Swab at the end of each day
        if mod(t(j+1), 1) == 0 && t(j+1) > 0
            y_current(1) = y_current(1) * (1 - env.eta); 
        end

        B_swabbed(j+1) = y_current(1);
    end

    % Plot this species
    plot(t, B_swabbed, 'Color', colors(i,:), 'LineWidth', 2);
    legend_entries{i} = species_list(i).name;
end

% 3. FORCE TRUE LOG SCALE
set(gca, 'YScale', 'log');
ylim([8 1000]); % Set limits so we can see the 10 and 1000 lines

% Add Threshold Lines
yline(10, 'k--', 'Hygiene Failure (10 CFU/cm²)', 'LineWidth', 1.5, 'HandleVisibility', 'off');
yline(1000, 'k:', 'Danger Threshold (1000 CFU/cm²)', 'LineWidth', 1.5, 'HandleVisibility', 'off');

xlabel('Time (Days)', 'FontSize', 12);
ylabel('Fungal Load (CFU/cm²) - Log Scale', 'FontSize', 12);
title('Parallel Simulation: 7 Saxophone Fungi (1 Year, Daily Swabbing)', 'FontSize', 14);
legend(legend_entries, 'Location', 'northwest');
grid on;
set(gca, 'FontSize', 11);

% Save the figure
if ~exist('../results', 'dir')
    mkdir('../results');
end
saveas(gcf, '../results/parallel_species_comparison_line.png');
disp('True log line graph complete. Graph saved to results folder.');
