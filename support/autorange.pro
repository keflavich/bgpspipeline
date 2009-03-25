pro autorange,range,ntick,tickv,tickl,ntickmax=ntickmax, $
              cv=cv,log=log,colors=colors
;+
; ROUTINE:    autorange
;
; PURPOSE:    given a range of values find a good tick mark interval
;             and return a properly formatted tick label.  This routine
;             can be used with the axis procedure to add additional
;             axis which are not linearly related to the original 
;             axis (see example)
;
; USEAGE:     autorange,range,ntick,tickv,tickl,ntickmax=ntickmax,$
;                       cv=cv,log=log,colors=colors
;
; INPUT:      
;
;   range     array of values
;
; keyword input
;
;   ntickmax  maximum allowed number of tick marks (default=10)
;
;   cv       if present and non-zero, the tick values will cover a bit
;            less than the full range.  Otherwise tick values cover a
;            bit more than the full range.  Set CV when you want exactly
;            NTICK contour levels to appear on a contour plot.
;
; OUTPUT:
;
;   ntick     number of tick marks
;   tickv     array of tick values
;   tickl     formatted tick labels   
;
; KEYWORD OUTPUT
;   colors    vector of color values covering full color range and having
;             one less element than ntick
;
;; EXAMPLE:
;
;   autorange,[.011,.022],ntick,tickv,tickl & print,tickl
;   0.010 0.012 0.014 0.016 0.018 0.020
;
;; plot solar spectrum with wavenumber on the lower x axis
;; and wavelength on the upper x-axis
;          
;   solar,wn,f
;   plot,wn,f,xstyle=5,xrange=[10000,40000],ymargin=[4,4]
;   axis,xaxis=0,xstyle=1,xtitle='Wavenumber (cm-1)'
;   autorange,1.e7/!x.crange,ntick,tickv,tickl 
;   axis,xaxis=1,xticks=ntick-1,xtitle='Wavelength (nm)',$
;               xtickv=1.e7/tickv,xtickname=tickl
;          
;          
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            mar94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
if keyword_set(ntickmax) eq 0 then ntickmax=10

vmin=min(range)
vmax=max(range)

if vmin eq vmax then begin
  if vmin eq 0 then begin
    vmin=-1
    vmax=1
  endif else begin
    vmin=0 < (2*vmin)
    vmax=0 > (2*vmax)
  endelse
endif





if keyword_set(log) then begin
  decades=alog10(vmax/vmin)
  case 1 of
    decades*11 lt ntickmax: dectic=[1,1.2,1.4,1.7,2,2.4,3,4,5,6,7.5]
    decades*6  lt ntickmax: dectic=[1.,1.4,2.,3.,5.,7.]
    decades*3  lt ntickmax: dectic=[1.,2.,5.]
    decades*2  lt ntickmax: dectic=[1.,3.]
    else:                   dectic=[1.]
  endcase 
  pow=alog10(vmin)
  if pow lt 0 then pow=-ceil(-pow) else pow=fix(pow)
  if n_elements(dectic) gt 3 then dpone = 1 else dpone=0
  dp=(dpone-pow) > 0
  fmt='(f20.'+string(f='(i2.2)',dp)+')'
  tickv=(10.^pow)*dectic
  tickl=string(f=fmt,tickv)
  for i=1,ceil(decades) do begin
    pow=pow+1
    mult=10.^pow
    tickv=[tickv,mult*dectic]
    dp=(dpone-pow) > 0
    fmt='(f20.'+string(f='(i2.2)',dp)+')'
    tickl=[tickl,string(f=fmt,mult*dectic)]
  endfor
  tickl=strtrim(tickl,2)
  ii=where(tickv ge vmin*.99 and tickv le vmax*1.01)
  tickv=tickv(ii)
  tickl=tickl(ii)
  ntick=n_elements(tickv)
  return
endif

rng=abs(vmax-vmin)
lrng=alog10(rng)
if lrng lt 0. then pt=fix(lrng-.5) else pt=fix(lrng+.5)
incc=10.^pt
xtst=[1.,2.,5.]
tst=[.0001*xtst,.001*xtst,.01*xtst,.1*xtst,xtst]
ii=where(rng/(incc*tst) le ntickmax)
incc=incc*tst(ii(0))

digmx=fix(alog10(max(abs([vmin,vmax])))+50)-50
digmn=fix(alog10(incc)+50)-50
if digmx le 4 then begin
  if digmx gt 0 then begin
    if digmn gt 0 then begin
       nw=digmx+2 
       nd=0
     endif else begin
       nw=digmx-digmn+2
       nd=-digmn
     endelse
  endif else begin
    nw=-digmn+2
    nd=-digmn
  endelse
  if vmin lt 0 then nw=nw+1
  fmt=strcompress(string(f='(a,i3,a,i3,a)',"(f",nw,".",nd,")"),/remove_all)
endif else begin
  nd=digmx-digmn
  nw=7+nd
  fmt=strcompress(string(f='(a,i3,a,i3,a)',"(e",nw,".",nd,")"),/remove_all)
endelse

if keyword_set(cv) then begin
  if vmin lt 0 then vmin=fix(vmin/incc)*incc else vmin=ceil(vmin/incc)*incc
  if vmax lt 0 then vmax=-ceil(-vmax/incc)*incc else vmax=fix(vmax/incc)*incc
endif else begin
  if vmin lt 0 then vmin=-ceil(-vmin/incc)*incc else vmin=fix(vmin/incc)*incc
  if vmax lt 0 then vmax=fix(vmax/incc)*incc else vmax=ceil(vmax/incc)*incc
endelse

ntick=1+((vmax-vmin)/incc)

tickv=vmin+indgen(ntick)*incc

tickl=string(f=fmt,tickv)

colors=fix(findrng(1,!d.n_colors-2,ntick-1)+.5)

return
end

