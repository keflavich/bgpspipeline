function relhum,t,tw,p
;+
; ROUTINE:      relhum
;
; PURPOSE:      compute relative humidity from wet and dry bulb temperature
;               and pressure
;
; USEAGE:       result=relhum(td,tw,p) 
;
; INPUT:      
;   t           ambient (dry bulb) temperature (celsius)
;   tw          wet bulb temperatrue           (celsius)
;   p           pressure                       (mb)
;
; OUTPUT:
;   rh         relative humidity (partial pressure of water vapor divided
;              by the saturated water vapor pressure)
;
; EXAMPLE:
;   
;               print,'the relative humidity is     ',relhum(29,20,980)
;
; References:
;
; Tetans, O. 1930. Uber emige meteorologische Begriffe. Z. Geophys. 6:297-309
;
; Weiss, A.1977. Algorithms for Calculation of Moist Air Properties on a Hand
; Calculator. Trans. ASAE 20:1133-1136
;
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
;   ps  = saturated vapor pressure at ambient temperature  (mb)
;   pw  = saturated vapor pressure at wet bulb temperature (mb)
;   pa  = actual vapor pressure in                         (mb)
;

ps = 6.1078 * exp(17.2693882*t/(237.7+t)) 
pw = 6.1078 * exp(17.2693882*tw/(237.7+tw))

n=.62198
cpa=1.00568                 ; (J/deg C /g)  heat capacity at constant pressure
cpv=1.84600                 ; (J/deg C /g)  heat capacity at constant volume
L=2500.80-2.3668*tw
ws = n * ps / (P - ps)
a=n*(cpa+cpv*ws)/(L*(n+ws)^2)
pa=pw-a*p*(t-tw)
tdew=alog(pa/61.078)/17.2693882
tdew=237.7*tdew/(1.-tdew)
return, (pa/ps) * 100

end
