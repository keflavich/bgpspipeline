 function poly_xyz_fit,x,y,z,u,degree,ufit
;+
; ROUTINE:          poly_xyz_fit
;
; CALLING SEQUENCE:
;                   result=poly_xyz_fit(x,y,z,u,degree)
;                   result=poly_xyz_fit(x,y,z,u,degree,ufit)
; 
; PURPOSE:     Find the least square polynomial coefficients fitting the 
;              dependent variable u to three independent variables x,y and z.
;              The trivariate polynomial function of x,y,z is defined as
;              ufit=SUM [ k(i,j,k) * x^i * y^j * z^k] (summed over i,j and k)
;
; INPUT:  
;  x           Vector of x values (independent variable)
;  y           Vector of y values (independent variable)
;  z           Vector of z values (independent variable)
;  u           vector of u values (dependent variable)
;  degree      3 element vector specifying polynomial order.
;              The fitting polynomial will be of order DEGREE(0) in x
;              DEGREE(1) in y and DEGREE(2) in z
;
; OUTPUT:
;  result      Array of polynomial coefficients (can be used directly
;              in the companion procedure POLY_XYZ)
;
; Optional OUTPUT:
;  ufit        polynomial evaluated at (x,y,z) input points
;
;  author:  Paul Ricchiazzi                            1mar93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
; on_error,2                      ;Return to caller if an error occurs


if n_params() eq 0 then begin
  xhelp,'poly_xyz_fit'
  return,0
endif  

m = n_elements(x)		  ;# of points..

if (m ne n_elements(y)) or m ne n_elements(z) or m ne n_elements(u) then $
		message,'Inconsistent number of elements.'

nx=degree(0)+1
ny=degree(1)+1
nz=degree(2)+1
nxyz=nx*ny*nz

if nxyz gt m then $
  message, '# of points must be ge (degree_x+1)*(degree_y+1)*(degree_z+1).'

coef=dblarr(nxyz,nxyz)
rhs=dblarr(nxyz)


for iz=0,nz-1 do begin
  for iy=0,ny-1 do begin
    for ix=0,nx-1 do begin
      mind=ix+iy*nx+iz*nx*ny
      rhs(mind)=total(u * x^ix * y^iy * z^iz)
      for izz=0,nz-1 do begin
	for iyy=0,ny-1 do begin
	  for ixx=0,nx-1 do begin
	    nind=ixx+iyy*nx+izz*nx*ny
	    coef(nind,mind)=total(x^(ix+ixx) * y^(iy+iyy) * z^(iz+izz))
	  endfor
	endfor
      endfor
    endfor
  endfor
endfor
;
k=invert(coef) # rhs
k=reform(k,nx,ny,nz)

ufit=poly_xyz(x,y,z,k)

return,k
end

