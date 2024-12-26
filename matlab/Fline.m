function f = Fline(prob,t,Y,H)
% FLINE Ciljna funkcija, F, vzdolž geodetke, ki poteka skozi Y
% v smeri H na razdalji t.
%
% f = FLINE(t,Y,H)
% Osnovna funkcija za uporabo s funkcijo fmin

f = zeros(size(t)); % Inicializacija vektorja rezultatov za različne vrednosti t
for i = 1:length(t) % Zanka čez vse vrednosti t
    % Izračun stroškovne funkcije F na točki, kamor se premaknemo po geodetki
    % iz Y v smeri H na razdalji t(i)
    f(i) = F(prob, moveEIG(prob, Y, H, t(i)));
end
    