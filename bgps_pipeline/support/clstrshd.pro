 function clstrshd,a,binsz,align=align,compare=compare
;+
; ROUTINE:           clstrshd
;
; USEAGE:            result=clstrshd(a, binsz)
;                    result=clstrshd(a, binsz, /align, /compare)
;
; PURPOSE:           compute super pixel cluster shade statistical test
;                    of a scene. the cluster shade is a test of skewness
;                    in the greylevel histogram of each superpixel.
;
; INPUT:
;         a          image array
;
;         binsz      A scalar specifying the number of horizontal and 
;                    vertical sub-pixels in one super pixel. 
;                    BINSZ must be an odd integer.
;
;         align      If set, output arrays are REBINed back up to the 
;                    original size and output array cell centers are aligned
;                    with input array cell centers.
;
;         compare    if set, compare A and ABIN with the FLICK procedure
;
; OUTPUT:
;                    cluster shade value at superpixel cell centers.
;
; AUTHOR:            Paul Ricchiazzi    oct92 
;                    Earth Space Research Group, UCSB
;
;-

if binsz mod 2 eq 0 then message,'BINSZ must be a odd integer'
if binsz lt 0 then       message,'BINSZ must be positive'

sz=size(a)
nx=sz(1)
ny=sz(2)
nxb=fix(nx/binsz)      ; number of horizontal bins in image
nyb=fix(ny/binsz)      ; number of vertical bins in image
nxr=nxb*binsz          ; number of cells matched by bins
nyr=nyb*binsz          ; number of cells matched by bins
dx=nx-nxr
dy=ny-nyr

; make sub arrays

ix=dx/2+(binsz-1)/2+indgen(nxb)*binsz
iy=dy/2+(binsz-1)/2+indgen(nyb)*binsz

gengrid,ix,iy

abin=fltarr(nxb,nyb,binsz,binsz)
ns=binsz/2
for jy=0,binsz-1 do for jx=0,binsz-1 do abin(*,*,jx,jy)=a(ix+jx-ns,iy+jy-ns)

mean=fltarr(nxb,nyb)
mean=total(reform(abin,nxb,nyb,binsz*binsz),3)/(binsz*binsz)
abar=fltarr(nxb,nyb,binsz,binsz)
for jy=0,binsz-1 do for jx=0,binsz-1 do abar(*,*,jx,jy)=mean
abar=reform(abar,nxb,nyb,binsz*binsz)
mean=0.
skew=total(reform((abin-abar),nxb,nyb,binsz*binsz)^3,3)
if keyword_set(align) or keyword_set(compare) then begin
  ix1=dx/2+(binsz-1)/2 & ix2=ix1+nxr-1
  iy1=dy/2+(binsz-1)/2 & iy2=iy1+nyr-1
  ix=fix(nxb*(findgen(nx)-ix1)/(ix2-ix1)+.5) > 0 < (nxb-1)
  iy=fix(nyb*(findgen(ny)-iy1)/(iy2-iy1)+.5) > 0 < (nyb-1)
  if keyword_set(compare) then flick,bytscl(a),$
     bytscl(skew(ix#replicate(1,ny),replicate(1,nx)#iy))
  if keyword_set(align) then skew=skew(ix#replicate(1,ny),replicate(1,nx)#iy)
endif
return, skew
end
  

