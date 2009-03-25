function strmatch,str,spec
;+
; ROUTINE:    strmatch
;
; PURPOSE:    check for string match to a wild card specification
;
; USEAGE:     result=strmatch(str,spec)
;
; INPUT:
;   str       string
;   spec      wild card specification
;
; OUTPUT:     1 if STR matches SPEC
;             0 if STR does not match SPEC
;
; LIMITATIONS:
;             Currently the only wild card character is asterisk, "*"
;             which matches 1 or more arbitrary characters.
;
;  
; EXAMPLE:    
;             print,strmatch('string','st*ng')      ;  => 1
;             print,strmatch('string','*st*ng')     ;  => 0
;             print,strmatch('string','*t*ng')      ;  => 1
;             print,strmatch('string','st*ng*')     ;  => 0
;             print,strmatch('string','st*n*')      ;  => 1
;
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

if strpos(spec,'*') lt 0 then return, str eq spec

len=strlen(str)
lenspec=strlen(spec)
bspec=byte(spec)
bstar=(byte('*'))(0)

specarr=strarr(lenspec)

ls=lenspec-1
kold=0
kk=0
for k=0,ls do begin 
  if bspec(k) eq bstar then begin
    if k gt kold then begin
      specarr(kk)=string(bspec(kold:k-1))
      kk=kk+1
    endif
    specarr(kk)=string(bstar)
    kk=kk+1
    kold=k+1
  endif 
endfor
if bspec(ls) ne bstar then begin
  specarr(kk)=string(bspec(kold:ls))
  kk=kk+1
endif
specarr=specarr(0:kk-1)

nseg=n_elements(specarr)

nogood=0
j=0
jj=0
aster=0
;print,f='(12x,a,a20,a,a20,a)','   |','012345','|','','|'
for k=0,nseg-1 do begin
  if specarr(k) eq '*' then begin
    j=j+1
    aster=1
;    print,f='(3i4,a,a20,a,a20,a)',k,jj,j,'   |','','|','','|'
  endif else begin
    lenseg=strlen(specarr(k))
    strseg=strmid(str,j,100)
    jj=strpos(strseg,specarr(k))
    j=j+jj+lenseg
;    print,f='(3i4,a,a20,a,a20,a)',k,jj,j,'   |',strseg,'|',specarr(k),'|'
    if (jj lt 0) or (jj gt 0 and not aster) then return,0
  endelse
endfor

;print,j,strlen(str),specarr(nseg-1) eq '*'

if specarr(nseg-1) eq '*' then begin
  if j le strlen(str) then return,1 else return,0
endif else begin
  if j eq strlen(str) then return,1 else return,0
endelse
  

end






