function ht = transpVect(prob, x,h,d, type)
% Transportira vektor (x,h) vzdolž smeri d
% type == 0: transpVect(x,h,d)
%    transportiramo tako, da projiciramo h ortogonalno na R_x(d)
% type == 1: transpVect(x,h,z)
%    transportiramo tako, da projiciramo h ortogonalno na z
% vrne ht, transportiran vektor h

%% z je "osnova" ht
if nargin == 4
    type = 0;
end
if type == 0    
    z = moveEIG(prob, x, d, 1);
else % type = 1
    z = d;
end

%% dani vektor je (x,h) in ga transportiramo na d

ip_old = ip(x, h, h);

%% h1 je x.U*h.M*x.V'
M1 = (z.U' * x.U) * h.M * (x.V' * z.V);

%% h2 je h.Up*x.V'
Up2 = h.Up * (x.V' * z.V);

%% h3 je x.U*h.Vp'
Vp3 = h.Vp * (x.U' * z.U);

%% rezultat
ht.M = M1;
ht.Up = Up2;
ht.Up = ht.Up - z.U * (z.U' * ht.Up);
ht.Vp = Vp3;
ht.Vp = ht.Vp - z.V * (z.V' * ht.Vp);

ip_new = ip(z, ht, ht);
ht = scaleTxM(ht, ip_old / ip_new);

