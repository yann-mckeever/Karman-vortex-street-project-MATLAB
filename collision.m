function Fout = collision(F, rho, ux, uy, ex, ey, w, tau,bool)

    feq = equilibrium(rho, ux, uy, ex, ey, w);

    for i=1:9

    if i==1

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,1));

    elseif i==2

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,4));

    elseif i==3

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,5));

    elseif i==4

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,2));

    elseif i==5

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,3));

    elseif i==6

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,8));

    elseif i==7

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,9));

    elseif i==8

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,6));

    else

        Fout(:,:,i) = (1-bool).*( F(:,:,i) - (F(:,:,i) - feq(:,:,i)) / tau )  +  bool.*(F(:,:,7));

    end

    end

end