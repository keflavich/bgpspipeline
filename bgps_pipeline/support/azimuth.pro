function azimuth,image,dx,dy
;+
; ROUTINE:          azimuth
;
; PURPOSE:          given a smoothly varying 2d field, AZIMUTH
;                   computes the angle between the gradient direction
;                   of the field and the y direction (angle measured
;                   clockwise).  This is is useful for computing the
;                   satellite or solar azimuth angle when all you know
;                   are the satellite or solar zenith angles.  For
;                   example the relative azimuth at each point in a
;                   satellite image is given by
;
;                    relaz=abs(azimuth(satzen,1,1)-azimuth(-sunzen,1,1))
;
;                   which is the angle between the satellite unit
;                   vector and the solar ray vector, both projected
;                   onto the surface.
;
; CALLING SEQUENCE:
;                   result=azimuth(image,dx,dy)
; INPUT:
;    image          smoothly varying image quantity (e.g., solar zenith angle)
;    dx             pixel spacing, x direction
;    dy             pixel spacing, y direction
;
; OUTPUT:
;    result         angle between grad(image) and downward direction
;                   (angle increases clockwise) 
; 
; LIMITATION:       the image is fit by a quadratic function of x and y
;                   which is analytically differentiated to find the
;                   gradient directions.  An image which is not well
;                   approximated by a quadratic function may produce
;                   weird results.
;
;
; EXAMPLE:
;   f=cmplxgen(400,400,/center)
;   tvim,f,/scale
;   f=abs(f)^2      ; should be perfectly fit by a quadratic function
;   a=azimuth(f,1,1)
;   loadct,5
;   tvim,a,scale=2,range=[-180,180,45]
;
;  author:  Paul Ricchiazzi                            apr94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara


;-
sz=size(image) & nx=sz(1) & ny=sz(2)

nn=10

im=congrid(image,nn,nn,/minus_one)
x=findgen(nn)*dx
y=findgen(nn)*dy
gengrid,x,y
kk=poly_xy_fit(x,y,im,[2,2])
;
;    im=sum(kk(i,j)*x^i*y^j)
;
dimdx=fltarr(nn,nn)
dimdy=fltarr(nn,nn)
for j=0,2 do for i=1,2 do dimdx=dimdx+kk(i,j)*i*x^(i-1)*y^j
for j=1,2 do for i=0,2 do dimdy=dimdy+kk(i,j)*j*x^i*y^(j-1)

denom=sqrt(dimdx^2+dimdy^2)
ux=congrid(dimdx/denom,nx,ny,/minus_one,/interp)
uy=congrid(dimdy/denom,nx,ny,/minus_one,/interp)
return,atan(ux,uy)/!dtor

end


