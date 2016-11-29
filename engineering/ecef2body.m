function Tbe = ecef2body(PHI)
% T = body2ecef(PHI)
% PHI=  [phi theta psi]

phi = PHI(1);
the = PHI(2);
psi = PHI(3);

T1e = rotation(psi,3);
T21 = rotation(the,2);
Tb2 = rotation(phi,1);

Tbe = Tb2  * T21  * T1e;
% Teb = T1e' * T21' * Tb2';