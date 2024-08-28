function example()

% Nastavimo začetno stanje generatorja naključnih števil
randn('state',0); rand('state',0);

m = 1000; n = 1000; % Dimenzije slike, vedno 1000x1000
k = 15; % Rang slike

% Naložimo matriki L in R iz datotek
L = load('../python/tokyo_podatki/L_matrix.txt');
R = load('../python/tokyo_podatki/R_matrix.txt');

% Preverimo, da so dimenzije L in R matrik pravilne
if size(L, 1) ~= m || size(L, 2) ~= k
    error('Napacne dimenzije L matrike'); % Napaka, če dimenzije L matrike niso pravilne
end
if size(R, 1) ~= n || size(R, 2) ~= k
    error('Napacne dimenzije R matrike'); % Napaka, če dimenzije R matrike niso pravilne
end

% Nastavimo "problem"
prob.use_blas = true; % Uporabimo BLAS knjižnico za hitrejše izračune

% Velikosti L in R matrik
prob.n1 = size(L,1); 
prob.n2 = size(R,1); 

% Rang
prob.r = k;

% Rang mora biti med 1 in min(n1,n2)
if prob.r > min(prob.n1, prob.n2)
    error('Napacna izbira ranga.'); % Napaka, če je rang izven dovoljenega intervala
end

% Omego preberemo iz podatkov
prob.Omega = load('../python/tokyo_podatki/omega.txt');

% Omega_i predstavlja indekse vrstic Omege
prob.Omega_i = load('../python/tokyo_podatki/omega_i.txt');

% Omega_j predstavlja indekse stolpcev Omege
prob.Omega_j = load('../python/tokyo_podatki/omega_j.txt');

% Število Omega elementov
prob.m = length(prob.Omega);

% Vektor znanih vrednosti
prob.data = load('../python/tokyo_podatki/values.txt');

% Matrika s podatki na Omega elementih
prob.temp_omega = load('../python/tokyo_podatki/tokyo_rank15_noise50.txt');
  
% Regularizacija na 0
prob.mu = 0;

% Nastavimo možnosti na privzete
options = default_opts();

% Začetna točka
x0 = make_start_x(prob);

t = tic; % Začnemo meriti čas
[Xcg, hist] = LRGeomCG(prob, options, x0); % Klic funkcije LRGeomCG za iskanje rešitve
out_time = toc(t); % Končamo merjenje časa
disp(out_time); % Prikažemo čas izvajanja
disp(hist); % Prikažemo zgodovino iteracij

% Narišemo rezultate
semilogy(hist(:,1),'rx'); % Narišemo relativno normo gradienta
hold on;
semilogy(hist(:,2),'bx'); % Narišemo relativno napako na Omega
legend('Rel grad', 'Rel error on Omega'); % Dodamo legendo za graf

% Rekonstrukcija matrike X iz komponent U, sigma in V
% X = U * diag(sigma) * V'
X_reconstructed = Xcg.U * diag(Xcg.sigma) * Xcg.V';

% Prikaz rekonstruirane matrike kot slike
figure;
imagesc(X_reconstructed); % Narišemo sliko rekonstruirane matrike
colorbar; % Prikažemo barvno lestvico za prikaz obsega
title('Reconstructed Image X'); % Naslov slike
axis image; % Zagotovimo pravilen razmerje stranic
colormap gray; % Nastavimo barvno shemo na sivo-odtenke za boljšo vizualizacijo

% Po potrebi shranimo sliko
saveas(gcf, 'results/tokyo_rank15_noise50_reconstructed.png'); % Shranimo sliko

% Izračunamo in prikažemo PSNR, če je na voljo referenčna slika
reference_matrix_path = '../python/tokyo_podatki/tokyo_matrix_rank15.txt'; % Pot do referenčne matrike

if isfile(reference_matrix_path)
    reference_matrix = load(reference_matrix_path); % Naložimo referenčno matriko
    
    if isequal(size(X_reconstructed), size(reference_matrix))
        psnr_value = compute_psnr(X_reconstructed, reference_matrix); % Izračunamo PSNR
        fprintf('PSNR: %.2f dB\n', psnr_value); % Prikazujemo PSNR
    else
        warning('Rekonstruirana in referencna matrika nista enakih dimenzij.'); % Opozorilo, če se dimenzije ne ujemajo
    end
else
    warning('Referencna matrika ni najdena.'); % Opozorilo, če datoteka z referenčno matriko ni najdena
end

end

function psnr_value = compute_psnr(reconstructed, reference)
    % Izračunaj srednji kvadratni napaki (MSE)
    mse = mean((reconstructed(:) - reference(:)).^2);
    
    % Izračunaj največjo vrednost piksla (predpostavimo, da so slike v sivih odtenkih)
    max_pixel = max(reference(:));
    
    % Izračunaj PSNR
    psnr_value = 10 * log10(max_pixel^2 / mse);
end
