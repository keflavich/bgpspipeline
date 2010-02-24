pro sunglint,doy,time,lat,lon,alt,glat,glon,gnadir,gaz
;+
; ROUTINE:	sunglint
;
; PURPOSE:	compute lat-lon of point on earths surface which will
;               reflect sunlight to satellite observation point by 
;               purely specular reflection.
;
; USEAGE:	sunglint,doy,time,lat,lon,alt,glat,glon
;
; INPUT:
;
;   doy		day of year              (scalor)
;   time	time UTC (hours)         (scalor)
;   lat         satellite latitude       (scalor)
;   lon         satellite longitude      (scalor)
;   alt         satellite altitude       (scalor)
;
; OUTPUT
;
;   glat        sunglint latitude
;   glon        sunglint longitude
;   gnadir      sunglint nadir angle
;   gaz         sunglint azimuth
;               
;               if satellite is on the night side 
;               glat and glon are returned as 1000,1000
; 
;   if parameters GLAT, GLON, GNADIR and GAZ are left off the argument
;   list then SUNGLINT prints these parameters to the terminal
;
;
; KEYWORD INPUT:
;
;  
; EXAMPLE:	
;
; sunglint,129,21.5,25,-120,800,glat,glon,gnadir,gaz
; print,f='(4f10.2)',glat,glon,gnadir,gaz
;
; sunglint,80,12,90.0,0,1000              ; sunlat =0 sunlon=0
; sunglint,80,12,90.0,0,10000             ;   note how glat approaches
; sunglint,80,12,90.0,0,100000            ;   45 at alt is increased
; sunglint,80,12,90.0,0,1000000           ; 

;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                           dec 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
; if satellite is at theta=0 and sun is at theta=thetasun, then the
; reflection angle, alpha (which is zenith angle of reflected ray at
; reflection point) is equal to
;
;                          sin(theta)
;       alpha = atan ( -------------------)    (comes from law of sines)
;                         cos(theta)-xx
;
; The glint angle is found by setting theta+alpha=thetasun.
; Using the cosine angle sum formula, cos(a+b)=cos(a)*cos(b)-sin(a)*sin(b)
; we derive:
;
;       2mu^2-xx*mu-1
;   -------------------      = mu0
;   sqrt(1-2*mu*xx+xx^2)
;
;  where mu       = cos(theta),
;        theta    = earth centered angle between satellite and glint point
;        xx       = re/(re+h)
;        mu0      = cos(thetasun)
;        thetasun = earth centered angle between satellite and sun
;
;
; sunglint,129,21.5,25,-120,800,glat,glon,gnadir,gaz
; doy=129 & time=21.5 & lat=25 & lon=-120 & alt=800
; doy=80  & time=12   & lat=0. & lon=0.   & alt=1000000000000.
;

zensun,doy,time,lat,lon,z,gaz,latsun=latsun,lonsun=lonsun
compass,lat,lon,latsun,lonsun,rng,az
thetasun=rng/(6371.2*!dtor)
h=alt/6371.2
xx=1./(1.+h)

if thetasun gt 90+acos(xx)/!dtor then begin
  glat=1000
  glon=1000
  gnadir=1000
  gaz=1000
  return
endif

mu=cos(findrng([0,.51*thetasun],1000)*!dtor)
f1=2*mu^2-xx*mu-1
f2=sqrt(1.-2*mu*xx+xx^2)
func=f1/f2-cos(thetasun*!dtor)
  ; plot,mu,func,/xstyle & oplot,[0,180],[0,0]

ii=where(func*shift(func,-1) lt 0,nc)
if nc eq 0 then message,'no solution'
ii=ii(0)
muse=interpol(mu(ii:ii+1),func(ii:ii+1),0)
amuse=acos(muse)
glintrng=amuse*6371.
theta=amuse/!dtor
  
compass,lat,lon,glintrng,az,glat,glon,/to_latlon
gnadir=thetasun-2*theta


if n_elements(glat) eq 1 then begin
  glat=glat(0)
  glon=glon(0)
endif
if n_params() lt 7 then begin
  print,f='(4a10)','glat','glon','gnadir','gaz'
  print,f='(4f10.2)',glat,glon,gnadir,gaz
endif
end




