function example_slika_rgb()
    % Določitev poti za R, G in B kanale
    color_channels = {'R', 'G', 'B'}; % Barvni kanali
    base_path = '/path/'; % Osnovna pot do podatkov
    noise_level = '25'; % Nastavitev glede na raven šuma v imenih datotek
    
    % Iteracija preko barvnih kanalov
    for i = 1:length(color_channels)
        channel = color_channels{i};
        
        % Nalaganje matrike Omega in transformiranih vrednosti za trenutni kanal
        Omega_path = sprintf('%somega.txt', base_path);
        prob.Omega = load(Omega_path); % Nalaganje indeksa vzorčnih mest
        [prob.Omega_i, prob.Omega_j] = ind2sub([1000, 1000], prob.Omega); % Pretvorba v subscripts
        
        prob.data = load(sprintf('%svalues_%s.txt', base_path, channel)); % Nalaganje podatkov za trenutni kanal
        
        % Nastavitev problema
        m = 1000; n = 1000; % Dimenzije matrike
        k = 60; % Rang matrike
        
        prob.use_blas = true; % Uporaba optimiziranih knjižnic BLAS
        prob.n1 = m;
        prob.n2 = n;
        prob.r = k;
        prob.m = length(prob.Omega); % Število vzorčnih podatkov
        prob.temp_omega = sparse(prob.Omega_i, prob.Omega_j, prob.data * 1, prob.n1, prob.n2, prob.m); % Ustvarjanje redke matrike
        prob.mu = 0; % Parameter regularizacije
        
        % Nastavitve algoritma in začetni ugib
        options = default_opts();
        x0 = make_start_x(prob);
        
        % Zagon algoritma LRGeomCG za trenutni kanal
        t = tic; % Začetek merjenja časa
        [Xcg, hist] = LRGeomCG(prob, options, x0);
        out_time = toc(t); % Konec merjenja časa
        disp(['Kanal ', channel, ' - Čas: ', num2str(out_time), ' sekund']);
        
        % Rekonstrukcija matrike X
        X_reconstructed = Xcg.U * diag(Xcg.sigma) * Xcg.V'; % Rekonstruirana matrika
        X_reconstructed = X_reconstructed'; % Transpozicija matrike
        
        % Shranjevanje rekonstruirane matrike kot .txt datoteko
        writematrix(X_reconstructed, sprintf('X_reconstructed_%s.txt', channel), 'Delimiter', 'tab');
        
        % Normalizacija vrednosti za shranjevanje slike
        min_val = min(X_reconstructed(:));
        max_val = max(X_reconstructed(:));
        X_normalized = (X_reconstructed - min_val) / (max_val - min_val); % Normalizacija v razpon [0, 1]

        % Shranjevanje rekonstruirane slike kot .png
        imwrite(X_normalized, sprintf('X_reconstructed_%s.png', channel));
        
        % Opcijsko prikaz rekonstruirane matrike kot slike
        figure;
        imagesc(X_reconstructed);
        colorbar;
        title(['Rekonstruirana slika X - ', channel]);
        axis image;
        colormap gray;
        
        % Nalaganje originalne matrike za izračun PSNR
        X_original = load(sprintf('%sknjige_rank60.txt', base_path)); % Originalna matrika
        
        % Preverjanje, da se dimenzije originalne matrike ujemajo z rekonstruirano
        if size(X_original, 1) ~= m || size(X_original, 2) ~= n
            error('Dimenzije originalne matrike se ne ujemajo z rekonstruirano matriko.');
        end
        
        % Izračun srednje kvadratne napake (MSE)
        mse = sum((X_original(:) - X_reconstructed(:)).^2) / numel(X_original);
        
        % Izračun PSNR
        max_pixel = max(X_original(:)); % Predpostavka: vrednosti pikslov so v razponu [0, max_pixel]
        psnr_value = 10 * log10(max_pixel^2 / mse); % Formula za PSNR
        
        % Prikaz PSNR vrednosti
        fprintf('PSNR za %s kanal: %.2f dB\n', channel, psnr_value);
    end
end
