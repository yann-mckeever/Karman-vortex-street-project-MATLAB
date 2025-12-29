function Fprop = propagation(F,N_y,N_x, ex, ey)
f_etoile=zeros(N_y,N_x,9);


f_etoile(:,:,1)=F(:,:,1);

f_etoile(:,2:N_x,2)=F(:,1:N_x-1,2);
f_etoile(:,1,2)=F(:,N_x,2);


f_etoile(1:N_y-1,:,3)=F(2:N_y,:,3);
f_etoile(N_y,:,3)=F(1,:,3);


f_etoile(:,1:N_x-1,4)=F(:,2:N_x,4);
f_etoile(:,N_x,4)=F(:,1,4);


f_etoile(2:N_y,:,5)=F(1:N_y-1,:,5);
f_etoile(1,:,5)=F(N_y,:,5);




f_etoile(1:N_y-1,2:N_x,6)=F(2:N_y,1:N_x-1,6);
f_etoile(N_y,2:N_x,6)=F(1,1:N_x-1,6);
f_etoile(1:N_y-1,1,6)=F(2:N_y,N_x,6);
f_etoile(N_y,1,6)=F(1,N_x,6);





f_etoile(1:N_y-1,1:N_x-1,7)=F(2:N_y,2:N_x,7);
f_etoile(N_y,1:N_x-1,7)=F(1,2:N_x,7);
f_etoile(1:N_y-1,N_x,7)=F(2:N_y,1,7);
f_etoile(N_y,N_x,7)=F(1,1,7);





f_etoile(2:N_y,1:N_x-1,8)=F(1:N_y-1,2:N_x,8);
f_etoile(1,1:N_x-1,8)=F(N_y,2:N_x,8);
f_etoile(2:N_y,N_x,8)=F(1:N_y-1,1,8);
f_etoile(1,N_x,8)=F(N_y,1,8);





f_etoile(2:N_y,2:N_x,9)=F(1:N_y-1,1:N_x-1,9);
f_etoile(1,2:N_x,9)=F(N_y,1:N_x-1,9);
f_etoile(2:N_y,1,9)=F(1:N_y-1,N_x,9);
f_etoile(1,1,9)=F(N_y,N_x,9);











    [Ny, Nx, nDir] = size(F);

    Fprop = zeros(Ny, Nx, nDir);

    for i = 1:nDir;

        % Ainsi, pour décaler de ex(i) en x et ey(i) en y, on utilise :

        %   circshift(A, [shift_lignes, shift_colonnes])

        Fprop(:,:,i) = circshift(F(:,:,i), [ey(i), ex(i)]);

    end

end