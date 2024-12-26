function example_nakljucna_matrika_multiple_runs()
    % Primer izvedbe algoritma za rekonstrukcijo matrike z več ponovitvami
    
    % Parametri
    m = 1000; n = 1000; % Dimenzije matrike
    k = 250; % Rank (rang matrike)
    OS = 3; % Relativni faktor prekomernega vzorčenja
    num_runs = 10; % Število izvedb eksperimenta
    
    % Inicializacija tabel za shranjevanje rezultatov
    iterations = zeros(num_runs, 1); % Število iteracij
    times = zeros(num_runs, 1); % Čas izvedbe
    psnrs = zeros(num_runs, 1); % PSNR vrednosti
    
    for i = 1:num_runs
        % Generiranje naključnih faktorjev
        L = randn(m, k); % Levi faktor matrike
        R = randn(n, k); % Desni faktor matrike
        dof = k * (m + n - k); % Stopnja prostosti
    
        % Generiranje naključnega vzorčenja, problema in začetne rešitve
        samples = m * n * 0.75; % Število vzorcev (75 % matrike)
        Omega = make_rand_Omega(m, n, samples); % Naključni vzorci
        prob = make_prob(L, R, Omega, k); % Definicija problema (lahko spremenite rank)
    
        options = default_opts(); % Nastavitve algoritma
        x0 = make_start_x(prob); % Začetna vrednost za optimizacijo
    
        % Zaženi optimizacijo
        t = tic; % Začetek merjenja časa
        [Xcg, hist] = LRGeomCG(prob, options, x0); % Glavni optimizacijski algoritem
        times(i) = toc(t); % Čas izvedbe optimizacije
        iterations(i) = size(hist, 1); % Število iteracij
    
        % Rekonstrukcija matrike
        X_reconstructed = Xcg.U * diag(Xcg.sigma) * Xcg.V'; % Rekonstruirana matrika
        X_reconstructed = X_reconstructed';
    
        % Izračun originalne matrike
        X_original = (L * R')';
    
        % Izračun PSNR (Peak Signal-to-Noise Ratio)
        X_original_normalized = (X_original - min(X_original(:))) / (max(X_original(:)) - min(X_original(:))); % Normalizacija originala
        X_reconstructed_normalized = (X_reconstructed - min(X_reconstructed(:))) / (max(X_reconstructed(:)) - min(X_reconstructed(:))); % Normalizacija rekonstrukcije
    
        mse = mean((X_original_normalized(:) - X_reconstructed_normalized(:)).^2); % Povprečna kvadratna napaka
    
        if mse == 0
            psnr = Inf; % Če ni napake, je PSNR neskončen
        else
            max_pixel = 1; % Maksimalna vrednost v normalizirani matriki
            psnr = 10 * log10(max_pixel^2 / mse); % Izračun PSNR
        end
    
        psnrs(i) = psnr;
    
        % Izpis rezultatov za posamezen zagon
        fprintf('Zagon %d: Št. iteracij: %d, Čas: %f s, PSNR: %f dB\n', i, iterations(i), times(i), psnrs(i));
    end
    
    % Izračun povprečij in standardnih odklonov
    avg_iterations = mean(iterations);
    std_iterations = std(iterations);
    
    avg_time = mean(times);
    std_time = std(times);
    
    avg_psnr = mean(psnrs);
    std_psnr = std(psnrs);
    
    % Prikaz končnih rezultatov
    fprintf('\nPovprečno število iteracij: %f (Std: %f)\n', avg_iterations, std_iterations);
    fprintf('Povprečen čas: %f s (Std: %f)\n', avg_time, std_time);
    fprintf('Povprečen PSNR: %f dB (Std: %f dB)\n', avg_psnr, std_psnr);
    
end
    