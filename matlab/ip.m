function i = ip(x,h1,h2)
% Izračuna skalarni produkt h1 in h2 (tangenti v x)

% Izračuna skalarni produkt med matrikama h1.M in h2.M ter sešteje rezultate za h1.Up in h2.Up ter h1.Vp in h2.Vp
i = h1.M(:)'*h2.M(:) + h1.Up(:)'*h2.Up(:) + h1.Vp(:)'*h2.Vp(:);
