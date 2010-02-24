function daverage,lat,sza,yy
;+
; ROUTINE:    daverage
;
; USEAGE:     daverage,lat,sza,yy
;
; PURPOSE:
;             finds the daylight hour average of yy at each latitude
;             point.  Average values are for spring or fall equinox
;
; INPUT:
;   lat       array of latitude points
;   sza       solar zenith angle array
;   yy        function of solar zenith angle
;
; OUTPUT:
;   result    average of yy over 12 hours (daylight)
; 
; EXAMPLE:
;
;   lat=indgen(10)*10
;   sza=acos((indgen(11))*.1)/!dtor
;   yy=90-sza
;   !p.multi=[0,1,2]
;   plot,sza,yy
;   plot,lat,daverage(lat,sza,yy)
;
;
;
; procedure:  At the spring or fall equinox the solar zenith angle at
;             a given latitude is given by,
;
;               cos(sza)=cos(lat)*cos(phi) 
;
;             where phi is the phase angle of the earth's rotation
;             [= 2 pi*(time-12)/24)]
;
;             thus for each value of lat we have
;
;                     yave=integral(phi,yv)/!pi
;             where,
;                     yv=interpol(yy,mu,cos(lat*!dtor)*cos(phi*!dtor))
;                     mu=cos(sza*!dtor)
;
;
; AUTHOR:   Paul Ricchiazzi                        24 Aug 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
nlat=n_elements(lat)        
lmu=cos(lat*!dtor)
mu=cos(sza*!dtor)

phi=findrng(-!pi/2,!pi/2,100)
yyave=fltarr(nlat)
for i=0,nlat-1 do begin
  yyy=interpol(reform(yy),mu,lmu(i)*cos(phi))
  yyave(i)=integral(phi,yyy)/!pi
endfor
return,yyave
end


