% swab_model.m
% Applies a number of swabs to the current biomass.

function B_after = swab_model(B_before, eta, n_swabs)
    % Applies n_swabs, each removing a fraction 'eta' of the biomass.
    B_after = B_before * (1 - eta)^n_swabs;
end