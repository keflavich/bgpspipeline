 pro regrid,alat,alon,latrng=latrng,lonrng=lonrng,nsamp=nsamp,nnx,nny,kx,ky,$
            projection_name=proj,extras=extras,degree=degree

;+
; ROUTINE: regrid,alat,alon,latrng=latrng,lonrng=lonrng,nnx,nny,kx,ky
; PURPOSE: Find polynomial coeffients to warp an irregular grid into
;          a regular grid.  
;
; INPUT:   
;  alat    array of pixel latitudes
;  alon    array of pixel longitudes
;  nnx     number of pixels in x direction of output array
;  nny     number of pixels in y direction of output array
;
; OPTIONAL KEYWORD INPUT:
;  latrng  range of output latitudes (default = [min(alat),max(alat)] )
;          not used when projection_name is set
;
;  lonrng  range of output longitudes (default = [min(alon),max(alon)] )
;          not used when projection_name is set
;
;  nsamp   number of sample points from which to
;          generate warping polynomial (default = 400)
;
;  degree  the degree of the warping polynomial (default = 2)
;
;  extras  extra parameters (single value, array or structure) used in
;          the user supplied projection procedure.  The defininition of 
;          extras is completely up to the user.
;
;  projection_name:
;          The name of the user supplied procedure which computes the
;          map projection.  if projection_name is not supplied a
;          cylindrical projection is assumed.  The user supplied
;          procedure must accept as arguments alat,alon,extras and
;          return the normalized coordinates xnorm,ynorm which show
;          where a given lat,lon map to on a unit grid.  Here is an
;          example for polar orthographic projection.
;
;            pro polar_orthographic,alat,alon,extras,xn,yn
;            outer_lat=extras(0)             ; the outer latitude limit
;            xmax=cos(outer_lat*!dtor)
;            xmin=-xmax
;            ymax=xmax
;            ymin=xmin
;            if outer_lat gt 0 then begin
;              xn=cos(alat*!dtor)*cos(alon*!dtor)
;              yn=cos(alat*!dtor)*sin(alon*!dtor)
;            endif else begin
;              xn=cos(alat*!dtor)*cos(-alon*!dtor)
;              yn=cos(alat*!dtor)*sin(-alon*!dtor)
;            endelse
;            xn=(xn-xmin)/(xmax-xmin)       ; normalized coordinates
;            yn=(yn-ymin)/(ymax-ymin)
;            
;            return 
;            end
;
; OUTPUT:
;  kx      polynomial coefficients relating indecies xold to (xnew,ynew)
;  ky      polynomial coefficients relating indecies yold to (xnew,ynew)
;
; COMMON BLOCKS:   NONE
; SIDE EFFECTS:    NONE
;
;
; PROCEDURE:    Use together with POLY_2D to warp images to regular lat,lon
;               grid.  
;
; EXAMPLE:
;
;  c=complex(2,2)+cmplxgen(250,200,/center)/100         ; create alat & alon
;  c=c+c^2
;  alon=float(c)-100
;  alat=20+imaginary(c)
;  im=sqrt(abs(sin(alon*!pi)*sin(alat*!pi)))^.3 
;  !p.multi=[0,1,2]                               
;  window,/free,xs=400,ys=600                           ; create new window
;  tvim,im,/scale,title='image'
;  latrng=[28,34] & lonrng=[-100,-95] & nnx=200 & nny=150
;  contour,alat,/overplot,levels=latrng,thick=4,color=0
;  contour,alon,/overplot,levels=lonrng,thick=4,color=0
;
;; regrid and display 
;
;  regrid,alat,alon,latrng=latrng,lonrng=lonrng,nnx,nny,kx,ky
;  imm=poly_2d(im,kx,ky,0,nnx,nny,missing=0)
;  tvim,imm,/scale,xr=lonrng,yr=latrng,title='regrided image'
;
; 
;; polar projection
;  
;  window,/free,xs=400,ys=1000
;  !p.multi=[0,1,3]
;  c=complex(2,2)+cmplxgen(128,128,/center)/100         ; create alat & alon
;  c=c+c^2
;  latrng=[30,70] & lonrng=[-110,-70] & nnx=200 & nny=200
;  alon=(float(c)-min(float(c)))/(max(float(c))-min(float(c)))
;  alat=(imaginary(c)-min(imaginary(c)))/(max(imaginary(c))-min(imaginary(c)))
;  alon=lonrng(0)+(lonrng(1)-lonrng(0))*alon
;  alat=latrng(0)+(latrng(1)-latrng(0))*alat
;  im=randata(128,128,s=4) gt 2
;  tvim,im,/scale,title='image'
;  tvlct,[0,255,0],[0,0,0],[0,0,255]
;  contour,alat,/overplot,levels=[40,50,60],thick=4,color=1
;  contour,alon,/overplot,levels=[-100,-90,-80],thick=4,color=2
;  
;  regrid,alat,alon,nnx,nny,kx,ky,proj='polar_ortho',extras=30,degree=2
;  imm=poly_2d(im,kx,ky,0,nnx,nny,missing=0)
;  tvim,imm,/scale,xr=[-5517,5517],yr=[-5517,5517],title='regrided image, d=2'
;  r=cos([40,50,60]*!dtor)*6371
;  a=(-70-indgen(41))*!dtor
;  for i=0,2 do oplot,r(i)*cos(a),r(i)*sin(a),color=1
;  
;  a=[-100,-90,-80]*!dtor
;  for i=0,2 do oplot,5517*[0,cos(a(i))],5517*[0,sin(a(i))],color=2
;
; NOTE: the bogus stuff in the upper half plane of the tvim image is
;       due to the use of the polynomial expansion outside the range
;       for which the fit is valid.  This only happens when the new
;       grid extends far beyond the limits of the original irregular
;       grid.  
;       
;  
;  author:  Paul Ricchiazzi                            ESRG
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
;-
sz=size(alat)
nx=sz(1)
ny=sz(2)
if keyword_set(nsamp) eq 0 then nsamp=400
;
if keyword_set(nnx) eq 0 then nnx=nx
if keyword_set(nny) eq 0 then nny=ny

nsx=sqrt(nsamp) < nx
nsy=nsx < ny

xi=indgen(nsx)*(nx-1)/(nsx-1)                             ; subscript into
yi=indgen(nsy)*(ny-1)/(nsy-1)                             ;  irregular grid
gengrid,xi,yi
lat=alat(xi,yi)
lon=alon(xi,yi)

if keyword_set(proj) then begin
  call_procedure, proj,lat,lon,extras,xnorm,ynorm
endif else begin
  xnorm=(lon-lonrng(0))/(lonrng(1)-lonrng(0))
  ynorm=(lat-latrng(0))/(latrng(1)-latrng(0))
endelse

ii=where(xnorm ge 0 and xnorm le 1 and ynorm ge 0 and ynorm le 1, nn)
if nn gt 0 then begin

  xo=(nnx-1)*xnorm
  yo=(nny-1)*ynorm
  xi=xi(ii)
  yi=yi(ii)
  xo=xo(ii)
  yo=yo(ii)
  if not keyword_set(degree) then degree=2
  polywarp,xi,yi,xo,yo,degree,kx,ky

;  xi=poly_2d(x0,y0,kx) ; subscripts into irregular (alat,alon) grid 
;  yi=poly_2d(x0,y0,ky)

endif else begin
  kx=0
  ky=0
endelse

return
end






