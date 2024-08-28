function [x, histout, fail] = LRGeomCG(prob, opts, x0)
% LRGEOMCG    Nizko-rangovna dopolnitev matrike z geometrijskim CG.
%   Uporablja Armijo pravilo in polinomsko iskanje po vgrajeni podmanifoldi
%   matrik z fiksnim rangom.
%
% Input:
%   prob     = instanca problema.
%   opts     = možnosti.
%   x0       = začetna ugibanja.
%
% Output:
%   x        = rešitev.
%   histout  = zgodovina iteracij. Vsaka vrstica histout je:
%               [rel_norm(grad), rel_err_on_omega, relativna sprememba, ...
%                število znižanj dolžine koraka, ponovni zagon]
%   fail     = zastavica za napako

% Določitev vrste beta
beta_type = 'P-R';  % Polak-Ribiere+

% Inicializacija zastavice za napako
fail = true;

% Izračun norme podatkov iz problema
norm_M_Omega = norm(prob.data);

% Smernice iskanja naj bodo skoraj ortogonalne
ORTH_VALUE = 0.1;

% Inicializacija iteracijskega števca in začetne rešitve
itc = 1;
xc = x0;

% Izračun funkcijske vrednosti in gradienta pri začetni rešitvi
fc = F(prob, xc);
gc = grad(prob, xc);
ip_gc = ip(xc, gc, gc);

% Prvi iskalni smer je najstrmejši gradient
fold = 2 * fc;
reschg = -1;
dir = scaleTxM(gc, -1);
rel_grad = sqrt(ip_gc) / max(1, norm(xc.sigma));

% Inicializacija matrike za zgodovino iteracij
ithist = zeros(opts.maxit, 4);
beta = 0;
k = length(xc.sigma);

% Glavna zanka za iteracije
for itc = 1:opts.maxit
    disp(['Iteracija: ', num2str(itc)]);  % Izpis trenutne iteracije

    % Inicialna dolžina koraka
    tinit = exact_search_onlyTxM(prob, xc, dir);

    % Armijo iskanje
    fc_b = fc;
    [xc_new, fc, succ, ~, iarm] = armijo_search(prob, xc, fc, gc, dir, tinit);

    % Preverjanje uspešnosti iskanja dolžine koraka
    if ~succ && beta ~= 0
        disp('Iskanje dolžine koraka je spodletelo pri CG. Ponastavitev na gradient.');
        beta = 0;
        dir = scaleTxM(gc, -1);
        tinit(itc) = exact_search_onlyTxM(prob, xc, dir);
        [xc_new, fc, succ, ~, iarm] = armijo_search(prob, xc, fc_b, gc, dir, tinit);
    end

    % Preverjanje uspešnosti iskanja po ponovni nastavitvi na najstrmejši gradient
    if ~succ
        x = xc_new;
        ithist(itc, 1) = rel_grad;
        ithist(itc, 2) = sqrt(2 * fc) / norm_M_Omega;
        ithist(itc, 3) = reschg;
        ithist(itc, 4) = iarm;
        histout = ithist(1:itc, :);
        disp('Iskanje dolžine koraka je spodletelo pri najstrmejšem gradientu. Izstopanje...');
        return;
    end

    % Izračun gradienta pri novi rešitvi
    gc_new = grad(prob, xc_new);
    ip_gc_new = ip(xc_new, gc_new, gc_new);

    % Testiranje za konvergenco
    if sqrt(2 * fc) < opts.abs_f_tol
        disp('Dosežena absolutna toleranca za f.');
        fail = false;
        break;
    end
    if sqrt(2 * fc) / norm_M_Omega < opts.rel_f_tol
        disp('Dosežena relativna toleranca za f.');
        fail = false;
        break;
    end
    if sqrt(ip_gc_new) / max(1, norm(xc_new.sigma)) < opts.rel_grad_tol
        disp('Dosežena relativna toleranca za gradient.');
        fail = false;
        break;
    end

    % Preverjanje 'kriterija stagnacije' po 10 iteracijah
    reschg = abs(1 - sqrt(2 * fc) / sqrt(2 * fold));
    if itc > 10 && reschg < opts.rel_tol_change_res
        disp('Stagnacija iteracije za rel_tol_change_res.');
        fail = true;
        break;
    end

    % Preverjanje stagnacije
    if opts.stagnation_detection && itc > 10
        R1 = qr([xc_new.U * diag(xc_new.sigma), xc.U * diag(xc.sigma)], 0);
        R1 = triu(R1(1:k, :));
        R2 = qr([xc_new.V, -xc.V], 0);
        R2 = triu(R2(1:k, :));

        % Izračun relativne spremembe
        rel_change_x = norm(R1 * R2', 'fro') / norm(xc_new.sigma, 2);

        if rel_change_x < opts.rel_tol_change_x
            disp('Stagnacija iteracije za rel_tol_change_x.');
            fail = true;
            break;
        end
    end

    % Nova smer = -gradient(nova x) + beta * vektorTransp(stari x, stara smer, tmin*stara smer)
    gc_old = transpVect(prob, xc, gc, xc_new, 1);
    dir = transpVect(prob, xc, dir, xc_new, 1);

    % Preverjanje ortogonalnosti prejšnjega gradienta s trenutnim gradientom
    ip_gc_old_new = ip(xc_new, gc_old, gc_new);
    orth_grads = ip_gc_old_new / ip_gc_new;

    if abs(orth_grads) >= ORTH_VALUE
        disp('Nov gradient je skoraj ortogonalno na trenutni gradient. To je dobro, zato lahko ponastavimo na najstrmejši gradient.');
        beta = 0;
        dir = plusTxM(gc_new, dir, -1, beta);
    else
        % Izračun CG popravka
        if strcmp(beta_type, 'P-R')
            beta = (ip_gc_new - ip_gc_old_new) / ip_gc;
            beta = max(0, beta);
            dir = plusTxM(gc_new, dir, -1, beta);
        end
    end

    % Preverjanje, ali je smer padajoča, sicer vzemi -gradient (tj. beta=0)
    g0 = ip(xc_new, gc_new, dir);
    if g0 >= 0
        disp('Nova smer iskanja ni smer padajoča. Ponastavitev na -grad.');
        dir = scaleTxM(gc_new, -1);
        beta = 0;
    end

    % Posodobitev _new na trenutno
    gc = gc_new;
    ip_gc = ip_gc_new;
    xc = xc_new;
    fold = fc;

    % Shranjevanje vrednosti v zgodovino iteracij
    ithist(itc, 1) = rel_grad;
    ithist(itc, 2) = sqrt(2 * fc) / norm_M_Omega;
    ithist(itc, 3) = reschg;
    ithist(itc, 4) = iarm;
end

% Nastavitev končne rešitve na novo rešitev
x = xc_new;
ithist(itc, 1) = rel_grad;
ithist(itc, 2) = sqrt(2 * fc) / norm_M_Omega;
ithist(itc, 3) = reschg;
ithist(itc, 4) = iarm;
histout = ithist(1:itc, :);  % Zgodovina iteracij
