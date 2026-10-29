% gas_simulation.m
clear; clc; close all;

% --- 1. Define Time Vector ---
days = 0:0.1:30; % Simulate the first 30 days

% --- 2. Simulate Biomass Growth (Logistic) ---
% We use a simplified logistic curve to represent the total fungal mass
r = 0.4; % Growth rate
K = 10;  % Carrying capacity for early phase
B0 = 0.1; % Initial spores
biomass = K ./ (1 + ((K - B0) / B0) * exp(-r * days));

% --- 3. Simulate the Early Burst (The MVOC Spike) ---
% Gases peak during the rapid growth phase (Days 3-7)
% We use a Gaussian pulse to represent the burst of metabolic activity
peak_day = 4.5;
peak_width = 2.0;
pulse = exp(-((days - peak_day).^2) / (2 * peak_width^2));

% Add a small "tail" (baseline maintenance emission) that continues
tail_emission = 0.05 * ones(size(days));
gas_burst = pulse + tail_emission;

% --- 4. OPTION A: Multi-Gas Profile (Relative Units) ---
% We assume the total biomass produces a mixture of these gases.
% Weights are based on general MVOC literature for Penicillium/Phoma.
gas_weights = [0.6, 0.2, 0.8]; 
gas_names = {'Ethanol (Alcohol)', 'Ethyl Acetate (Ester)', 'CO2'};

% Calculate relative concentration for each gas: (Biomass * Burst * Weight)
gas_concentrations = zeros(length(days), 3);
for i = 1:3
    % Normalize biomass to a 0-1 scale for the gas multiplication
    norm_biomass = biomass / max(biomass); 
    gas_concentrations(:, i) = gas_weights(i) * gas_burst' .* norm_biomass';
end

% --- 5. OPTION B: Specific Marker Compound (1-Octen-3-ol) ---
% 1-Octen-3-ol is produced specifically during active hyphal growth.
norm_biomass = biomass / max(biomass);
marker_concentration = 0.4 * gas_burst' .* norm_biomass'; 

% ==========================================
% PLOTTING
% ==========================================

% --- Figure 1: Option A (The Mixture) ---
figure('Position', [100, 100, 900, 500]);
plot(days, gas_concentrations(:, 1), 'b-', 'LineWidth', 2); hold on;
plot(days, gas_concentrations(:, 2), 'g-', 'LineWidth', 2);
plot(days, gas_concentrations(:, 3), 'r-', 'LineWidth', 2);

% Formatting
xlabel('Time (Days)', 'FontSize', 12);
ylabel('Relative Emission Units (REU)', 'FontSize', 12);
title('Option A: Early Gas Mixture Profile (First 30 Days)', 'FontSize', 14);
legend(gas_names, 'Location', 'northeast');
grid on;
set(gca, 'FontSize', 11);

% Highlight the "Early Warning Window" (Days 3-7)
xregion = [3 7];
ylimits = ylim;
patch([xregion(1) xregion(2) xregion(2) xregion(1)], ...
      [ylimits(1) ylimits(1) ylimits(2) ylimits(2)], ...
      'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
% Moved the text to the right so it doesn't overlap the lines
text(10, ylimits(2)*0.85, 'Early Warning Window', ...
     'HorizontalAlignment', 'left', 'FontSize', 10, 'Color', [0.3 0.3 0.3]);

saveas(gcf, '../results/gas_mixture_profile.png');

% --- Figure 2: Option B (The Specific Marker) ---
figure('Position', [100, 100, 900, 500]);
plot(days, marker_concentration, 'm-', 'LineWidth', 2.5); hold on;

% Formatting
xlabel('Time (Days)', 'FontSize', 12);
ylabel('Relative Emission Units (REU)', 'FontSize', 12);
title('Option B: Specific Marker Profile (1-Octen-3-ol)', 'FontSize', 14);
legend('1-Octen-3-ol (Mushroom Alcohol)', 'Location', 'northeast');
grid on;
set(gca, 'FontSize', 11);

% Highlight the "Early Warning Window" (Days 3-7)
ylimits = ylim;
patch([xregion(1) xregion(2) xregion(2) xregion(1)], ...
      [ylimits(1) ylimits(1) ylimits(2) ylimits(2)], ...
      'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
text(10, ylimits(2)*0.85, 'Early Warning Window', ...
     'HorizontalAlignment', 'left', 'FontSize', 10, 'Color', [0.3 0.3 0.3]);

saveas(gcf, '../results/gas_marker_profile.png');

disp('Gas simulation complete. Two figures saved to results folder.');

% --- 4. OPTION B: Specific Marker Compound (1-Octen-3-ol) ---
% 1-Octen-3-ol is a well-documented fungal marker.
% It is produced specifically during active hyphal growth.
marker_concentration = 0.4 * gas_burst'; 

% ==========================================
% PLOTTING
% ==========================================

% --- Figure 1: Option A (The Mixture) ---
figure('Position', [100, 100, 900, 500]);
plot(days, gas_concentrations(:, 1), 'b-', 'LineWidth', 2); hold on;
plot(days, gas_concentrations(:, 2), 'g-', 'LineWidth', 2);
plot(days, gas_concentrations(:, 3), 'r-', 'LineWidth', 2);

% Formatting
xlabel('Time (Days)', 'FontSize', 12);
ylabel('Relative Emission Units (REU)', 'FontSize', 12);
title('Option A: Early Gas Mixture Profile (First 30 Days)', 'FontSize', 14);
legend(gas_names, 'Location', 'northeast');
grid on;
set(gca, 'FontSize', 11);

% Highlight the "Early Warning Window" (Days 3-7)
xregion = [3 7];
ylimits = ylim;
patch([xregion(1) xregion(2) xregion(2) xregion(1)], ...
      [ylimits(1) ylimits(1) ylimits(2) ylimits(2)], ...
      'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
text(5, max(gas_concentrations(:,3))*0.5, 'Early Warning Window', ...
     'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', [0.3 0.3 0.3]);

saveas(gcf, '../results/gas_mixture_profile.png');

% --- Figure 2: Option B (The Specific Marker) ---
figure('Position', [100, 100, 900, 500]);
plot(days, marker_concentration, 'm-', 'LineWidth', 2.5); hold on;

% Formatting
xlabel('Time (Days)', 'FontSize', 12);
ylabel('Relative Emission Units (REU)', 'FontSize', 12);
title('Option B: Specific Marker Profile (1-Octen-3-ol)', 'FontSize', 14);
legend('1-Octen-3-ol (Mushroom Alcohol)', 'Location', 'northeast');
grid on;
set(gca, 'FontSize', 11);

% Highlight the "Early Warning Window" (Days 3-7)
ylimits = ylim;
patch([xregion(1) xregion(2) xregion(2) xregion(1)], ...
      [ylimits(1) ylimits(1) ylimits(2) ylimits(2)], ...
      'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none', 'HandleVisibility', 'off');
text(5, max(marker_concentration)*0.5, 'Early Warning Window', ...
     'HorizontalAlignment', 'center', 'FontSize', 10, 'Color', [0.3 0.3 0.3]);

saveas(gcf, '../results/gas_marker_profile.png');

disp('Gas simulation complete. Two figures saved to results folder.');