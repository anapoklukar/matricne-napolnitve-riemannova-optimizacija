function [Omega, Omega_sparse] = make_rand_Omega(m,n,nb_samples)
  % Ustvari naključni vzorec s specificiranim številom vzorcev.
  % Izhod:
  %    * Omega kot vektor (vektorizirani indeksi).
  %    * Omega_sparse kot redka matrika (neobvezni izhod).
  
  % Preveri, ali je število vzorcev veljavno
  if nb_samples < 0 
    error('Število vzorcev (nb_samples) mora biti delež >=0')
  end
  
  % Opozorilo, če je vzorčenje manjše od dimenzij matrike
  if nb_samples < max(m,n)
    warning('Verjetno želite vzorčiti vsaj max(m,n) vzorcev')
  end
  
  % Opozorilo, če je število vzorcev večje od maksimalne možne vrednosti
  if nb_samples > m*n
    warning('Število vzorcev (nb_samples) je večje od maksimalne vrednosti (m*n). Nastavitev na m*n, vendar to ne bo zanimiv problem matrike ...')
    nb_samples = m*n;
  end
  
  % Ustvari naključne indekse vzorčenja
  Omega = randsampling(m,n,nb_samples);
  
  % Če je zahtevan drugi izhod (redka matrika)
  if nargout == 2
    [Omega_i, Omega_j] = ind2sub([m,n], Omega);
    Omega_sparse = sparse(Omega_i, Omega_j, 1, m, n, nb_samples);
  end
  
  end
  
  function omega = randsampling(n_1,n_2,m)
  % Funkcija za ustvarjanje naključnega vzorčenja
  
  % Naključno generiranje indeksov
  omega = ceil(rand(m, 1) * n_1 * n_2);
  
  % Zagotovitev unikatnosti indeksov
  omega = unique(omega);
  
  % Če ni dovolj vzorcev, generiraj dodatne
  while length(omega) < m    
      omega = [omega; ceil(rand(m-length(omega), 1) * n_1 * n_2);];
      omega = unique(omega);
  end
  
  % Omejitev na natanko m vzorcev
  omega = omega(1:m);
  
  % Razvrsti indekse
  omega = sort(omega);
  
  end
  