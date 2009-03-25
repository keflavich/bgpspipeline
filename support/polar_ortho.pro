 pro polar_ortho,alat,alon,outer_lat,xn,yn
;+
; routine          polar_ortho
; input:
;   alat           latitude array
;   alon           longitude array
;   outer_lat      outer latitude limit
;
; output:
;   xn       x coordinate to which (alat,alon) maps (normalized 0-1)
;   yn       y coordinate to which (alat,alon) maps (normalized 0-1)
;
; purpose:         use this map projection procedure with regrid.pro
;
; EXAMPLE:
;
;; polar projection
;  
;  window,/free,xs=400,ys=1000
;  !p.multi=[0,1,3]
;  latrng=[30,70] & lonrng=[-110,-70] & nnx=200 & nny=150
;  alon=(float(c)-min(float(c)))/(max(float(c))-min(float(c)))
;  alat=(imaginary(c)-min(imaginary(c)))/(max(imaginary(c))-min(imaginary(c)))
;  alon=lonrng(0)+(lonrng(1)-lonrng(0))*alon
;  alat=latrng(0)+(latrng(1)-latrng(0))*alat
;  im=sqrt(abs(sin(alon*!pi)*sin(alat*!pi)))^.3
;  tvim,im,/scale,title='image'
;  contour,alat,/overplot,levels=[40,60],thick=4,color=0
;  contour,alon,/overplot,levels=[-100,-80],thick=4,color=0
;
;  regrid,alat,alon,nnx,nny,kx,ky,proj='polar_ortho',extras=30,degree=2
;  imm=poly_2d(im,kx,ky,0,nnx,nny,missing=0)
;  tvim,imm,/scale,xr=[-5517,5517],yr=[5517,5517],title='regrided image, d=2'
;
;  regrid,alat,alon,nnx,nny,kx,ky,proj='polar_ortho',extras=30,degree=3
;  imm=poly_2d(im,kx,ky,0,nnx,nny,missing=0)
;  tvim,imm,/scale,xr=[-5517,5517],yr=[5517,5517],title='regrided image, d=3'
;  
; AUTHOR:       Paul Ricchiazzi    feb94 
;               Earth Space Research Group, UCSB
;-
xmax=cos(outer_lat*!dtor)
xmin=-xmax
ymax=xmax
ymin=xmin
if outer_lat gt 0 then begin
  xn=cos(alat*!dtor)*cos(alon*!dtor)
  yn=cos(alat*!dtor)*sin(alon*!dtor)
endif else begin
  xn=cos(alat*!dtor)*cos(-alon*!dtor)
  yn=cos(alat*!dtor)*sin(-alon*!dtor)
endelse
xn=(xn-xmin)/(xmax-xmin)       ; normalized coordinates
yn=(yn-ymin)/(ymax-ymin)

return 
end
;
