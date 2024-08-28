function g = grad(prob,x)
% Izračuna gradient na mnogoterosti v točki x

% Vmesna matrika T: zmnožek trenutne ocene napake in matrike V
T = prob.temp_omega * x.V;

% Komponenta M gradienta: zmnožek matrike U in vmesne matrike T
g.M = x.U' * T; 

% Komponenta Up gradienta: razlika med vmesno matriko T in projekcijo na U
g.Up = T - x.U * (x.U' * T);

% Prva komponenta Vp gradienta: zmnožek transponirane ocene napake in matrike U
g.Vp = prob.temp_omega' * x.U; 

% Končna komponenta Vp gradienta: izračunamo razliko med prejšnjo komponento Vp in projekcijo na V
g.Vp = g.Vp - x.V * (x.V' * g.Vp);
