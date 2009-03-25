function rhoz,p0=p0,t0=t0,z=z,lr=lr
;+
; ROUTINE:   rhoz
;
; USEAGE:    result=rhoz(p0=p0,t0=t0,z=z,lr=lr)
;
; PURPOSE:   compute air density at altitude z
;
; KEYWORD_INPUTS:
;
;   p0       surface pressure in mb        (default=1013.0 mb)
;   t0       surface temperature in kelvin (default=273.0 K)
;   z        alitude (km)                  (default=0 km)
;   lr       lapse rate in kelvin/km       (default=6.5 K/km)
;
;   result   air density                   (kg/m3)
;
;
;  EXAMPLE:  compute pressure at a given altitude 
;
;  p=1013.0*rhoz(z=.440,t0=290.,lr=6.5)/rhoz(t0=290.,lr=6.5)
;
  
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
;

amu=1.66e-27                             ; atmoic mass unit (kg)
mair=28.91*amu                           ; molecular mass (kg)
k=1.38e-23                               ; bolztman constant (J/K)
g=9.806                                  ; m/s/s

 
if not keyword_set(lr) then lr=6.5       ; kelvin/km
if not keyword_set(p0) then p0=1013.     ; mb
if not keyword_set(t0) then t0=273.      ; kelvin
if not keyword_set(z) then z=0.          ; km

; pressure in mb
; altitude in km
; lapse rate in kelvin/km

if lr eq 0. then begin
  arg=mair*g/(k*t0)
  pz=p0*exp(-arg*z*1000.)   
  tz=t0
endif else begin
  arg=mair*g/(k*lr*.001)
  pz=p0*(1.-lr*z/t0)^arg
  tz=t0-lr*z
endelse

return,mair*(100.*pz)/(k*tz)

end





