function feq = equilibrium(rho, ux, uy, ex, ey, w)

    [Ny, Nx] = size(rho);

    feq = zeros(Ny, Nx, 9);

    u_sq = ux.^2 + uy.^2;

    for i = 1:9

        % Produit scalaire e_i . u = ex(i)*ux + ey(i)*uy

        e_dot_u = ex(i) * ux + ey(i) * uy;

        feq(:,:,i) = w(i) * rho .* ( 1 + 3*e_dot_u + (9/2)*(e_dot_u.^2) - (3/2)*u_sq );

    end

end