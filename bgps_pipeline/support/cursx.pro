 pro cursx,xx,yy,psym=psym,symsize=symsize,color=color,$
                interpolate=interpolate,silent=silent
;+
; ROUTINE:        cursx
;
; USEAGE:         cursx,xx,yy,verbose=verbose
;
; PROCEDURE:      Use the graphics cursor to find xy point on plot.
;                 xy point is written to pop-up widget. 
;
;                 If a single argument is supplied (XX) it is interpreted
;                 as an image or z value which will be evaluated when
;                 the LMB is pressed. This option works with TVIM images
;                 or plots drawn with CONTOUR.
;
;                 if two arguments are supplied (XX and YY) they are
;                 interpreted as the x and y values of a curve in the xy
;                 plane.  The y value of the function is evaluated when
;                 the LMB is pressed. This option works with plots drawn
;                 with PLOT
;
;                 Hit and drag LMB to retrieve coordinates and values
;                 Hit MMB to quit and retain pop-up display
;                 Hit RMB to quit and destroy pop-up
;
; INPUT:          
;   xx            x coordinate or image array
;
;   yy            if present this parameter indicates CURSX should be run
;                 in curve follow mode (CFM). In this mode the y value at a
;                 x coordiate point is indicated with a drawn symbol. The
;                 symbol position follows the shape of the drawn curve as
;                 the cursor is dragged across the plot.
; 
; Keyword input
;
;   psym          symbol used to mark xy point in plot follow mode.
;   symsize       symbol size
;   color         color of symbol
;   silent        if set, pop up window will not contain operating instructions
;   interpolate   if set and non-zero, interpolate between defined x and y
;                 points in plot follow mode
;                 
;
; EXAMPLE: 
;  plot,dist(20)
;  cursx
;
;; display value at a point
;
;  f=randata(100,100,s=3)
;  tvim,f,xra=[100,120],yra=[30,50],xtitle='longitude',ytitle='latitude',/scale
;  cursx,f
;
;; pick values off a plot using curve follow mode
;
;  x=findgen(200)
;  y=randf(200,1.5)
;  plot,x,y
;  loadct,5
;  thick,2
;  cursx,x,y,psym=1,symsize=2,color=100
;  thick,1
;
;  author:  Paul Ricchiazzi                            sep92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
text=strarr(3)

if not keyword_set(silent) then begin
  text=['Use LMB to retrieve coordinates and values',$
        'MMB to quit and retain this pop-up window',$
        'RMB to quit and destroy this window','','']
endif else begin
  text=['                                                             ']
endelse

IF n_params() EQ 2 THEN BEGIN
  IF keyword_set(psym) EQ 0 THEN psym = 1
  IF keyword_set(symsize) EQ 0 THEN symsize = 1
  IF n_elements(color) EQ 0 THEN color = !p.color
  nx = n_elements(xx)
  x = xx(nx/2)
  y = yy(nx/2)
  device, set_graphics=6             ;Set XOR mode
  device,cursor_standard = 113
  tvcrs,x,!y.crange(0),/data
  plots,x,y,psym = psym,/data,symsize = symsize,color = color
  ox = x
  oy = y
endif

!err=0
xmx=max(abs(!x.crange))
ymx=max(abs(!y.crange))
xlb='x ='
ylb='   y ='
zlb='   z ='

if xmx lt 1.e5 then frmx='(a,g11.9' else frmx='(a,e11.3'
if ymx lt 1.e5 then frmy=',a,g11.9' else frmy=',a,e11.3'
if n_params() eq 0 OR n_params() EQ 2 then begin
  fmt=frmx+frmy+')'
endif else begin
  zmx=max(max(xx))
  if zmx lt 1.e5 then frmz=',a,g11.9)' else frmz=',a,e11.3)'
  fmt=frmx+frmy+frmz
  sz=size(xx)
  nx=sz(1)
  ny=sz(2)
  xfac=(nx-1)/(!x.crange(1)-!x.crange(0))
  yfac=(ny-1)/(!y.crange(1)-!y.crange(0))
endelse

xmessage,text,wbase=wbase,wlab=r,title='CURSX'
r=r(n_elements(r)-1)

ox = x
oy = y

while !err eq 0 or !err eq 1 do begin
  cursor,x,y,/data
  CASE n_params() OF
  0: text=string(f=fmt,xlb,x,ylb,y)
  1: BEGIN
      ix=xfac*(x-!x.crange(0)) > 0 < (nx-1)
      iy=yfac*(y-!y.crange(0)) > 0 < (ny-1)
      z=xx(ix,iy)
      text=string(f=fmt,xlb,x,ylb,y,zlb,z)
     END
  2: BEGIN
      IF keyword_set(interpolate) THEN BEGIN
        y = interp(yy,xx,x)
      ENDIF ELSE begin
        x = fix(finterp(xx,x)+.5) > 0 < (nx-1)
        y = yy(x)
      ENDELSE
      plots,ox,oy,psym = psym,/data,symsize=symsize,color = color
      plots,x,y,psym = psym,/data,symsize=symsize,color = color
      text=string(f=fmt,xlb,x,ylb,y)
      ox = x
      oy = y
     END 
  END
  if !err eq 1 then xmessage,text,relab=r
  wait,.1
endwhile

if !err eq 4 then xmessage,kill=wbase

IF n_params() EQ 2 THEN BEGIN
  IF !err EQ 4 THEN plots,ox,oy,psym=psym,/data,symsize=symsize,color=color
  device,set_graphics=3,cursor_standard = 30    ;Re-enable normal copy write
endif  

end


