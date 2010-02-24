function tdewp,t,p,rh
;+
; ROUTINE:	tdewp
;
; PURPOSE:	compute dew point temperature from ambient temperature and
;		relative humidity.  The dew point is the temperature to
;		which air must be cooled at constant pressure and
;		constant mixing ratio to reach 100% saturation with
;		respect to a plane water surface
;
; USEAGE:	result=tdewp(t,p,rh)
;
; INPUT:      
;   t		ambient temperature	       (celsius)
;   p           ambient pressure               (mb)
;   rh		rh relative humidity	       (0-100%)
;               
;
; OUTPUT:
;   result	dew point temperature (celsius)
;
; METHOD:
;
;   From thermodynamics we know that the saturated water vapor pressure
;   is just a function of the temperature.  Lets call that function 
;   VPS(T).  Then the water vapor mixing ratio, which is the ratio of
;   the mass of vapor to the mass of dry air, is
;
;   1.	    r = (Mw/Ma) .01*rh VPS(T)/(P - VPS(T))
;
;   where rh is the relative humidity (this equation can be taken as
;   the definition of rh) and k is Boltzman's constant and Mw and Ma
;   are the molecular masses of water and air.  By the definition of
;   dew point temperature, the water vapor density in this
;   non-saturated situation can also be expressed by,
;
;   2.	    r = (Mw/Ma) VPS(Td)/(P - VPS(Td))
;
;   Now, to solve for Td in terms of T and rh we set the RHS of eqn 1
;   equal to the RHS of eqn 2.	
;
;   So the dew point is found by solving
;
;   3.	      VPS(Td)/(1.-VPS(Td)/P)=.01*rh*VPS(T)/(1.-VPS(T)/P)
;
;   To simplify matters we use an analytic approximation, 
;
;   4.        VPS(t) = c0*exp(c1*t/(t+c2)) (Tetans, 1930).  
;
;
; References:
;
; equation relating saturated vapor pressure to temperature from:
; Tetans, O. 1930. Uber emige meteorologische Begriffe. Z. Geophys. 6:297-309
;
; EXAMPLE:
;
;  print,'the dewpoint temperature is',tdewp(29,44)
;  15.4947
;
;; plot contours dew point temperture for a range of temperature
;; and relative humidity
;
;  t=findgen(100)
;  rh=1+findgen(100)
;  gengrid,t,rh
;  td=tdewp(t,1013,rh)
;  contour,td,t,rh,xtitle='temperature (C)',ytitle='relative humidity',$
;     levels=contlev(td),/follow
;
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
;
 c0=6.1078           ; puts answer in mb
 c1=17.2693882
 c2=237.7

td=t
for i=1,20 do begin
  vpd=c0*exp(c1*td/(c2+td))
  vp=c0*exp(c1*t/(c2+t))
  rr=rh*(1.-vpd/p)/(1.-vp/p)
  rhs=t/(t+c2) + alog(.01*rr)/c1
  tdnew=c2*rhs/(1.-rhs)
  dt=tdnew-td
  td=tdnew
  if abs(max([dt])) lt .0001 then return, td
endfor

message,'dewpoint iteration failed to converge'

td=-99999.

end

