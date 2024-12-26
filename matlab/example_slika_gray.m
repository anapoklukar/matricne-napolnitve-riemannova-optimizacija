function example_slika_gray()

    % Določimo dimenzije slike in rang matrike
    m = 1000; n = 1000; % dimenzije
    k = 60; % rang matrike
    
    % Naložimo podatke o točkah (Omega), kjer imamo informacije o vrednostih
    Omega = load('/path/gray_image_processed_omega.txt');
    [Omega_i, Omega_j] = ind2sub([m, n], Omega); % Preračunamo indekse vrstic in stolpcev
    
    % Inicializiramo strukturo problema in nastavimo potrebne parametre
    prob.use_blas = true; % Uporaba BLAS za pospešitev računanja
    prob.n1 = m; 
    prob.n2 = n; 
    prob.r = k; % Rang za rekonstrukcijo
    
    % Preverimo, ali je rang veljaven (mora biti manjši ali enak najmanjši dimenziji)
    if prob.r > min(prob.n1, prob.n2)
        error('Rang mora biti celo število med 1 in najmanjšo dimenzijo matrike.')
    end
    
    prob.Omega = Omega;
    [prob.Omega_i, prob.Omega_j] = ind2sub([prob.n1, prob.n2], Omega);
    prob.m = length(Omega); % Število vzorčnih točk
    
    % Naložimo transformirane vrednosti za znane točke iz datoteke
    prob.data = load('/path/gray_image_processed_transformed_values.txt');
    prob.temp_omega = sparse(prob.Omega_i, prob.Omega_j, ...
        prob.data * 1, prob.n1, prob.n2, prob.m); % Sparse matrika za hranjenje znanih vrednosti
      
    % Nastavimo regularizacijski parameter (trenutno ni uporabljen)
    prob.mu = 0;
    
    % Inicializiramo začetno rešitev in nastavitve algoritma
    options = default_opts();
    x0 = make_start_x(prob);
    
    % Prikažemo podatke problema za preverjanje
    % disp(prob)
    
    % Izvedemo rekonstrukcijo z uporabo LRGeomCG algoritma
    t = tic;
    [Xcg, hist] = LRGeomCG(prob, options, x0);
    out_time = toc(t);
    disp(hist)
    
    % Prikaz konvergence algoritma
    semilogy(hist(:, 1), 'rx') % Relativni gradient
    hold on
    semilogy(hist(:, 2), 'bx') % Relativna napaka na Omega
    legend('Rel grad', 'Rel error on Omega')
    
    % Rekonstruiramo matriko X iz komponent U, sigma in V
    X_reconstructed = Xcg.U * diag(Xcg.sigma) * Xcg.V';
    X_reconstructed = X_reconstructed';
    
    % Shranimo rekonstruirano matriko v datoteko
    writematrix(X_reconstructed, 'X_reconstructed.txt', 'Delimiter', 'tab');
    
    % Prikažemo rekonstruirano matriko kot sliko
    figure;
    imagesc(X_reconstructed); % Prikažemo sliko rekonstruirane matrike
    colorbar; % Dodamo barvno lestvico
    title('Reconstructed Image X'); % Naslov slike
    axis image; % Ohranjamo pravilno razmerje stranic
    colormap gray; % Nastavimo sivinsko barvno shemo
    
    % Naložimo originalno matriko iz datoteke za primerjavo
    X_original = load('/path/matrika_primerjava.txt');
    
    % Preverimo, ali originalna matrika ustreza dimenzijam rekonstruirane
    if size(X_original, 1) ~= m || size(X_original, 2) ~= n
        error('Dimenzije originalne matrike se ne ujemajo z rekonstruirano matriko.');
    end
    
    % Normaliziramo rekonstruirano matriko v razpon [0, 1]
    min_val = min(X_reconstructed(:));
    max_val = max(X_reconstructed(:));
    X_normalized = (X_reconstructed - min_val) / (max_val - min_val);
    
    % Shranimo normalizirano sliko kot PNG
    imwrite(X_normalized, 'results/reconstructed_image.png');
    
    % Izračunamo povprečno kvadratno napako (MSE)
    mse = sum((X_original(:) - X_reconstructed(:)).^2) / numel(X_original);
    
end
    