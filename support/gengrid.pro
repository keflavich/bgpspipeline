 pro gengrid,a0,a1,a2,a3,a4
;+
; ROUTINE      gengrid
; USEAGE       gengrid,a0,a1,a2,a3,a4
; PURPOSE      convert the input quantities from vectors to arrays
;              of dimension (nn0,nn1,nn2,nn3,nn4) where nn0=n_elements(a0),
;              etc. 
;
;                 a0(i) => a0(i,*,*,*,*) for i=0,nn0-1
;                 a1(i) => a1(*,i,*,*,*) for i=0,nn1-1
;                 a2(i) => a2(*,*,i,*,*) for i=0,nn2-1
;                 a3(i) => a3(*,*,*,i,*) for i=0,nn3-1
;                 a4(i) => a4(*,*,*,*,i) for i=0,nn4-1
;
; INPUT:
;   a0         input vector or scalor array size of the first index
;   a1         input vector or scalor array size of the second index
;   a2         input vector or scalor array size of the third index
;   a3         input vector or scalor array size of the fourth index
;   a4         input vector or scalor array size of the fifth index
;
;              if one of these arguments is set to a scalor, then that
;              value is used to set the dimension of corresponding 
;              array subscript
;
; EXAMPLE:    
;              a0=[1,2,3,4,5]
;              a1=[10,20,30]
;              gengrid,a0,a1
;              print,a0
;              
;                         1  2  3  4  5
;                         1  2  3  4  5
;                         1  2  3  4  5
;              print,a1
;                        10 10 10 10 10
;                        20 20 20 20 20
;                        30 30 30 30 30
;
;              here are some other examples:
;
;              ;turn a 5 element vector into a 5x6 array
;
;              x=findgen(3)
;              gengrid,x,6
;              print,x
;
;                   0.00000      1.00000      2.00000
;                   0.00000      1.00000      2.00000
;                   0.00000      1.00000      2.00000
;                   0.00000      1.00000      2.00000
;                   0.00000      1.00000      2.00000
;                   0.00000      1.00000      2.00000
;
;              ;turn a 5 element vector into a 6x5 array
;
;              x=findgen(3)
;              gengrid,4,x
;              print,x
;
;		    0.00000      0.00000      0.00000      0.00000 
;		    1.00000      1.00000      1.00000      1.00000 
;		    2.00000      2.00000      2.00000      2.00000 
;               
;
;  author:  Paul Ricchiazzi                            mar93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

if n_params() eq 0 then begin
  xhelp,'gengrid'
  return
endif  

nn0=n_elements(a0) 
nn1=n_elements(a1) 
nn2=n_elements(a2) 
nn3=n_elements(a3) 
nn4=n_elements(a4) 

if nn0 ne 0 then if (size(a0))(0) eq 0  then nn0=-(abs(a0))(0)
if nn1 ne 0 then if (size(a1))(0) eq 0  then nn1=-(abs(a1))(0)
if nn2 ne 0 then if (size(a2))(0) eq 0  then nn2=-(abs(a2))(0)
if nn3 ne 0 then if (size(a3))(0) eq 0  then nn3=-(abs(a3))(0)
if nn4 ne 0 then if (size(a4))(0) eq 0  then nn4=-(abs(a4))(0)

n0=long(abs(nn0))
n1=long(abs(nn1))
n2=long(abs(nn2))
n3=long(abs(nn3))
n4=long(abs(nn4))

nn=n0*n1

if nn eq 0 then return

if nn2 ne 0 then nn=nn*n2
if nn3 ne 0 then nn=nn*n3
if nn4 ne 0 then nn=nn*n4

ii=lindgen(nn)
if nn0 gt 0 then a0=a0(ii mod n0)
if nn1 gt 0 then a1=a1((ii/n0) mod n1)
if nn2 gt 0 then a2=a2((ii/(n0*n1)) mod n2)
if nn3 gt 0 then a3=a3((ii/(n0*n1*n2)) mod n3)
if nn4 gt 0 then a4=a4(ii/(n0*n1*n2*n3))

case 1 of 
n4 ne 0: begin
	if nn0 gt 0 then a0=reform(a0,n0,n1,n2,n3,n4)
	if nn1 gt 0 then a1=reform(a1,n0,n1,n2,n3,n4)
	if nn2 gt 0 then a2=reform(a2,n0,n1,n2,n3,n4)
	if nn3 gt 0 then a3=reform(a3,n0,n1,n2,n3,n4)
	if nn4 gt 0 then a4=reform(a4,n0,n1,n2,n3,n4)
        end
nn3 ne 0: begin
	if nn0 gt 0 then a0=reform(a0,n0,n1,n2,n3)
	if nn1 gt 0 then a1=reform(a1,n0,n1,n2,n3)
	if nn2 gt 0 then a2=reform(a2,n0,n1,n2,n3)
	if nn3 gt 0 then a3=reform(a3,n0,n1,n2,n3)
          end
nn2 ne 0: begin
	if nn0 gt 0 then a0=reform(a0,n0,n1,n2)
	if nn1 gt 0 then a1=reform(a1,n0,n1,n2)
	if nn2 gt 0 then a2=reform(a2,n0,n1,n2)
          end
else:     begin
	if nn0 gt 0 then a0=reform(a0,n0,n1)
	if nn1 gt 0 then a1=reform(a1,n0,n1)
          end
endcase

end



