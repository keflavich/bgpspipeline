pro locate,lat,lon,alat,alon,x,y
;+
; ROUTINE:     locate
; 
; USEAGE:      locate,lat,lon,alat,alon,x,y
;
; PURPOSE:     
;    This routine is used by COASTLINE to find the array indices 
;    of a given geographical point within irregular latitude and
;    longitude arrays.  Given the coordinate arrays alat(i,j) and
;    alon(i,j), LOCATE finds the "floating point" indices x,y such
;    that,
;
;            interpolate(alat,x,y)=lat 
;            interpolate(alon,x,y)=lon 
;
;    Stated more abstractly, LOCATE solves two simultaneous non-linear
;    equations of the form
;    
;            f(x,y)=u
;            g(x,y)=v
;    
;    where the functions f and g are actually arrays of values
;    indexed by x and y.
;              
; INPUT:
;    lat       a vector of geographic latitudes 
;    lon       a vector of geographic longitudes
;    alat      array of image latitudes 
;    alon      array of image longitudes
; OUTPUT:
;    x,y       "floating point" array indicies such that 
;
;                  lat=interpolate(alat,x,y)
;
;                  lon=interpolate(alon,x,y)
;
; EXAMPLE:
;
; c=(cmplxgen(100,100)+complex(20,20))/50 & c=c+c^2+c^3
; alon=imaginary(c) & alat=float(c)
; !p.multi=[0,1,2]
; xo=fix(54+(20+25*(findgen(21) mod 2))*cos(2*!pi*findgen(21)/20))
; yo=fix(54+(20+25*(findgen(21) mod 2))*sin(2*!pi*findgen(21)/20))
; lon=alon(xo,yo)       & lat=alat(xo,yo)
; plot,alon,alat,/noda,ytit='latitude',xtit='longitude',/xstyle,/ystyle
; oplot,alon,alat,psym=3
; oplot,lon,lat,psym=-4
; delvar,x,y
; locate,lat,lon,alat,alon,x,y
; contour,alat,levels=contlev(alat,maxlev=30),/follow,c_color=150
; contour,alon,levels=contlev(alon,maxlev=30),/follow,/over,c_color=80
; oplot,x,y,psym=-4
; table,lat,interpolate(alat,x,y),lon,interpolate(alon,x,y),x,xo,y,yo
;
;
; DISCUSSION:
;    LOCATE uses Newton-Raphson iteration of the linearized equations
;    for latitude and longitude.  The equation is itereated repeatedly
;    only for those elements of the input vectors which have not
;    satisfied the convergence criterion, 
;
;             (lat-alati)^2+(lon-aloni)^2 lt (.001)^2
;
;    where alati and aloni are the values of ALAT and ALON interpolated
;    to the current estimates of X and Y.  This procedure will probably
;    fail if the gradients of ALAT and ALON arrays do not form linearly
;    independent vector fields.  You have trouble if somewhere in
;    the grid grad(ALAT) is proportional to grad(alon)
;
; AUTHOR:      Paul Ricchiazzi             oct92 
;              Earth Space Research Group, UCSB
; 
;
; REVISIONS:
; 27oct92   Provide default initial guesses for x and y. This allows the
;           user to call LOCATE without pre-defining x and y.
; 12jun95   allow LOCATE to accept a vectors of LAT-LON points, improves speed
;           
;           
;-
sz=size(alat)
nxm=sz(1)-1
nym=sz(2)-1

; derivatives of latitude and longitude with respect to x and y

dadx=.5*(shift(alat,-1,0)-shift(alat,1,0))
dady=.5*(shift(alat,0,-1)-shift(alat,0,1))
dodx=.5*(shift(alon,-1,0)-shift(alon,1,0))
dody=.5*(shift(alon,0,-1)-shift(alon,0,1))

dadx(0,*)=alat(1,*)-alat(0,*)
dadx(nxm,*)=alat(nxm,*)-alat(nxm-1,*)
dady(*,0)=alat(*,1)-alat(*,0)
dady(*,nym)=alat(*,nym)-alat(*,nym-1)

dodx(0,*)=alon(1,*)-alon(0,*)
dodx(nxm,*)=alon(nxm,*)-alon(nxm-1,*)
dody(*,0)=alon(*,1)-alon(*,0)
dody(*,nym)=alon(*,nym)-alon(*,nym-1)

mxdadx=max(dadx,min=mndadx)
mxdodx=max(dodx,min=mndodx)
mxdady=max(dady,min=mndady)
mxdody=max(dody,min=mndody)

warning='WARNING from LOCATE: '
if mxdadx*mndadx le 0. then print,warning+'ALAT not monitonic in x'
if mxdodx*mndodx le 0. then print,warning+'ALON not monitonic in x'
if mxdady*mndady le 0. then print,warning+'ALAT not monitonic in y'
if mxdody*mndody le 0. then print,warning+'ALON not monitonic in y'

nn=n_elements(lat)
if keyword_set(x) eq 0 then x=replicate(float(nxm/2),nn)
if keyword_set(y) eq 0 then y=replicate(float(nym/2),nn)
x=(x > 0) < (nxm-1)
y=(y > 0) < (nym-1)

maxiter=20
loop=0
ii=lindgen(nn)
test=fltarr(nn)
tol=.001
nleft=nn
repeat begin

  xo=x(ii)
  yo=y(ii)

; interpolate to point xo,yo,  extrapolate if xo,yo out of range

  ixo=floor(xo)>0<(nxm-1)
  iyo=floor(yo)>0<(nym-1)
  fx=xo-ixo
  fy=yo-iyo
 
; interpolate derivatives of latitude and longitude

  dadxi=(1.-fy)*((1.-fx)*dadx(ixo,iyo)  +fx*dadx(ixo+1,iyo))+ $
             fy*((1.-fx)*dadx(ixo,iyo+1)+fx*dadx(ixo+1,iyo+1))
  dadyi=(1.-fy)*((1.-fx)*dady(ixo,iyo)  +fx*dady(ixo+1,iyo))+ $
             fy*((1.-fx)*dady(ixo,iyo+1)+fx*dady(ixo+1,iyo+1))
  dodxi=(1.-fy)*((1.-fx)*dodx(ixo,iyo)  +fx*dodx(ixo+1,iyo))+ $
             fy*((1.-fx)*dodx(ixo,iyo+1)+fx*dodx(ixo+1,iyo+1))
  dodyi=(1.-fy)*((1.-fx)*dody(ixo,iyo)  +fx*dody(ixo+1,iyo))+ $
             fy*((1.-fx)*dody(ixo,iyo+1)+fx*dody(ixo+1,iyo+1))

; interpolate alat and alon to point xo,yo

  alati=(1.-fy)*((1.-fx)*alat(ixo,iyo)  +fx*alat(ixo+1,iyo))+ $
             fy*((1.-fx)*alat(ixo,iyo+1)+fx*alat(ixo+1,iyo+1))
  aloni=(1.-fy)*((1.-fx)*alon(ixo,iyo)  +fx*alon(ixo+1,iyo))+ $
             fy*((1.-fx)*alon(ixo,iyo+1)+fx*alon(ixo+1,iyo+1))

  denom=dadxi*dodyi-dodxi*dadyi

; new guess for x and y (solution of linearized equation)

  x(ii)=xo+((lat(ii)-alati)*dodyi-(lon(ii)-aloni)*dadyi)/denom
  y(ii)=yo-((lat(ii)-alati)*dodxi-(lon(ii)-aloni)*dadxi)/denom

  test(ii)=(x(ii)-xo)^2+(y(ii)-yo)^2

  ;if nleft gt 0 then begin
  ;  print,nleft
  ;  jj=ii(0:10<(nleft-1))
  ;  print,f='(a,11i11)'  ,'ii:     ',jj
  ;  print,f='(a,11f11.4)','test:   ',test(jj)
  ;  print,f='(a,11f11.4)','x:      ',x(jj)
  ;  print,f='(a,11f11.4)','xo:     ',xo(0:10<(nleft-1))
  ;  print,f='(a,11f11.4)','y:      ',y(jj)
  ;  print,f='(a,11f11.4)','yo:     ',yo(0:10<(nleft-1))
  ;  print,f='(a,11f11.4)','alati:  ',alati(0:10<(nleft-1))
  ;  print,f='(a,11f11.4)','lat:    ',lat(jj)
  ;  print,f='(a,11f11.4)','aloni:  ',aloni(0:10<(nleft-1))
  ;  print,f='(a,11f11.4)','lon:    ',lon(jj)
  ;  stop
  ;endif

  ii=where(test gt tol^2,nleft)           ; find non-converged elements
  loop=loop+1
  

endrep until nleft eq 0 or loop eq maxiter

return 
end












