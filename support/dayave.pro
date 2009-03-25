function dayave,doy,lat,sza,xx,dt=dt,zenith=zenith,night=night,day=day
;+
; ROUTINE:    dayave
;
; PURPOSE:    convert quantities which depend on sza to daily averages for 
;             given values of day_of_year and latitude
;
; USEAGE:     result=dayave(doy,lat,sza,xx)
;
; INPUT:      
;   doy       the day of year (vector)
;
;   lat       latitude (vector)
;
;   sza       a vector of solar zenith angles (degrees) monitonic increasing
;
;   xx        a vector of a quantity which varies with SZA. If
;             max(sza) lt 90 then it is assumed that xx=0 when
;             (cos(sza) le 0).  If this is not the case, then data
;             values for the full SZA angle range [-90,90] must be
;             supplied.
;             
;
; KEYWORD INPUT
;   dt        averaging interval in hours (default=0.25 hours)
;
;   zenith    zenith angles at each time, doy and lat (24/dt,nday,nlat)
;             (returned by first call of DAYAVE, see below)
;             if zero or absent, DAYAVE recomputes the zenith angle at 
;             each point in the (DOY # LAT) input grid.  This can be
;             fairly time consuming when there are lots of grid points.
;             By supplying a zero filled named variable to DAYAVE you
;             can retrieve the ZENITH grid for the next call to DAYAVE.
;
;   night     if set, the interpolated value of xx is not set to zero 
;             when sza is greater than 90.  This should be used for 
;             physical quantities which maintain non-zero values even
;             after sunset
;

; OUTPUT:
;   result   the integral of xx(t) dt for the given days and latitudes
;
;
; EXAMPLE:
;      !p.multi=[0,1,2]
;      doy=findgen(365/30+1)*30
;      lat=findgen(90/10+1)*10
;      sza=findgen(90/10)*10
;      xx=cos(sza*!dtor)
;      zenith=0.                         ; zero filled named variable to 
;                                        ; retrieve zenith angle grid 
;      
;      yy=dayave(doy,lat,sza,xx,zenith=zenith)
;      tvim,yy,xrange=doy,yrange=lat,xtitle='day of year',ytitle='latitude',$
;           title='daily integral of sup(cos(sza),0)',/scale,/interp
;
;      xx2=xx^2
;      yy2=dayave(doy,lat,sza,xx2,zenith=zenith)
;      tvim,yy2,xrange=doy,yrange=lat,xtitle='day of year',ytitle='latitude',$
;           title='daily average of sup(cos(sza)!a2!n,0)',/scale,/interp
;  
;  author:  Paul Ricchiazzi                            aug94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

if not keyword_set(dt) then dt=.25  

time=findgen(24/dt)*dt
dayx=doy
timex=time
latx=lat
IF n_elements(dayx) NE 1 OR n_elements(latx) NE 1 THEN gengrid,timex,dayx,latx

if not keyword_set(zenith) then zensun,dayx,timex,latx,0.,zenith

;; add in some over the horizon SZA if not already present

ilast=n_elements(sza)-1

if sza(ilast) lt 90. then begin
  szax=[sza,90,90.+(90-sza(ilast))]
  xxx= [xx,0.,-xx(ilast)]
endif else begin
  szax=sza
  xxx=xx
endelse

fx=finterp(szax,zenith)
yy=interpolate(xxx,fx) 

if not keyword_set(night) then yy(where(zenith gt 90))=0.

nlat=n_elements(lat)
nday=n_elements(doy)
ntim=n_elements(time)
 
result=fltarr(nday,nlat)

for j=0,nlat-1 do begin
  for i=0,nday-1 do begin
    x=reform(timex(*,i,j))
    y=reform(yy(*,i,j))
    result(i,j)=integral(x,y)
  endfor
endfor

return,result
end


