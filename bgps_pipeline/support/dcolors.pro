 pro dcolors,r=r,g=g,b=b,pickc=pickc,squeeze=squeeze,view=view
;+
; ROUTINE         dcolors
;
; USEAGE          dcolors
;                 dcolors,r=r,g=g,b=b,pickc=pickc,squeeze=squeeze,view=view
;
; INPUT:          none
;
; Keyword input:  
;
;   pickc         if set, call pickc to adjust discreet colors
;
;   squeeze       if set,  original color table is resampled to fit
;                 in remaining color table index space.
;
;   view          if set, draw palette of discreet colors to separate window
;
;   r,g,b         red, green and blue values of discreet color table.
;                 default colors:
;                  r =  [  0, 255,   0, 150, 255, 196,   3,   0, 150,  98,   0]
;                  g =  [  0,   0, 255, 150,   2, 126, 148, 175,   0,  94,   0]
;                  b =  [  0,   0,   0, 255, 212,   0, 186,   0, 100, 150, 255]
;
; OUTPUT:         none
; 
; PURPOSE:        loads custom colors in lower part of current color
;                 scale.  If SQUEEZE is set pre-existing color scale 
;                 is squeezed to fit between color index n_elements(r)
;                 and !d.n_colors.
; 
;  author:  Paul Ricchiazzi                            jan93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;          
if n_elements(r) ne n_elements(g) or n_elements(g) ne n_elements(b) then $
   message,'r,g,b color vectors must be same size'

rtab=  [  0, 255,   0, 150, 255, 196,   3,   0, 150,  98,   0]
gtab=  [  0,   0, 255, 150,   2, 126, 148, 175,   0,  94,   0]
btab=  [  0,   0,   0, 255, 212,   0, 186,   0, 100, 150, 255]

if n_elements(r) eq 0 then r_tab=rtab else r_tab=r
if n_elements(g) eq 0 then g_tab=gtab else g_tab=g
if n_elements(b) eq 0 then b_tab=btab else b_tab=b
;
ndc=n_elements(r_tab)
mxclr=ndc-1 < (!d.n_colors-1)
nc_orig=!d.n_colors
nc=nc_orig-ndc

if keyword_set(squeeze) then begin
  tvlct,rs,gs,bs,/get                           ;  get original colors
  p=(lindgen(nc)*(nc_orig-1))/(nc-1) 
  rs=[r_tab(0:mxclr), rs(p)] 
  gs=[g_tab(0:mxclr), gs(p)]
  bs=[b_tab(0:mxclr), bs(p)]
  tvlct,rs,gs,bs
endif else begin
  tvlct,r_tab,g_tab,b_tab
endelse

if !d.name eq 'X' and keyword_set(view) then begin
  font=!p.font
  !p.font=0
  xw=40
  yw=40
  wind=!d.window
  if wind eq -1 then window,0
  window,/free,xs=xw*ndc,ys=yw
  im=bindgen(11)
  im=[[im],[im]]
  xpix=ndc*xw
  im=congrid(im,xpix,40)
  tv,im
  for i=0,ndc-1 do xyouts,i*xw+xw/2,yw/2,string(form='(i2)',i),/device,$
               align=.5
  wset,wind
  !p.font=font
endif
if keyword_set(pickc) then pickc,[1,10]
return
end
