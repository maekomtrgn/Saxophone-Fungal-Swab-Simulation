% growth_model.m
% Defines the logistic growth ODE: dB/dt = r * B * (1 - B/K)

function dBdt = growth_model(t, B, r, K)
    dBdt = r * B * (1 - B/K);
end