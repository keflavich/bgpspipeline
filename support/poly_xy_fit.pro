 function poly_xy_fit,x,y,u,degree,ufit,usig
;+
; ROUTINE:          poly_xy_fit
;
; CALLING SEQUENCE:
;                   result=poly_xy_fit(x,y,u,degree)
;                   result=poly_xy_fit(x,y,u,degree,ufit)
; 
; PURPOSE:     Find the least square polynomial coefficients fitting the 
;              dependent variable u to the independent variables x and y.
;              The bivariate polynomial function of x and y is defined as
;              ufit=SUM [ k(i,j) * x^i * y^j ] (summed over i and j)
;
; INPUT:  
;  x           Vector of x independent variable
;  y           Vector of y independent variable
;  u           Vector of dependent variable
;  degree      2 element vector polynomial order.
;              The fitting polynomial will be of order DEGREE(0) in x
;              and of order DEGREE(1) in y
;
; OUTPUT:
;  result      Array of polynomial coefficients (can be used directly
;              in the companion procedure POLY_XY)
;
; Optional OUTPUT:
;  ufit        polynomial evaluated at x and y points
;  usig        standard deviation of (u-ufit)
;
;  author:  Paul Ricchiazzi                            1mar93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

if n_params() eq 0 then begin
  xhelp,'poly_xy'
  return,0
endif  

; on_error,2                      ;Return to caller if an error occurs

m = n_elements(x)

if (m ne n_elements(y)) or m ne n_elements(u) then $
		message,'Inconsistent number of elements.'
nx=degree(0)+1
ny=degree(1)+1
nxy=nx*ny
if nxy gt m then message, '# of points must be ge (degree_x+1)*(degree_y+1).'
;
coef=dblarr(nx*ny,nx*ny)
rhs=dblarr(nx*ny)
;
for iy=0,ny-1 do begin
  for ix=0,nx-1 do begin
    mind=ix+iy*nx
    rhs(mind)=total(u * x^ix * y^iy)
    for ixx=0,nx-1 do begin
      for iyy=0,ny-1 do begin
        nind=ixx+iyy*nx
        coef(nind,mind)=total(x^(ix+ixx) * y^(iy+iyy))
      endfor
    endfor
  endfor
endfor
;
k=invert(coef) # rhs
k=reform(k,nx,ny)

ufit=poly_xy(x,y,k)

usig=stdev((u-ufit))
return,k
end



