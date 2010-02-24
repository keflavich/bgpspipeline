pro loopind,n1,i1,n2,i2,n3,i3,n4,i4,n5,i5,n6,i6,ind=ind
;+
; ROUTINE:  loopind
;
; PURPOSE:  evaluate a sequence of nested indicies
;
; USEAGE:   loopind,ii,n1,i1,n2,i2,n3,i3,n4,i4,n5,i5,n6,i6
;
; INPUT:    
;   n1      number of elements in first dimension
;   n2      number of elements in second dimension
;
;   etc
;
; keyword input:
;   ind     one dimensional index.  If this keyword is set, evaluate
;           i1,i2... only for the elements contained in IND
; OUTPUT:
;   i1      index for first dimension
;   i2      index for second dimension
;   etc
;  
; EXAMPLE:  
;
;  loopind,4,i1,5,i2,2,i3
;  f=randomn(iseed,4,5,2)
;  table,i1,i2,i3,f
;
; AUTHOR:   Paul Ricchiazzi                        22 Sep 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

if n_elements(n1) eq 0 then n1=1
if n_elements(n2) eq 0 then n2=1
if n_elements(n3) eq 0 then n3=1
if n_elements(n4) eq 0 then n4=1
if n_elements(n5) eq 0 then n5=1
if n_elements(n6) eq 0 then n6=1

if n_elements(ind) ne 0 then ii=ind else ii=lindgen(n1*n2*n3*n4*n5*n6)

i1=ii mod n1 
i2=(ii/n1) mod n2 
i3=(ii/(n1*n2)) mod n3 
i4=(ii/(n1*n2*n3)) mod n4 
i5=(ii/(n1*n2*n3*n4)) mod n5 
i6=(ii/(n1*n2*n3*n4*n5)) mod n6 

return
end
