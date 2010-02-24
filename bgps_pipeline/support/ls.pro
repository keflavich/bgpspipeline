 pro ls,filt
;+
; routine    ls
; useage:    ls
;            ls,filt
; input:
;   filt     a valid unix filename specification or wild card (not required)
;
; purpose    print files in current working directory
;  author:  Paul Ricchiazzi                            jan93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
pad="                                                               "

; pad is added to character strings to obtain left justified columns

if not keyword_set(filt) then filt='*'
files=findfile(filt)
idir=where(strpos(files,':') ne -1,ndir)
if ndir gt 0 then begin
  direc=files(idir)
  files=files(0:idir(0)-1)
  direc=direc+pad
endif
mxlen=max(strlen(files))+1
nf=n_elements(files)
ncol=80/mxlen
mxlen=80/ncol
ncol=80/mxlen
nlines=(nf+ncol-1)/ncol

case 1 of
  nlines le 1 : begin
                   nlines=nf
                   ncol=1
               end
  nlines le 4: begin
                   ncol=2
                   nlines=(nf+ncol-1)/ncol
               end
  else: 
end
fmt=strcompress(string("(",ncol,"a",mxlen,")"),/remove_all)
ii=indgen(nlines,ncol)
ii=reform(transpose(ii))
files=[files," "]
files=files+pad
print,f=fmt,files(ii)
if n_elements(direc) ne 0 then begin
  print,' '
  print,'subdirectories'
  print,' '
  print,f=fmt,direc
endif
end



