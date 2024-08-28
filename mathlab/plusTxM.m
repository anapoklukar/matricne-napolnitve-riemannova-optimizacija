function h = plusTxM(h1,h2,a1,a2)
% Sesteje tangentna vektorja v istem tangentnem prostoru

h.M = a1*h1.M + a2*h2.M;  % Sešteje komponente M obeh tangentnih vektorjev, pomnožene z a1 in a2
h.Up = a1*h1.Up + a2*h2.Up;  % Sešteje komponente Up obeh tangentnih vektorjev, pomnožene z a1 in a2
h.Vp = a1*h1.Vp + a2*h2.Vp;  % Sešteje komponente Vp obeh tangentnih vektorjev, pomnožene z a1 in a2
