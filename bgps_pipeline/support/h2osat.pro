 function h2osat,t,vp=vp
;+
; routine:      h2osat
;
; purpose:      compute saturated density of water vapor
;
; useage:       result=h2osat(t)
;
; input:
;   temp        air temperature in kelvin
;
; output:
;   result      water vapor density at 100% saturation (g/m3)
;               if keyword vp is set result is saturated water 
;               vapor pressure (mb).  
;
;                            
;      NOTE:         h2osat(t)=h2osat(t,/vp)/Mkt
;
;               where M is the molecular mass of h2o, and k
;               is boltzman's constant.
;
; reference:    Here is how I came up with the polynomial fit you see below
;
;               1. copy out table of saturated water vapor pressure 
;                  vs temparature from Handbook of Chemistry and Physics 
;               2. find a polynomial fit of log(P) vs (1/t) 
;                  (Clausius-Clapeyron equation has P = Po exp(-to/t))
;               3. convert vapor pressure to density using the molecular mass
;                  of H2O (standard isotope mix)
;
; EXAMPLE:                                              
;
;;  compute water density at a relative humidity of 50% and
;;  an air temperature of 25 C.
;
;               k=1.38e-23 & rh=.5 & t=25.0+273.15 & p=101325.
;               wdens=h2osat(25.0+273.15)
;               wden=rh*wdens/(1.-k*t*wdens*(1.-rh)/p)
;
;; at pressures greater than ~300mb this is well approximated by
;
;               wden=rh*wdens
;
;
;
;; compute water density (g/m3) corresponding to a dew point
;; temperature of 10 C and ambient temperature of 25 C.
;; The dew point is the temperature to which air must be 
;; cooled at constant pressure and constant mixing ratio to
;; reach 100% saturation with respect to a plane water surface
;;
;;      by definition    mixing ratio ~ Nw/(N-Nw) = SVP(Tdew)/(P-SVP(Tdew))
;;
;;          Nw kT/(P-Nw kT) = SVP(Tdew)/(P-SVP(Tdew))
;;
;;          Nw = SVP(Tdew)/kT
;
;;
;; where SVP is the saturated vapor pressure
;
;               tdew=10.+273.15
;               t=25+273.15
;               
;               Pvap=h2osat(tdew)
;               wden=h2osat(tdew)*tdew/t    ; mass density   (g/m3)
;
;
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

k=1.3807e-23                     ; boltzmann constant      (joules/kelvin)
mw=2.9915e-23                    ; molecular mass of water (g)
t0=273.15                        ; freezing point of water (kelvin)
a=t0/t

ps=exp(19.1484-a*(14.845878+a*2.4918766))

if keyword_set(vp) then begin
   return,ps                     ; (mb)
endif else begin
   fac=100.*mw/(t0*k)
   return,ps*fac*t0/t            ; (g/m3)
endelse
end

