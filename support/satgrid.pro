pro satgrid,nx,ny,alon,alat,lon0=lon0,lat0=lat0,inclin=inclin, $
            alt=alt,period=period,lres=lres,sres=sres,dmsp=dmsp, $
            descend=descend,time=time,swath=swath

;+
; ROUTINE:  satgrid
;
; PURPOSE:  compute data coordinates of scanning sensors deployed on 
;           polar orbiting satellites
;
; USEAGE:   satgrid,nx,ny,alon,alat,lon0=lon0,lat0=lat0,inclin=inclin, $
;            alt=alt,period=period,lres=lres,sres=sres,dmsp=dmsp, $
;            descend=descend,time=time
;
; INPUT:    
;
;  nx        number of samples, if nx le 1 then alon and alat
;            are one dimensional vectors which specify the satellite
;            ground track.  
;
;  ny        number of lines
;
;
; KEYWORD INPUT:
;
;
;  lon0      longitude of equator crossing     (degrees)
;            the NOAA polar orbiters cross the equator at the same
;            local time each day.  Local time is defined as 
;
;                tloc = utc - fix(lon+7.5)/15
;
;            For example if the ascending node crossing occurs at local
;            time 14:30, or 2.5 hrs after noon, then in a given day
;            lon0 takes on the values,
; 
;                 lon0 = indgen(24)*15 + 15*2.5
;
;                        or for a particular longitude
;
;                 lon0 = 15*fix(lon+7.5)/15   +   15*2.5 
;
;  inclin    orbital inclination               (degrees)  (default=98.9127)
;            0 < inclin < 180
;            (this is the angle between the north pole and the the
;            satellite orbital axis. [Use right hand rule to establish
;            direction of orbital axis.] The default value cooresponds to
;            to a sun sychronous orbit. 
;
;  alt       altitude of orbit                 (km)       (default=853. km)
;
;  period    period of orbit                   (hours)    (default=1.6985 hrs)
;
;            either alt or period may be input and the other quantity is
;            computed through the relation between orbital period and altitude
;
;  dmsp      set to 1 if satellite ground resolution is held constant
;            in the crosstrack direction, as it is on the DMSP satellite,
;
;  lres      along track resolution at nadir=0 (km)       (default=1.)
;
;  sres      cross track resolution at nadir=0 (km)       (default=1.)
;
;            NOTE: SRES is internally limited to less than
;                  .999*2*nadrlim/(nx-1), where nadrlim is the 
;                  maximum nadir angle for which the earth is 
;                  still in the IFOV of the sensor.
;
;  descend   if set, choose descending node.  This affects the
;            ordering of the ALON and ALAT grids.
;
; OUTPUT:
;  alon      longitude array
;
;  alat      latitude array
;
;            NOTE: when facing the direction of ground track motion the
;            first array index of the alat and alon arrays are filled
;            from left to right.
;            
;  time      time offset at which a given line of data is obtained (hours)
;            The offset is respect to the time at which the first line
;            of data is returned.
;
;  swath     cross track swath width in km
;
;
; DISCUSSION:
;  This routine is not intended to give precise satellite coordinates,
;  rather it can be used to compute illustritive grids to test other
;  routines.  A circular orbit is assumed and the earth is allowed to
;  rotate during the period of the orbit.  In reality, NOAA polar
;  orbiters have an eccentricity of about 0.0011. This has a very
;  small impact on inter pixel spacing. The ordering of alat and alon
;  may need to be transposed, reversed or rotated to account for
;  satellite direction of motion i.e., ascending / descending node and
;  for details of how a given satellite orders its output.
;
; LIMITATIONS:
;  Should not be used to compute satelite ground track or data grids 
;  when high accuracy is required.
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE:  
;   
;;; show satellite ground track   
;
;   map_set,0,-120,/cyl,/cont,/grid
;   satgrid,0,200,alon,alat,lres=240.
;   oplot,alon,alat
;
;;; show sensor samples, color indicates array ordering (dark=>start)
;
;   loadct,5
;   color=(!d.n_colors*findgen(100)/100.) # replicate(1,600)
;
;   satgrid,100,600,alon,alat,lres=200,sres=16.5.,swath=swath
;   print,swath
;   plots,alon,alat,psym=3,color=color
;
;
; AUTHOR:   Paul Ricchiazzi                        20 Dec 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
; lon0=-125. & lat0=35 & nx=100 & ny=100 &  lres=240 & sres=10

if not keyword_set(lres) then lres=1.
if not keyword_set(sres) then sres=1.
if not keyword_set(lon0) then lon0=0.
if not keyword_set(lat0) then lat0=0.


re=6371.2

case 1 of 
  keyword_set(alt):    period=sqrt(1.9789*(1.+alt/re)^3)
  keyword_set(period): alt=re*(((period^2/1.9789)^.33333)-1.)
  else:begin         
                       alt=853.0
                       period=sqrt(1.9789*(1.+alt/re)^3)         
  end
endcase

vground=2*!pi*re/period             ; km/hour
dtline=lres/vground                 ; hours/line
dlonline=dtline*360./24.            ; degrees of earth rotation per line

if not keyword_set(inclin) then inclin=98.9127


alpha = 90.-inclin

if abs(lat0) gt 90-abs(alpha) then message,'latitude too high'

;
; alpha is the angle between satellite ground track velocity and due north
;
  
if keyword_set(descend) then alpha=180.-alpha

if lat0 ne 0. then begin
  t=findrng(-.999,.999,181)*!pi*re
  compass,0,lon0,t,alpha,slat,slon,/to_latlon
  lonoff=interpol(slon,slat,lat0)
  elon=lon0-lonoff
endif else begin
  elon=lon0
endelse
  

t=lres*findgen(ny)
compass,0.,elon,t,alpha,slat,slon,/to_latlon

if nx gt 1 then begin
  alat=fltarr(nx,ny)
  alon=fltarr(nx,ny)

  if keyword_set(dmsp) then begin
    rng=sres*(findgen(nx)-.5*nx)
  endif else begin
;
;   law of sines used to relate nadir angle at satelite to 
;   earth centered range angle  sin(nadir)/re = sin(gamma+nadir)/(re+h)
;
    xr=1.+alt/re
    nadrlim=asin(.999/xr)
    dnadr=(sres/alt) < (.999*2*nadrlim/(nx-1))
    nadr=dnadr*(findgen(nx)-.5*(nx-1))
    snadr=sin(nadr)
    sing=(xr*snadr)
    rng=re*(asin(sing)-nadr)
  endelse
  swath=rng(nx-1)-rng(0)
;
; law of sines which applies to angles on the surface of a sphere:
;   sin(a)/sin(A) = sin(b)/sin(B) = sin(c)/sin(C)
; use this to get cross track direction as a function of alpha and slat
;

  if keyword_set(descend) then begin
    az=asin(sin(!dtor*(180-alpha))/sin((slat-90)*!dtor))/!dtor-90
  endif else begin
    az=asin(sin(!dtor*alpha)/sin((90.-slat)*!dtor))/!dtor+90
  endelse
  
  ii=where(abs(slon-elon) gt 90.,nc)
  if nc gt 0 then az(ii)=360.-az(ii)
  
  for j=0,ny-1 do begin
    compass,slat(j),slon(j),rng,az(j),blat,blon,/to_latlon  
    alat(*,j)=blat
    alon(*,j)=blon-j*dlonline
  endfor
endif else begin
  alat=slat
  alon=slon-findgen(ny)*dlonline
endelse

time=findgen(ny)*dtline

end


