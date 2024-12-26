function [prob,x] = default_prob()

% Nastavitev stanja za generatorja naključnih števil (za ponovljivost rezultatov)
randn('state',2009);
rand('state',2009);

% Določitev velikosti matrik in ranga
prob.n1 = 20; prob.n2 = 20; prob.r = 2;
oversampling = 2; % Faktor za prekomerno vzorčenje

prob.tau = 0; % Regularizacijski parameter (trenutno nič)

% Generiranje naključnih točnih matrik (M_exact_A in M_exact_B)
prob.M_exact_A = randn(prob.n1,prob.r);
prob.M_exact_B = randn(prob.n2,prob.r);

% Izračun stopnje prostosti (degrees of freedom)
df = prob.r*(prob.n1+prob.n2-prob.r);

% Določitev števila opazovanih vnosov (m), ki je minimum med prekomernim vzorčenjem in 99% elementov matrike
prob.m = min(oversampling*df,round(.99*prob.n1*prob.n2));

% Izbor naključnih vnosov iz matrike (Omega) in njihovo razvrščanje
prob.Omega = randsample(prob.n1*prob.n2,prob.m);
prob.Omega = sort(prob.Omega);

% Izračun vrstičnih in stolpčnih indeksov za izbrane vnose (Omega_i in Omega_j)
[prob.Omega_i, prob.Omega_j] = ind2sub([prob.n1,prob.n2], prob.Omega);

% Izračun vnosov matrike M na izbranih lokacijah (Omega)
prob.data = XonOmega(prob.M_exact_A, prob.M_exact_B, prob.Omega);

% Ustvarjanje redke matrike M_Omega z izbranimi vrednostmi
prob.M_Omega = sparse(prob.Omega_i, prob.Omega_j, prob.data, prob.n1, prob.n2, prob.m);

% Ustvarjanje začasne matrike temp_omega, ki hrani iste vrednosti kot M_Omega
prob.temp_omega = sparse(prob.Omega_i, prob.Omega_j, prob.data*1, prob.n1, prob.n2, prob.m);

% Prikaz razmerja med številom opazovanj in stopnjo prostosti
m_df = prob.m / df;
m_n_n = prob.m / prob.n1 / prob.n2;

% Preverjanje pravilnosti rezultatov (komentarji onemogočeni)
% T = zeros(n1,n2);
% M = prob.M_exact_A*prob.M_exact_B';
% T(prob.Omega) = M(prob.Omega);
% norm(prob.M_Omega - T,'fro')

% Ustvarjanje naključnega začetnega vektorja x
x = make_rand_x(prob);
