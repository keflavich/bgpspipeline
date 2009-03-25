 function expint,ind,x
;+
; ROUTINE:       expint
;
; PURPOSE:       compute the exponential integral of x.
;                the exponential integral of index n is given by
; 
;                    integral( exp(-tx)/x^n dx)  
;
;                range of integration is 1 to infinity
;
; USEAGE:        result=expint(ind,x)
;
; INPUT:
;   ind          order of exponential integral, for example use ind=1
;                to get first exponential integral, E1(x)
;   x            argument to exponential integral ( 0 < x < infinity)
; OUTPUT:
;   result       exponential integral
;
; SOURCE:        Approximation formula from Abromowitz and Stegun (p 231)
;
;  author:  Paul Ricchiazzi                            9DEC92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
a=[ 0.2677737343, 8.6347608925,18.0590169730, 8.5733287401, 1.0000000000]
b=[ 3.9584969228,21.0996530827,25.6329561486, 9.5733223454, 1.0000000000]
c=[-0.57721566, 0.99999193, -0.24991055,  0.05519968, -0.00976004, 0.00107857]
;
if ind le 0 then message,'illegal value of ind'
;
ei=x
ei(*)=0.
ii=where(x le 1.,ni)
if ni gt 0 then ei(ii)=-alog(x(ii))+poly(x(ii),c)
jj=where(x gt 1.,nj)
if nj gt 0 then ei(jj)=exp(-x(jj))*poly(x(jj),a)/(x(jj)*poly(x(jj),b))
;
; use recursion relation to get higher order exponential integrals
;
for n=1,ind-1 do ei=(exp(-x)-x*ei)/n 
return,ei
end
