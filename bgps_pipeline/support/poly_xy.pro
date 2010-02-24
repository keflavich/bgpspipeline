 function poly_xy,x,y,k,verify=verify

;+
; ROUTINE:          poly_xy
;
; CALLING SEQUENCE:
;                   RESULT=POLY_XY(X,Y,K)
; 
; PURPOSE:     Evaluate the bivariate polynomial function of x and y
;              where poly_xy = SUM [ k(i,j) * x^i * y^j ]
;              the sum extends over i and j
;
; INPUT:  x    Vector of x values
;         y    Vector of y values
;         k    Array of polynomial coefficients (as computed by the
;              the companion procedure POLY_XY_FIT.PRO)
;
;  author:  Paul Ricchiazzi                            1mar93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

if n_params() eq 0 then begin
  xhelp,'poly_xy'
  return,0
endif  

nn=size(k)
nx=nn(1)
ny=nn(2)
;
sum=0
for j=0,ny-1 do for i=0,nx-1 do sum=sum+k(i,j)*x^i*y^j
return,sum
end





