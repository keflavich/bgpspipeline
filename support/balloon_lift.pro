function balloon_lift,r,rho,kg=kg
;+
; ROUTINE:   balloon_lift 
;
; PURPOSE:   compute lifting capacity of a helium balloon
;
; USEAGE:    result=balloon_lift(r,rho,kg=kg)
;
; KEYWORD INPUT:    
;   r        balloon radius in meters         (default=1.0 m)
;   rho      air density at operating alitude (defualt=1.29 kg/m3)
;
;   result   lifting capacity in newtons 
;            (if kg is set lifting capacity is in kg)
;
; EXAMPLE:   lifting capacity of a 1 m radius helium balloon at an 
;            altitude of 1 km. 
;      
;            rho=rhoz(p0=1013.,t0=273.,z=1.,lr=7.)
;            print,balloon_lift(1.,rho)
;
; EXAMPLE:   lifting capacity of a non-stretching 1 m radius helium
;            balloon at an altitude of 1 km.  To prevent the balloon
;            from bursting at high altitude the balloon should not be
;            filled to full capacity with helium at sealevel. Assume
;            the helium retains its sealevel temperature (maybe less
;            than ambient).
;
; r=1
; t0 = 273.
; p0 = 1013.
; rho1 = rhoz(p0 = p0,t0 = t0,z = 1,lr = 7.)
; rho0 = rhoz(p0 = p0,t0 = t0,z = 0,lr = 7.)
; p1 = p0*(rho1/rho0)*(t0-7.)/t0
; rs=r*(p1/p0)^.3333
; print,balloon_lift(rs,rho1)
;
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
; the lifting mass = 4/3 * pi * r^3 * rho * (1. - M_helium/M_air)
;
; where rho is evaluated at the operating alitude
;
;

mair=28.91
mhe=4.
g=9.8067

if keyword_set(kg) then begin
  return,(4./3.)*!pi*r^3*rho*(1.-mhe/mair)
endif else begin
  return,(4./3.)*!pi*r^3*rho*(1.-mhe/mair)*g
endelse

end
