 pro fill_arr,a,ii,niter=niter,omega=omega,tol=tol,po=po
;+
; ROUTINE:          fill_arr
; 
; USEAGE:           fill_arr,a,ii
;                   fill_arr,a,ii,niter=niter,omega=omega,tol=tol,po=po
;
; PURPOSE:          fill in undefined regions of a 2-d array by interpolation
;
; INPUT:
;       a           array with some undefined points
;       ii          index array of good image points, 
;                   E.G., ii=where(aa ne 999)
; KEYWORD INPUT
;       tol         maximum tolerance to achieve before stopping iteration
;                   (default=0.001)
;       niter       number of smoothing iterations (default=100)
;       po          if set print diagnostic print out every PO iterations
;
; OUTPUT:
;       a           image array with initially undefined points replaced
;                   with values that vary smoothly in all dimensions
;                   Initially defined points are unchanged.
;
; PROCEDURE:        repeat this sequence
;
;                   
;                   asave=a(ii)
;                   a=smooth(a,3)
;                   a(ii)=asave                   
;
; AUTHOR            Paul Ricchiazzi               29oct92
;                   Earth Space Research Group    UCSB
;-
if keyword_set(niter) eq 0 then niter=100
if keyword_set(tol) eq 0 then tol=.00001

sz=size(a)
nx=sz(1)
ny=sz(2)
nz=sz(3)

asave=a
test=total(a^2)
iter=0
repeat begin
  otest=test
  iter=iter+1
  a=smooth(a,3)
  a(ii)=asave(ii)
  test=total(a^2)
  print,iter,otest,test
endrep until test-otest lt tol*otest or iter gt niter
end
