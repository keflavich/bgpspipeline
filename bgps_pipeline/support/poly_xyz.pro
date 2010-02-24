 function poly_xyz,x,y,z,k,verify=verify

;+
; ROUTINE:          poly_xyz
;
; CALLING SEQUENCE:
;                   RESULT=POLY_XY(X,Y,Z,K)
; 
; PURPOSE:     Evaluate the trivariate polynomial function of x,y,z
;              where poly_xyz = SUM [ k(i,j,k) * x^i * y^j * z^k]
;              the sum extends over i,j,k
;
; INPUT:  x    Vector of x independent variable
;         y    Vector of y independent variable
;         z    Vector of z independent variable
;         k    Array of polynomial coefficients (as computed by the
;              the companion procedure POLY_XYZ_FIT.PRO)
;
;  author:  Paul Ricchiazzi                            1mar93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

if n_params() eq 0 then begin
  xhelp,'poly_xyz'
  return,0
endif  

nn=size(k)
nx=nn(1)
ny=nn(2)
nz=nn(3)
;
sum=0.

for iz=0,nz-1 do begin
  for iy=0,ny-1 do begin
    for ix=0,nx-1 do begin
      sum=sum+k(ix,iy,iz) * x^ix * y^iy * z^iz
    endfor
  endfor
endfor
if keyword_set(verify) then begin
  for iy=0,ny-1 do begin
    for ix=0,nx-1 do begin
      print,form='(f4.2,a,i1,a,i1)',k(ix,iy),' *  x^',ix,' *  y^',iy
    endfor
  endfor
endif
return,sum
end





