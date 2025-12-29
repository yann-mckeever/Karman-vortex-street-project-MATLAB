function [ux, uy] = calcul_u(F, ex, ey)

    rho = calculrho(F);

    ux = sum(F.* reshape(ex, 1, 1, []), 3) ./ rho;

    uy = sum(F .* reshape(ey, 1, 1, []), 3) ./ rho;

end