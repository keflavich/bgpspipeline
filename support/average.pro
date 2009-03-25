pro average, tab, moy, stdv, nb, reject=reject
;+
; FUNCTION: This procedure computes the AVERAGE of a the nk 
;           fields stored in the array tab (nbcol,nblign,nk).
;
; INPUTS  : tab  --> 3 dimensional array (nbcol x nblign x nk)
;
; OUTPUTS : moy  --> average of the fields (nbcol x nblign)
;           stdv --> standard deviation (nbcol x nblign)
;           nb   --> number of points used in the average
;
; USE     : vertaver, array1, array2, outaver,outstdc,outelmts
;
; CONTACT : Didier JOURDAN   didier@esrg.ucsb.edu
;-
sz=size(tab)
;
if (n_elements(reject) ne 0) then begin
  reject=reject
endif else begin
  reject=9999.
endelse
print
print, '==> By default values =', reject,'  are rejected'
print, '==> To change the value use keyword : reject=new_value'
print
;
; define arrays & variables
;
som=dblarr(sz(1), sz(2))
som2=dblarr(sz(1), sz(2))
nb=dblarr(sz(1), sz(2))
moy=dblarr(sz(1), sz(2))
moy2=dblarr(sz(1), sz(2))
test=dblarr(sz(1), sz(2))
stdv=dblarr(sz(1), sz(2))
;
irej=where(tab ne reject)
sz1=size(irej)
if (sz1(0) eq 0) then begin
  if (irej eq -1) then begin
    moy(*,*)=reject
    stdv(*,*)=reject
    nb(*,*)=0.
  endif
endif else begin
;
; do loop over # of fields
;
  for i=0L, sz(3)-1 do begin
; compute sum
    som(*,*)=som(*,*)+tab(*,*,i)*(tab(*,*,i) ne reject)
; compute square of the sum
    som2(*,*)=som2(*,*)+(tab(*,*,i)*(tab(*,*,i) ne reject))^2
; counts number of points different from reject.
    nb(*,*)=nb(*,*)+(tab(*,*,i) ne reject)
  endfor
  iw=where(nb eq 0)
;
;compute average
;
index=where(nb gt 0)

  moy(index)=som(index)/nb(index)
; square ifthe sum
  moy2(index)=som2(index)/nb(index)
  test(index)=moy2(index)-moy(index)^2
  neg=where(test lt 0)
  pos=where(test gt 0)
;
; check negative values in test array
;  if (neg(0) ne -1) then begin
;    chain=string("WARNING STDV NEGATIVE FOR",n_elements(neg)," mean", $
;    " values computed with")
;    chain=strcompress(chain)
;    print, "--------------------------------------------------------------------------------"
;    print, chain
;    for i=0L, sz(3)-1 do begin
;      nb(*,*)=tab(*,*,i)
;      print, "--------------------------------------------------------------------------------"
;      print, nb(neg)
;    endfor
;    print, "================================================================================"
;    print, test(neg)
;    print, "================================================================================"
;    stdv(neg)=0.
;  endif
;
;compute standard deviation
;
  stdv(pos)=sqrt(test(pos))
;
; missing values
;
  if (iw(0) ne -1) then begin
    moy(iw)=reject
    moy2(iw)=reject
    stdv(iw)=reject
  endif
endelse
return
end
