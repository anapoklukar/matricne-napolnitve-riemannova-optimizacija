function example_nakljucna_matrika()

    % Inicializacija generatorjev naključnih števil (opcijsko)
    % randn('state',1); rand('state',1);
    
    m = 20000; n = 20000; % dimenzije matrike
    k = 10; % rang matrike
    % Relativni faktor presežnega vzorčenja 
    % OS=1 je minimum, 2 je težko, 3 je v redu, 4+ je enostavno.
    OS = 5;
    
    % Ustvarjanje naključnih faktorjev
    L = randn(m, k); % Leva naključna matrika dimenzij m x k
    R = randn(n, k); % Desna naključna matrika dimenzij n x k
    dof = k * (m + n - k); % Število prostostnih stopenj
    
    % Ustvarjanje naključnih vzorcev, problema in začetnega ugiba
    samples = floor(OS * dof); % Število vzorčnih podatkov
    Omega = make_rand_Omega(m, n, samples); % Naključno izbiranje vzorčnih mest
    % disp(Omega) % Prikaz matrike vzorčnih mest (opcijsko)
    prob = make_prob(L, R, Omega, k); % Ustvarjanje problema z danim rangom
    
    % Pridobitev privzetih nastavitev algoritma
    options = default_opts(); 
    x0 = make_start_x(prob); % Ustvarjanje začetnega ugiba za algoritem
    % options.rel_f_tol = sqrt(1e-10); % Natančnost (opcijsko)
    % options.verbosity = 0; % Nastavitev prikaza izpisov (opcijsko)
    
    % Začetek časovne meritve algoritma
    t = tic; 
    [Xcg, hist] = LRGeomCG(prob, options, x0); % Reševanje problema z algoritmom LRGeomCG
    out_time = toc(t); % Čas izvajanja algoritma
    % disp(hist) % Prikaz zgodovine algoritma (opcijsko)
    
    % Prikaz konvergence algoritma
    semilogy(hist(:,1), 'rx') % Prikaz relativnega gradienta
    hold on
    semilogy(hist(:,2), 'bx') % Prikaz relativne napake na vzorcih Omega
    legend('Relativni gradient', 'Relativna napaka na Omega')
    
end    