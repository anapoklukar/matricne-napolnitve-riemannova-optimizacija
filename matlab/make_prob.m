function prob = make_prob(L,R,Omega,k)
    % L*R' predstavlja točne podatke.
    % Omega je vzorčni nabor; redka matrika.
    % k je rang za rekonstrukcijo.
    
    prob.use_blas = true;
    
    % Velikost vhodnih matrik
    prob.n1 = size(L,1); 
    prob.n2 = size(R,1); 
    prob.r = k;
    
    % Preveri, ali je rang znotraj dovoljene vrednosti
    if prob.r > min(prob.n1, prob.n2)
        error('Rang mora biti celo število med 1 in številom stolpcev/vrstic.')
    end
    
    % Nastavi vzorčni nabor in njegove indekse
    prob.Omega = Omega;
    [prob.Omega_i, prob.Omega_j] = ind2sub([prob.n1,prob.n2], Omega);
    prob.m = length(Omega);
    
    % Ekstrahiranje podatkov za dano množico indeksa Omega
    prob.data = partXY(L', R',prob.Omega_i, prob.Omega_j,prob.m)'; 
    
    % Ustvari začasno redko matriko za rekonstrukcijo
    prob.temp_omega = sparse(prob.Omega_i, prob.Omega_j, ...
        prob.data*1,prob.n1,prob.n2,prob.m);
      
    % Regularizacijski parameter (če ga potrebujemo)
    %prob.mu = 1e-14;
    prob.mu = 0;
    