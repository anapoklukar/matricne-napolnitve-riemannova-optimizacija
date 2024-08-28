function opts = default_opts()

opts.maxit = 100;  % Največje število iteracij

% Tolerance za Riemannov gradient ciljne funkcije
opts.abs_grad_tol = 0;  % Absolutna tolerance na gradient (zaenkrat nastavljena na 0)
opts.rel_grad_tol = 1e-12;  % Relativna tolerance na gradient

% Tolerance za l_2 napako na vzorčnem naboru Omega
opts.abs_f_tol = 0;  % Absolutna tolerance na funkcijo (zaenkrat nastavljena na 0)
opts.rel_f_tol = 1e-12;  % Relativna tolerance na funkcijo

% Tolerance za zaznavanje stagnacije
opts.stagnation_detection = false;  % Zaznavanje stagnacije je izklopljeno (poceni test, vendar traja nekaj časa)
opts.rel_tol_change_x = 1e-12;  % Relativna tolerance za spremembo v x
opts.rel_tol_change_res = 1e-4;  % Relativna tolerance za spremembo rezultata


opts.verbosity = 1;  % Stopnja podrobnosti izpisovanja
