% sensor_response_simulation.m
% Simulates a Metal Oxide Semiconductor (MOS) sensor response to fungal VOCs

clear; clc; close all;

% 1. Load the Gas Concentration Data (from your previous logic)
days = 0:0.1:30;
% (Insert the same biomass & gas burst logic here to get your 'marker_concentration')
% For this script, we will use a simplified version of the marker data:
peak_day = 4.5; peak_width = 2.0;
pulse = exp(-((days - peak_day).^2) / (2 * peak_width^2));
tail = 0.05 * ones(size(days));
marker_concentration = 0.4 * (pulse + tail)'; % This is your REU

% 2. MOS Sensor Physics Model
% Typical MOS sensor behavior: Resistance decreases as gas concentration increases
R0 = 10000; % Baseline resistance in clean air (10 kOhm)
% Empirical constants for the sensor's sensitivity to alcohols/VOCs
sensitivity_a = 0.8; % How much the resistance drops
sensitivity_b = 0.5; % Non-linearity factor

% Calculate the sensor resistance over time
% (Adding a small baseline to avoid division by zero)
R_sensor = R0 ./ (1 + sensitivity_a * (marker_concentration .^ sensitivity_b));

% 3. Convert Resistance to a Readable Voltage
% Standard voltage divider circuit: V_out = V_in * (R_sensor / (R_sensor + R_load))
V_in = 5.0; % 5V supply (like USB power)
R_load = 10000; % 10 kOhm load resistor
V_out = V_in * (R_sensor ./ (R_sensor + R_load));

% 4. Plot the "Sellable" Sensor Signal
figure('Position', [100, 100, 900, 500]);
plot(days, V_out, 'LineWidth', 3, 'Color', [0.8 0.2 0.2]); % Red line for sensor voltage
hold on;

% Add the Early Warning Window
xregion = [3 7];
ylimits = [min(V_out)*0.95, max(V_out)*1.05];
patch([xregion(1) xregion(2) xregion(2) xregion(1)], ...
      [ylimits(1) ylimits(1) ylimits(2) ylimits(2)], ...
      'k', 'FaceAlpha', 0.1, 'EdgeColor', 'none');
text(5, ylimits(2)*0.97, 'Early Warning Window', 'HorizontalAlignment', 'center');

% Formatting
xlabel('Time (Days)', 'FontSize', 12);
ylabel('Sensor Output Voltage (V)', 'FontSize', 12);
title('MOS Sensor Response to Fungal VOCs (Simulated)', 'FontSize', 14);
grid on;
ylim(ylimits);

% Save for your report
if ~exist('../results', 'dir'), mkdir('../results'); end
saveas(gcf, '../results/sensor_voltage_response.png');
disp('Sensor response simulation complete.');