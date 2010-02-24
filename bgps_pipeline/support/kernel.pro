 function kernel,ksize,angle
;+
; routine:     kernel
; useage:      kernel(ksize,angle)
;
; purpose:     create a digital filter to detect image streaks
;              oriented at angle ANGLE.  The IDL procedure CONVOL 
;              can be used to do the convolutions.
;              
; input:
;   ksize      frame size of kernel. 
;   angle      select for streaks at angle ANGLE 
;
; EXAMPLE:
;
; print,kernel(3,0)
;
;  0 0 0
;  1 1 1
;  0 0 0
;
; print,kernel(5,45)
;
; 0 0 0 0 1
; 0 0 0 1 0
; 0 0 1 0 0
; 0 1 0 0 0
; 1 0 0 0 0
;
;  author:  Paul Ricchiazzi                            oct93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
k=fltarr(ksize,ksize)
ix=ksize/2
iy=ix
ii=indgen(ksize)
ang=angle
while ang gt 180. do ang=ang-180.
while ang lt 0. do ang=ang+180.
case 1 of 

  ang eq   0:  k(*,iy)=1.
  ang eq  45:  k(ii,ii)=1.
  ang eq  90:  k(ix,*)=1.
  ang eq 135:  k(ii,ksize-1-ii)=1.
  ang eq 180:  k(*,iy)=1.

  else:        begin
                 slope=tan(ang*!dtor)
                 if abs(slope) lt 1. then begin
                   jx=indgen((ksize+1)/2)
                   if slope lt 0 then jx=-jx
                   fy=jx*slope
                   fyp=jx*slope+1
                   jy=fix(fy)
                   jyp=fix(fyp)
                   g=jyp-fy
                   gp=fy-jy
                   k(ix+jx,iy+jy)=g
                   k(ix+jx,iy+jyp)=gp
                   k(ix-jx,iy-jy)=g
                   k(ix-jx,iy-jyp)=gp
                   k(ix,iy)=1
                 endif else begin
                   jy=indgen((ksize+1)/2)
                   if slope lt 0 then jy=-jy
                   fx=jy/slope
                   fxp=jy/slope+1
                   jx=fix(fx)
                   jxp=fix(fxp)
                   g=jxp-fx
                   gp=fx-jx
                   k(ix+jx,iy+jy)=g
                   k(ix+jxp,iy+jy)=gp
                   k(ix-jx,iy-jy)=g
                   k(ix-jxp,iy-jy)=gp
                   k(ix,iy)=1
                 endelse
               end
  else        :  message,'angle must be between 0 and 180 degrees'
endcase
sum=total(k)
empty=where(k eq 0,nzero)
k(empty)=-sum/nzero
return,k
end
