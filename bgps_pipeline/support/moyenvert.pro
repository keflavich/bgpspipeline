pro moyenvert, tab, moy, stdv, nb, quiet=quiet, nodata=nodata


;+
; NAME:
;       MOYENVERT
;
; PURPOSE:
;       Return the an array that is the "vertical" average of a stack of
;       arrays.
;
; CATEGORY:
;       Array manipulation.
;
; CALLING SEQUENCE:
;       moyenvert, tab, moy, stdv, nb
;
; INPUTS:
;       tab     the array to be averaged
;
; OPTIONAL INPUTS:
;       quiet   don't print messages
;       nodata  use this value when searching for nodata values
;
; OUTPUTS:
;       moy    average of tab through third dimension
;       stdv   standard deviation
;       nb     number of values used in average at each pixel
;
; PROCEDURE
;
; COMMON BLOCKS:
;       None.
;
; NOTES
;
; REFERENCES
; 
; AUTHOR and DATE:
;     Didier Jourdan     Earth Space Research Group, UCSB  12/03/93
;
; MODIFICATION HISTORY:
;
;-
;

if (keyword_set(nodata) eq 0) then nodata = 9999.
sz=size(tab)
som=fltarr(sz(1), sz(2))
som2=fltarr(sz(1), sz(2))
nb=fltarr(sz(1), sz(2))
moy=fltarr(sz(1), sz(2))
moy2=fltarr(sz(1), sz(2))
test=fltarr(sz(1), sz(2))
stdv=fltarr(sz(1), sz(2))
for i=0L, sz(3)-1 do begin
  som(*,*)=som(*,*)+tab(*,*,i)*(tab(*,*,i) ne nodata)
  som2(*,*)=som2(*,*)+(tab(*,*,i)*(tab(*,*,i) ne nodata))^2
  nb(*,*)=nb(*,*)+(tab(*,*,i) ne nodata)
endfor
iw=where(nb eq 0)
index=where(nb gt 0)
moy(index)=som(index)/nb(index)
moy2(index)=som2(index)/nb(index)
test(index)=moy2(index)-moy(index)^2
neg=where(test lt 0,negcnt)
pos=where(test gt 0,poscnt)
if (negcnt gt 0) then begin
  if (keyword_set(quiet) eq 0) then begin
     chain=string("WARNING STDV NEGATIVE FOR",n_elements(neg)," mean", $
     " values computed with")
     chain=strcompress(chain)
     print, "--------------------------------------------------------------------------------"
     print, chain
     for i=0L, sz(3)-1 do begin
	   nb(*,*)=tab(*,*,i)
       print, "--------------------------------------------------------------------------------"
	   print, nb(neg)
     endfor
     print, "================================================================================"
     print, test(neg)
     print, "================================================================================"
  endif 
  stdv(neg)=nodata
endif
if (poscnt gt 0) then stdv(pos)=sqrt(test(pos))
if (iw(0) ne -1) then begin
  moy(iw)=nodata
  moy2(iw)=nodata
  stdv(iw)=nodata
endif
return
end
