function balloon_drag,r,rho,v,cd
;+
; ROUTINE:   balloon_drag 
;
; PURPOSE:   compute drag on shere
;
; USEAGE:    result=balloon_drag(r,rho,v,cd)
;
; KEYWORD INPUT:    
;   r        balloon radius in meters      (default=1.0 m)
;   v        wind velocity (mph)           (default=5 m/s)
;   rho      air density                   (default=1.29 kg/m3)
;   cd       drag coefficient              (default=0.2)
;
; NOTE:      1 m/s = 3.60 km/hr = 2.23 mph = 1.94 knots
;
; OUTPUT:   
; 
; result     drag force in newtons 
;
;            
; SOURCE:    Steve Robinson
;            NASA/MIT
;            stever@space.mit.edu
;
;            Drag on sphere = .5 * Cd * rho * v^2 * pi * r^2
;
;            Cd = function of sphere Reynolds number 
;                 (V*2*r)/(kinematic viscosity),
;                 but 0.2 should be close.
;            
; EXAMPLE:
;            r=1. & v=10. & cd=.2
;            rho=rhoz(p0=1013.,t0=273.,z=1.,lr=7.)
;            print,balloon_drag(r,rho,v,cd)
;            
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
;

if not keyword_set(r) then r=1.          ; meters
if not keyword_set(v) then v=5.          ; m/s      (1 m/s = 2.25 mph )
if not keyword_set(cd) then cd=.2

return,.5*cd*!pi*r^2*rho*v^2

end





