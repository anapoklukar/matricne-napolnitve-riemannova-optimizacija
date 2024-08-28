function x = make_start_x(prob, sparse_svd)
% MAKE_START_X    Izračuna trunciran SVD za začetno ugibanje.
%
% Input:
%   prob        = instanca problema z informacijami o podatkih in dimenzijah.
%   sparse_svd  = logična vrednost, ki določa, ali naj se uporabi redčen SVD.
%
% Output:
%   x           = struktura, ki vsebuje začetno rešitev z U, S in V.

% Če ni bil podan parameter sparse_svd, ga nastavimo na true
if nargin==1
    sparse_svd = true;
end

% Ustvari redčeno matriko M_omega iz podatkov
M_omega = sparse(prob.Omega_i, prob.Omega_j, ...
    prob.data, prob.n1, prob.n2, prob.m);

% Preveri, ali uporabljamo redčen SVD
if sparse_svd
    opts.tol = 1e-5;  % Nastavi toleranco za redčen SVD
    % Izračunaj redčen SVD
    [U, S, V] = svds(M_omega, prob.r, 'L', opts);
else
    % Izračunaj poln SVD
    [U, S, V] = svd(full(M_omega));
    % Zadrži samo prvih prob.r singularnih vrednosti in ustrezne vektorje
    U = U(:,1:prob.r);
    S = S(1:prob.r,1:prob.r);
    V = V(:,1:prob.r);
end

% Shranjevanje rezultatov SVD v strukturo x
x.V = V;              % Vektorji desne singularne vrednosti
x.sigma = diag(S);   % Singularne vrednosti
x.U = U;              % Vektorji leve singularne vrednosti

% Pripravi strukturo x za nadaljnjo uporabo
x = prepx(prob, x);
