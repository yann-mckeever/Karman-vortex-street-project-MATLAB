clear; close all; clc;
Nx=400;

Ny=100;

my=(Ny/2 + 3);

mx=(Nx/5 + 1);

[X,Y]=meshgrid([1:Nx],[1:Ny]);

ex=[0;1;0;-1;0;1;-1;-1;1];

ey=[0;0;1;0;-1;1;1;-1;-1];

umax = 0.1;

rho = ones(Ny, Nx); % Initialisation à 1

uy = zeros(Ny, Nx);

ux = 4 * umax * ((Y - 1.5*ones(Ny, Nx)) .* (Ny*ones(Ny, Nx) - 2*ones(Ny, Nx) - (Y - 1.5*ones(Ny,Nx)))) / ((Ny - 2)^2);

tmax = 5000; % Nombre total d0itérations

nu = 0.02; % Viscosité cinématique

tau = (3 * nu) + 0.5; % Temps de relaxation

w=[4/9 1/9 1/9 1/9 1/9 1/36 1/36 1/36 1/36];

F=equilibrium(rho, ux, uy, ex, ey, w);

rho0=calculrho(F);

[ux0,uy0]=calcul_u(F,ex,ey);


%{
%Plaque

bool=zeros(Ny,Nx);

bool(1,:)=1;

bool(Ny,:)=1;

bool(my-(Ny/5+2)/2 : my + ((Ny/5)+2)/2,mx)=1;

%Disque

R=Ny/10 + 1;

obstacle = ((X - mx).^2 + (Y - my).^2) <= R^2;

bool=zeros(Ny,Nx);

bool(1,:)=1;

bool(Ny,:)=1;

bool=bool + obstacle;

%Aile profilée

bool = false(Ny, Nx);

bool(1, :) = true;   

bool(Ny, :) = true;  

Ycentre = Y - my;    

c = Nx / 4;

t = sqrt((Ny/10 + 1) / (1.1019 * c));

% Définir la zone horizontale de l'aile

mask = (X >= (mx - c/2)) & (X <= (mx + c/2));

% Normaliser x dans l'intervalle [0,1] pour la zone de l'aile

x = (X(mask) - (mx - c/2)) / c;

% Initialiser la variable obstacle (tableau logique)

obstacle = false(Ny, Nx);

% Calculer le profil de l'aile et définir l'obstacle dans la zone définie par mask

obstacle(mask) = abs(Ycentre(mask)) <= (t * c / 0.2) * ...

                  (0.2969 * sqrt(x) - 0.126 * x - 0.3516 * x.^2 + 0.2843 * x.^3 - 0.1015 * x.^4);

% Combiner l'obstacle avec le tableau booléen existant

bool = bool | obstacle;

%Triangle

bool = false(Ny, Nx);

bool(1, :) = true;   

bool(Ny, :) = true;

h=50;

droite1 = X<=(200+h/2);

droite2 = Y - 40 - 1/10*X <= 0;

droite3= Y - 60 + 1/10*X >= 0;

triangle=false(Ny,Nx);

triangle= droite1 & droite2 & droite3;

bool = bool | triangle;

%Camion de dessus

bool = false(Ny, Nx);

bool(1, :) = true;   

bool(Ny, :) = true;

bool(30:70,100:150)=true;

bool(30:70,165:300)=true;

%Voiture de profil

bool = false(Ny, Nx);

bool(1, :) = true;   

bool(Ny, :) = true;

bool(70:90,120:300)=true;

bool(50:90,165:270)=true;

R=10;

roue1 = ((X - 150).^2 + (Y - 90).^2) <= R^2;

roue2 = ((X - 250).^2 + (Y - 90).^2) <= R^2;

bool=roue1|roue2|bool;


%}







R=Ny/4 + 1;

obstacle = ((X - mx).^2 + (Y - my).^2) <= R^2;

bool=zeros(Ny,Nx);

bool(1,:)=1;

bool(Ny,:)=1;

bool=bool + obstacle;

figure('Position', [100, 100, 800, 600]);
video= VideoWriter('video_inutile.avi');
video.FrameRate=24;
open(video);

for t=1:tmax

    rho=calculrho(F);

    [ux,uy]=calcul_u(F,ex,ey);

    %Initialisation Macro en x=1

    uy(:,1) = zeros(Ny, 1);

    ux(:,1) = 4 * umax * ((Y(:,1) - 1.5*ones(Ny, 1)) .* (Ny*ones(Ny, 1) - 2*ones(Ny, 1) - (Y(:,1) - 1.5*ones(Ny,1)))) / ((Ny - 2)^2);

    rho(:,1)= (F(:,1,1)+F(:,1,3)+F(:,1,5)+2*(F(:,1,4)+F(:,1,7)+F(:,1,8)))./(1-ux(:,1));

    %Initialisation Macro en x=Nx

    rho(:,Nx)= ones(Ny,1);

    uy(:,Nx) = zeros(Ny, 1);

    ux(:,Nx) = -ones(Ny,1) + (F(:,Nx,1)+F(:,Nx,3)+F(:,Nx,5)+2*(F(:,Nx,2)+F(:,Nx,6)+F(:,Nx,9)))./rho(:,Nx);

    %Initialisation Micro en x=1

    F(:,1,2)=F(:,1,4)+(2/3)*rho(:,1).*ux(:,1);

    F(:,1,6)=F(:,1,8)+(F(:,1,5)-F(:,1,3))/2 + (1/2)*rho(:,1).*uy(:,1) + (1/6)*rho(:,1).*ux(:,1);

    F(:,1,9)=F(:,1,7)+(F(:,1,3)-F(:,1,5))/2 - (1/2)*rho(:,1).*uy(:,1) + (1/6)*rho(:,1).*ux(:,1);

    %Initialisation Micro en x=Nx

    F(:,Nx,4)=F(:,Nx,2) - (2/3)*rho(:,Nx).*ux(:,Nx);

    F(:,Nx,8)=F(:,Nx,6)+(F(:,Nx,3)-F(:,Nx,5))/2 - (1/2)*rho(:,Nx).*uy(:,Nx) - (1/6)*rho(:,Nx).*ux(:,Nx);

    F(:,Nx,7)=F(:,Nx,9)+(F(:,Nx,5)-F(:,Nx,3))/2 + (1/2)*rho(:,Nx).*uy(:,Nx) - (1/6)*rho(:,Nx).*ux(:,Nx);

   

    F=collision(F, rho,ux,uy,ex,ey,w,tau,bool);

    F=propagation(F,Ny,Nx,ex,ey);

    [ux,uy]=calcul_u(F,ex,ey);
    
    ux=(1-bool).*ux;
    uy=(1-bool).*uy;

    subplot(3,1,1);
    imagesc(sqrt((ux.^2+uy.^2)));
    colorbar;
    caxis([0 0.1]);
    title('Norme de la vitesse');
    axis ij; % Force l'orientation standard des axes
    drawnow;
    
    
    [startx,starty]=meshgrid(1,1:5:Ny);
    
    

    subplot(3,1,2);
    cla;
    streamline(X,Y,ux,uy,startx,starty);
    title('Lignes de courant de vitesse');
    axis ij; % Force l'orientation standard des axes
    drawnow;
    
    
    uy_new=uy;
    ux_new=ux;
    [duy_dx, duy_dy] = gradient(uy_new, 1, 1); 
    [dux_dx, dux_dy] = gradient(ux_new, 1, 1); 

    vor = abs(duy_dx - dux_dy);
    
    
    subplot(3,1,3);
    contourf(X,Y,vor,10)
    colorbar;
    caxis([0 0.02]);
    title('Vorticité (valeur absolue)');
    axis ij; % Force l'orientation standard des axes
    drawnow;

    frame=getframe(gcf);
    
    writeVideo(video, frame);
end     
close(video);
