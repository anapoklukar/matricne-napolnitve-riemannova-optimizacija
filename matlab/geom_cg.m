function [xc,histout,costdata,fail] = geom_cg(prob, opts, x0)
% Geometric cg descent z Armijo pravilom, polinomsko iskanje po liniji
%
% Vhod:
% x0 = začetna točka
% f = ciljna funkcija,
%      klic funkcije mora biti v obliki
%      [fout,gout]=f(x), kjer je fout=f(x) skalar
%      in gout = grad f(x) je STOLPČNI vektor
% tol = kriterij za zaustavitev, norm(grad) < tol
%       neobvezno, privzeta vrednost = 1.d-6
% maxit = maksimalno število iteracij (neobvezno), privzeta vrednost = 1000
%
% Izhod:
% x = rešitev
% histout = zgodovina iteracij
%           Vsaka vrstica histout je
%          [rel_norm(grad), rel_err_on_omega, rel_sprememba, ...
%           število zmanjšanj dolžine koraka, ponovni začetki]

t_begin = tic(); % Začnemo časovnik

TOL_RESCHG = 1e-8; % Toleranca za relativno spremembo

% Vrsta beta: Fletcher-Reeves (F-R) ali Polak-Ribiere (P-R)
beta_type = 'P-R';

fail = true; % Privzeto nastavimo neuspeh

norm_M_Omega = norm(prob.data); % Norma podatkov

ORTH_VALUE = 0.1; % Smer iskanja mora biti skoraj ortogonalna

itc = 1; xc = x0; % Nastavimo začetno točko
fc = F(prob,xc); % Ciljna funkcija na začetni točki
gc = grad(prob,xc); % Gradient na začetni točki
ip_gc = ip(xc,gc,gc); % Notranji produkt gradienta
fold = 2*fc; % Za shranjevanje prejšnje vrednosti ciljne funkcije

% Prva smer iskanja je najstrmejši gradient
dir = scaleTxM(gc,-1);

numf = 1; numg = 1; numh = 0; % Štetje funkcij, gradientov in hessijanov
ithist = zeros(opts.maxit,4); % Zgodovina iteracij

for itc=1:opts.maxit
    % Izračunamo začetni korak s polinomsko iskanjem
    tinit(itc) = exact_search_onR1(prob, xc, dir);

    % Uporabimo Armijo iskanje po liniji za izboljšanje rešitve
    fc_b = fc;
    [xc_new,fc,succ,numf_a,iarm,tinit(itc)] = armijo_search(prob, xc,fc,dir, tinit(itc));

    % Če iskanje ne uspe, ponastavimo na gradientni spust
    if ~succ && beta ~= 0
        if opts.verbosity > 0; warning('Iskanje po liniji ni uspelo. Ponastavitev na gradient.'); end
        beta = 0;
        dir = scaleTxM(gc,-1); % Najstrmejša smer
        tinit(itc) = exact_search_onR1(prob, xc, dir);
        [xc_new,fc,succ,numf_a,iarm,tinit(itc)] = armijo_search(prob, xc,fc_b,dir, tinit(itc));
    end

    % Če še vedno ne uspe, izstopimo
    if ~succ
        xc = xc_new;
        ithist(itc,1) = rel_grad;
        ithist(itc,2) = sqrt(2*fc)/norm_M_Omega;
        ithist(itc,3) = reschg;
        ithist(itc,4) = iarm;    
        histout = ithist(1:itc,:); 
        costdata = [numf, numg, numh];
        if opts.verbosity > 0; warning('Iskanje po liniji ni uspelo pri gradientnem spustu. Izhod...'); end
        return
    end

    % Gradient nove točke
    gc_new = grad(prob, xc_new);
    ip_gc_new = ip(xc_new, gc_new, gc_new);

    % Preverjanje zaustavitve (absolutno, relativno, gradientno...)
    if sqrt(2*fc) < opts.abs_f_tol
        if opts.verbosity > 0; disp('Dosežena absolutna f toleranca.'); end
        fail = false;
        break;
    end
    if sqrt(2*fc)/norm_M_Omega < opts.rel_f_tol
        if opts.verbosity > 0; disp('Dosežena relativna f toleranca.'); end
        fail = false;
        break;
    end
    
    rel_grad = sqrt(ip_gc)/max(1, norm(xc_new.sigma));
    if rel_grad < opts.rel_grad_tol
        if opts.verbosity > 0; disp('Dosežena relativna toleranca gradienta.'); end
        fail = false;
        break;
    end
    
    % Preverjanje stagnacije
    reschg = abs(1 - sqrt(2*fc)/sqrt(2*fold));
    if itc > 10 && reschg < opts.rel_tol_change_res
        if opts.verbosity > 0; disp('Iteracija stagnira.'); end
        fail = true;
        break;
    end

    % Posodobitev gradienta in smeri
    gc_old = transpVect(prob, xc, gc, xc_new, 1);  
    dir = transpVect(prob, xc, dir, xc_new, 1);

    % Preverjanje ortogonalnosti gradientov
    orth_grads = ip(xc_new, gc_old, gc_new) / ip_gc_new;
    if orth_grads >= ORTH_VALUE
        if opts.verbosity > 1; disp('Novi gradient je skoraj ortogonalen staremu. Resetiramo na najstrmejši spust.'); end
        beta = 0;
        dir = plusTxM(gc_new, dir, -1, beta);
    else
        % Izračun beta za CG metodo (Fletcher-Reeves ali Polak-Ribiere)
        if strcmp(beta_type, 'F-R')
            beta = ip_gc_new / ip_gc;
            dir = plusTxM(gc_new, dir, -1, beta);
        elseif strcmp(beta_type, 'P-R')
            diff = plusTxM(gc_new, gc_old, 1, -1);
            ip_diff = ip(xc_new, gc_new, diff);
            beta = ip_diff / ip_gc;
            beta = max(0, beta);
            dir = plusTxM(gc_new, dir, -1, beta);
        end
    end

    % Če smer ni smer spusta, ponastavimo na gradient
    g0 = ip(xc_new, gc_new, dir);
    if g0 >= 0
        if opts.verbosity > 1; disp('Smer iskanja ni smer spusta. Ponastavljamo na -grad.'); end
        dir = scaleTxM(gc_new, -1);
        beta = 0;
    end

    % Posodobimo stare vrednosti
    gc = gc_new;
    ip_gc = ip_gc_new;
    xc = xc_new;
    fold = fc;
    numg = numg + 1;

    ithist(itc, 1) = rel_grad;
    ithist(itc, 2) = sqrt(2*fc)/norm_M_Omega;
    ithist(itc, 3) = reschg;
    ithist(itc, 4) = iarm;
end

xc = xc_new;
ithist(itc, 1) = rel_grad;
ithist(itc, 2) = sqrt(2*fc)/norm_M_Omega;
ithist(itc, 3) = reschg;
ithist(itc, 4) = iarm; 
histout = ithist(1:itc,:); 
