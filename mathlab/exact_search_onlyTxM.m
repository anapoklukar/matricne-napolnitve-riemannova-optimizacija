function tmin = exact_search_onlyTxM(prob, x, smer)
% Natančno iskanje po smeri

e_omega = x.err; % Napaka v trenutni rešitvi x

% Izračunamo projekcijo iskalne smeri na matriko napake (omega)
%dir_omega = XonOmega([x.U*smer.M+smer.Up x.U], [x.V smer.Vp], prob.Omega);

% Preverimo, če je 2*r večji ali enak od najmanjše dimenzije matrike
if 2*prob.r >= min(prob.n1, prob.n2)
    % Uporabimo delno množenje matrik za izračun iskalne smeri na napaki (omega)
    dir_omega = partXY(smer.M'*x.U'+smer.Up',x.V', prob.Omega_i, prob.Omega_j, prob.m) + ...
        partXY(x.U',smer.Vp', prob.Omega_i, prob.Omega_j, prob.m); 
else
    % Če je 2*r manjši od najmanjše dimenzije matrike, uporabimo drugo metodo za izračun
    dir_omega = partXY([x.U*smer.M+smer.Up x.U]',[x.V smer.Vp]', prob.Omega_i, prob.Omega_j, prob.m); 
end

% norm je f(t) = 0.5 * ||e + t * d||_F^2
% Izračun minimuma analitično
% Polinomski df/dt = a0 + t * a1
a0 = dir_omega * e_omega; % Izračunamo a0 kot produkt projekcije smeri in napake
a1 = dir_omega * dir_omega'; % Izračunamo a1 kot produkt projekcije smeri same s seboj
tmin = -a0 / a1; % Izračunamo optimalen korak tmin

% Alternativna metoda za izračun tmin (komentirano)
% A1 = dir_omega';
% b = e_omega;
% tmin = -A1\b;

end
