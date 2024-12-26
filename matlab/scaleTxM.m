function h = scaleTxM(h,a)
% Skalira tangentni vektor h za a

h.M  = a*h.M;  % Skalira komponento M tangentnega vektorja s faktorjem a
h.Up = a*h.Up;  % Skalira komponento Up tangentnega vektorja s faktorjem a
h.Vp = a*h.Vp;  % Skalira komponento Vp tangentnega vektorja s faktorjem a
