 pro fonts,greek=greek,math=math,gothic=gothic,script=script,italic=italic,$
          all=all
;+
; ROUTINE:       fonts
;
; userage:       fonts,greek=greek,math=math,gothic=gothic,script=script,$
;                   italic=italic,all=all
;
; PURPOSE:       display available fonts in a new window
; INPUTS:        none
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
fon0='ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`<=>0123456789'
fon1='abcdefghijklmnopqrstuvwxyz!"#$%&''()*+,-./:;?@'
nf=0
if keyword_set(all) then begin
  ftype=3+indgen(16)
  ftype=[ftype,20]
  nf=n_elements(ftype)
  xs=1200
  xmax=40
endif else begin
  ftype=[3]
  if keyword_set(greek)  then ftype=[ftype,[4,7]]
  if keyword_set(math )  then ftype=[ftype,9]
  if keyword_set(gothic) then ftype=[ftype,[11,15]]
  if keyword_set(script) then ftype=[ftype,[12,13]]
  if keyword_set(italic) then ftype=[ftype,18]
  xmax=20
  xs=500
  nf=n_elements(ftype)
  if nf eq 1 then nf=0
endelse
if nf ne 0 then begin
  xmakedraw,x_w=xs,y_w=900,base_id=base_id,$
            widget_label='Vector Drawn Fonts',/nowait

;  window,/free,xs=xs,ys=1000
  multin=!p.multi
  fontin=!p.font
  !p.multi=0
  plot,[1,xmax],[0,50],/nodata,xstyle=4,ystyle=4,xmargin=[0,0],ymargin=[0,0]
  oplot,[1,xmax,xmax,1,1],[0,0,50,50,0]
  ;
  xyouts,1,47,'!3FONTS:'
  for k=0,nf-1 do begin
    j=ftype(k)
    xyouts,3+k,47,string(form='("!3",i2)',j)
    for i=0,44 do begin
      str=strmid(fon0,i,1)
      if str eq '!' then str='!!'
      str=string('!',j,str,' !x')
      str=strcompress(str,/remove_all)
      xyouts,3+k,45-i,str,charsize=2
    endfor
  endfor
  for k=0,nf-1 do begin
    j=ftype(k)
    xyouts,3+k+nf+3,47,string(form='("!3",i2)',j)
    for i=0,44 do begin
      str=strmid(fon1,i,1)
      if str eq '!' then str='!!'
      str=string('!',j,str,' !x')
      str=strcompress(str,/remove_all)
      xyouts,3+k+nf+3,45-i,str,charsize=2
    endfor
  endfor

  xmanager,'Xmakedraw',base_id
  !p.font=fontin
  !p.multi=multin
  
endif
print,' '
print,'Vector font draw commands '
print,' '
print,'!A       shift up       (!/)'
print,'!B       shift down     (!/)
print,'!C       carriage return'
print,'!D       subscript'
print,'!E       superscript or exponent'
print,'!I       shift down to index level (smaller than !D)'
print,'!L       shift down to to the second level subscript (PS only)'
print,'!M       select PostScript symbol font               (PS only)'
print,'!MX      Insert bullet character                     (PS only)'
print,'!N       shift back to normal level and character size'
print,'!R       restore position'
print,'!S       save position'
print,'!U       shift to upper level subscript'
print,'!W       same as !12                                 (PS only)'
print,'!X       return to entry font'
print,'!3 - !20 change to the given font number'
print,'!!       display !'
print,' '
end

