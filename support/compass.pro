 pro compass,lat0,lon0,uu,vv,uuu,vvv,to_latlon=to_latlon
;+
;ROUTINE:     compass
;
;USEAGE       compass, lat0,lon0,alat,alon,rng,az
;             compass, lat0,lon0,rng,az,alat,alon,/to_latlon
;
;PURPOSE:     Given the geographical coordinates of an array of points
;             on the on the earth's surface, compute the great-circle 
;             distance and compass heading from the central point.
;             Distances and azimuth angles about the central point are 
;             provided in KM and Degrees.  
;
;             If TO_LATLON is set, convert the specified range and
;             azimuth values to lat, lon coordinates
;
;INPUT:
;  lat0       geographic latitude (degrees) of central point
;  lon0       geographic longitude (degrees) of central point
; 
;INPUT/OUTPUT
;  alat       geographic latitudes
;
;  alon       geographic longitudes
;
;  rng        great circle distances (km) from (lat0,lon0) to (alat,alon)
;
;  az         azimuth angles (degrees), azimuth is measured clockwise
;             from due north (compass heading)
;
;KEYWORD INPUT:
; to_latlon   if set, rng, az input converted to lat, lon
;
;
;EXAMPLE:
;
;;; plot family of great circles passing though lat,lon=(0,0)
;
;  rng=findrng(0,2*!pi*6371.2,400)
;  map_set,/cyl,/cont,/grid
;  for az=0,90,15 do begin &$
;   compass,0,0,rng,az,alat,alon,/to_latlon & oplot,alon,alat & endfor
;  
;
;;; find the range and az of Janus Island from Palmer Station
;
;  lat0=-64.767 & lon0=-64.067 & alat=-64.78 & alon=-64.11
;  compass,lat0,lon0,alat,alon,rng,az
;  compass,lat0,lon0,rng,az,nlat,nlon,/to_latlon 
;  print,f='(6a13)','alat','alon','rng','az','nlat','nlon' &$
;  print,alat,alon,rng,az,nlat,nlon
;
;
;  author:  Paul Ricchiazzi                            jan93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
;-
re=6371.2
;

if keyword_set(to_latlon) then begin
  alat=90.-uu/(!dtor*re)
  alon=180-vv
  latp=lat0
  lonp=180.
endif else begin
  latp=lat0
  lonp=lon0
  alat=uu
  alon=vv
endelse

t0=double((90.-latp)*!dtor)
t1=double((90.-alat)*!dtor)
p0=double(lonp*!dtor)
p1=double(alon*!dtor)
zz=cos(t0)*cos(t1)+sin(t0)*sin(t1)*cos(p1-p0) > (-1.) < 1. 
xx=sin(t1)*sin(p1-p0)
yy=sin(t0)*cos(t1)-cos(t0)*sin(t1)*cos(p1-p0)
uuu=re*acos(zz)
vvv=uuu
vvv=atan(xx,yy)/!dtor
uuu=float(uuu)
vvv=float(vvv)
if keyword_set(to_latlon) then begin
  uuu=90.-uuu/(!dtor*re)
  vvv=lon0-vvv
endif
return
end


