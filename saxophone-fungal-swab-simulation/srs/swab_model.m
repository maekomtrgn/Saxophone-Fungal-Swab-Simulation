% swab_model.m
function B_after = swab_model(B_before, eta, n_swabs)
    % Applies n_swabs, each removing a fraction 'eta' of the biomass.
    % Formula: B_after = B_before * (1 - eta)^n_swabs
    B_after = B_before * (1 - eta)^n_swabs;
end
