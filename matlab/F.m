function f = F(prob,x)
% F ciljna funkcija (cost function)

% Osnovni del funkcije: polovični kvadrat napake
f = 0.5 * (x.err' * x.err);

% Če je regularizacijski parameter mu večji od 0, dodamo še regularizacijski člen
if prob.mu > 0
    % Dodamo regularizacijo, ki temelji na inverznih singularnih vrednostih
    f = f + prob.mu * norm(1 ./ x.sigma)^2;
end
