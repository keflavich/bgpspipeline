function radtemp,w,r,microns=microns
;+
; ROUTINE:  radtemp
;
; PURPOSE:  compute radiation temperature from a radiance distribution
;
; USEAGE:   radtemp,w,r,microns=microns
;
; INPUT:    
;   w       wavelength in microns or wavenumber in cm-1
;   r       radiance in w/m2/um/str or w/m2/cm-1/str
;           divide irradiance by pi 
;
; KEYWORD INPUT:
;
;  microns  set to one for micron units
;
; OUTPUT:
;   result  radiation temperature in kelvin
;
;  
; EXAMPLE:  
;
; AUTHOR:   Paul Ricchiazzi                        20 Nov 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-

h=6.6262e-27 & bk=1.3807e-16 & c=2.9979e10

if keyword_set(microns) then begin
  c1=2.e13*h*c^2
  c2=1.e4*h*c/bk
  return,c2/(w*alog(1.+c1/(w^5*r)))
endif else begin
  c1=2.e-3*h*c^2
  c2=h*c/bk
  return,w*c2/alog(1.+c1*w^3/r)
endelse
end
