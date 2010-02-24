function airmass,sza
;+
; ROUTINE:  airmass
;
; PURPOSE:  compute airmass as a function of angle, sza, including
;           spherical earth effects
;
; USEAGE:   result=airmass(sza)
;
; INPUT:    
;   sza     zenith angle   
;
; KEYWORD INPUT:
;
; OUTPUT:   relative airmass,
;           by definition the relative airmass = 1 for sza=0.
;
; References:
;   Kasten, F 1966: A new table and approximate formula for relative
;   airmass. Arch. Meteor. Geophys. Bioklimatol. Ser. B, 14, 206-223
;
;   Leontieva, E.N., and K.H. Stamnes 1996: Remote sensing of cloud
;   optical properties from fround-based measurements of
;   transmittance: a feasibility study, Journal of Applied
;   Meteorology, 35, 2011-2022
;  
; EXAMPLE:  
;
;    sza=findrng(0,89.,dx=.1)
;    plot,sza,1./cos(sza*!dtor),yran=[1,30]
;    plot,sza,cos(sza*!dtor)*airmass(sza)
;
; AUTHOR:   Paul Ricchiazzi                        09 Jan 97
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
;-
;
return,1./(cos((sza<90.)*!dtor)+0.15*exp(-1.253*alog(93.885-(sza<90.))))
end
