 pro plotsym,x,y,xsym,ysym,ocolor=ocolor,fcolor=fcolor,thick=thick,$
           sym_siz=sym_siz,device=device,norm=norm,data=data,type=type
;+
; routine:    plotsym
;
; usage:      plotsym,x,y,xsym,ysym
;
; purpose:    overlays plot symbols on the last data window.  A single
;             call can create symbols of varying size, fill color, and
;             outline color and thickness.  Symbols of arbitrary shape
;             can be created.  Note that the symbols may be filled
;             with a different color then the outline color.  This can
;             dramatically unclutter the appearance of densely packed
;             scatter plots.  See example.
;              
;
; input:
;   x         x coordinates of symbol centers on plot
;   y         y coordinates of symbol centers on plot 
;   xsym      x coordinantes of symbol outline with respect to symbol center
;   ysym      y coordinantes of symbol outline with respect to symbol center
;
;   NOTE:     if TYPE or XSYM and YSYM are not supplied a circular symbol
;             is assumed
;
; keyword input:
;   ocolor    outline color of symbol 
;   fcolor    fill color of symbol
;   thick     line thickness of symbol outline
;   sym_siz   symbol size multiplier
;   type      symbol type, a string matching one of 
;
;                       'DIAMOND',   'PENTAGON',  'CLOVER',   'PACMAN',
;                       'SPIRAL',    'BIGX',      'CIRCLE',   'SQUARE',
;                       'TRIANGLE',  'STAR',      'HEXAGON',  'HEART',
;                       'SPADE',     'CLUB'
;             
;   NOTE:     OCOLOR, FCOLOR, THICK and SYM_SIZE may be specified as
;             single values or vector of values, one for each element 
;             of x and y
;
;   device    if set, coordinates are in device units
;   normal    if set, coordinates are in normalized units
;   data      if set, coordinates are in data units (default)
;
;
;   NOTE:
;
;   the OCOLOR, FCOLOR, THICK and SYM_SIZ parameters may be specified as 
;   vectors quantities, one value for each point on the plot
;
; SIDE EFFECTS:
;   changes the shape of user-defined plot symbol (accessed with psym=8).
;
; EXAMPLE:
;
;   x=randomu(iseed,400)                                                 
;   y=randomu(iseed,400)                                                 
;   z=1.-x-y                                                             
;   fcolor=bytscl(z,top=!p.color)                                        
;   ocolor=5*!p.color                                                    
;   loadct,5                                                             
;   plot,x,y,/nodata                                                     
;   plotsym,x,y,type='square',fcolor=fcolor,ocolor=ocolor,thick=1,sym_siz=1.5
;
;;  In this example note how PLOTSYM unclutters the scatter plot
;
;   !p.multi=[0,1,2]
;   x=randomn(iseed,400)                                                 
;   y=randomn(iseed,400)                                                 
;   plot,x,y,/nodata                                                     
;   plotsym,x,y,sym_siz=2
;
;   plot,x,y,psym=8
;          
;  author:  Paul Ricchiazzi                            jan93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
nn=n_elements(x)
if nn ne n_elements(y) then message,'x and y dimensions dont match'

nxsym=n_elements(xsym)
nysym=n_elements(ysym)
if nxsym ne nysym then message,'xsym and ysym dimensions dont match'
if nxsym eq 0 then begin
  if keyword_set(type) then begin
    usersymbol,type,xsym,ysym
  endif else begin
    xsym=cos(findgen(37)*10*!dtor)
    ysym=sin(findgen(37)*10*!dtor)
  endelse
endif
  
if n_elements(ocolor)  eq 0 then ocolor=254
if n_elements(fcolor)  eq 0 then fcolor=1
if n_elements(thick)   eq 0 then thick=1
if n_elements(sym_siz) eq 0 then sym_siz=1 

if n_elements(ocolor)  eq 1 then ocolor=replicate(ocolor,nn)
if n_elements(fcolor)  eq 1 then fcolor=replicate(fcolor,nn)
if n_elements(thick)   eq 1 then thick=replicate(thick,nn)
if n_elements(sym_siz) eq 1 then sym_siz=replicate(sym_siz,nn)


ii=where(x ge !x.crange(0) and x le !x.crange(1) and $
         y ge !y.crange(0) and y le !y.crange(1), nc)

xx=x(ii)
yy=y(ii)
ocolor=ocolor(ii)
fcolor=fcolor(ii)
thick=thick(ii)
sym_siz=sym_siz(ii)
if keyword_set(device) eq 0 and keyword_set(norm) eq 0 then data=1

for i=0,nc-1 do begin
  usersym,sym_siz(i)*xsym,sym_siz(i)*ysym,/fill,color=fcolor(i)
  plots,xx(i),yy(i),psym=8,data=data,norm=norm,device=device
  usersym,sym_siz(i)*xsym,sym_siz(i)*ysym,color=ocolor(i),thick=thick(i)
  plots,xx(i),yy(i),psym=8,data=data,norm=norm,device=device
endfor
end
