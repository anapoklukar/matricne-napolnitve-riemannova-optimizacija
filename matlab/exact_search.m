function [xt,ft, succ,numf,iarm, t] = exact_search(sys, xc,fc,gc,tl,tr)

% Natančno iskanje po premici na intervalu s funkcijo fminbnd.

% xc, trenutna točka
% fc = F(sys,xc), vrednost funkcije F v trenutni točki xc
% gc je iskalna smer
%
% vrne: xt, ft: lokalna minimumska točka in vrednost F(sys,xt)
%        succ = true, če je uspešno
%        numf: število evalvacij F
%        iarm: število Armijovih korakov nazaj

opts.MaxIter = 100; % Največje število iteracij za iskanje
opts.TolX = 1e-10; % Toleranca za iskanje (natančnost)

% Komentarirane vrstice za prilagoditev intervala iskanja in vizualizacijo funkcije
% tr = tr*1e5;
% ts = linspace(0,tr,500); % Generiranje 500 točk v intervalu [0, tr]
% fs = fun(sys,ts,xc,gc); % Evalvacija funkcije v teh točkah
% semilogy(ts,fs,'.') % Prikaz funkcije v logaritemski skali
% pause

    function ft = fun(lambda)
        % Notranja funkcija, ki izračuna vrednost funkcije F na premici
        xt = moveEIG(sys,xc,gc,lambda); % Premik v smeri gc z dolžino lambda
        ft = F(sys,xt); % Evalvacija funkcije F na novi točki xt
    end

% Klic funkcije fminbnd za iskanje minimuma na intervalu [tl, tr] z uporabo zgornje funkcije fun
[t,ft,flag,output] = fminbnd(@fun,tl,tr,opts);

% Premik na končno točko xt v smeri t, ki ustreza minimumu
xt = moveEIG(sys,xc,gc,t);

% Preverjanje, če je iskanje uspešno
if flag == 1
    succ = true;
else
    succ = false;
end

% Pridobitev števila evalvacij funkcije F in števila iteracij Armijove metode
numf = output.funcCount;
iarm = output.iterations;

end
