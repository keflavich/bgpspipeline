pro color_bar,levels,colors,pos=pos,subnorm=subnorm,title=title, $
              labels=labels,digits=digits,stride=stride,charsize=charsize
              
;+
; ROUTINE:  color_bar
;
; PURPOSE:  draw a horizontal color bar
;
; USEAGE:   color_bar
;
; INPUT:    
;   levels  
;     a vector of physical values (required)
;
;   colors  
;     a vector of color values. If colors is not specified a
;     continuous spectrum of colors between colors values 1 and
;     !d.n_colors-2 are used.
;
;
; KEYWORD INPUT:
;   pos
;     position of color bar in normal or subnormal coordinates
;     [xmin,ymin,xmax,ymax], if pos is not specified, CURBOX is
;     called to set the color bar position interactively.
;
;   digits
;     number of significant digits used in number scale label
;     digits=0 causes an integer format to be used. any positive value
;     causes a floating point format.
;
;   stride
;     if set, label only those intervals which have n mod stride eq 0,
;     where n is the number of intervals counting left to right.
;   
;   subnorm
;     use subnormal coordinates to specify pos. subnormal coordinates
;     vary from 0 to 1 across the range of the last plotting window.
;     If not set, normalized coordinates are used.
; 
;   labels  a string array of labels for color values. 
;
;           if nlabels eq nlevels   ==> center labels under tick marks
;           if nlabels eq nlevels-1 ==> center labels between tick marks
;           otherwise               ==> execution stops, error message issued
;
;           where nlabels=n_elements(labels) and nlevels=n_elements(levels)
;
;   title   overall title for color bar, appears below labels
;
;
; OUTPUT:
;  none
;
; DISCUSSION:
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE:  
;
;    loadct,5
;    !y.omargin=[10,0]
;    !p.multi=[0,2,2]
;    r=randata(50,50,s=4) & r=(r-3)
;    levels=-9+indgen(10)
;    colors=findrng(20,!d.n_colors,9)
;    confill,r,/noscale,levels=levels,colors=colors
;    confill,rotate(r,1),/noscale,levels=levels,colors=colors
;    confill,rotate(r,2),/noscale,levels=levels,colors=colors
;    confill,rotate(r,3),/noscale,levels=levels,colors=colors
;    !y.omargin=0
;
;    labels='10!a-'+strcompress(string(8-indgen(9)),/rem)
;    title='ozone mass density (ug/m3)'
;    color_bar,levels,colors,labels=labels,title=title
;
;; use a continuous spectrum of colors
;
;    !y.omargin=[10,0]
;    !p.multi=[0,2,2]
;    r=randata(50,50,s=4) & r=(r-3)
;    levels=-9+indgen(10)
;    colors=findrng(20,!d.n_colors,9)
;    tvim,r & tvim,rotate(r,1) & tvim,rotate(r,2) & tvim,rotate(r,3)
;    !y.omargin=0
;
;    color_bar,indgen(10),labels=labels,title=title
;
; AUTHOR:   Paul Ricchiazzi                        09 Feb 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;


nlevels=n_elements(levels)
ncolors=n_elements(colors)
nlabels=n_elements(labels)

if not keyword_set(charsize) then charsize=1

if nlevels eq 0 then message,'must specify levels'

ticklen=1
if ncolors eq 0 then begin
  colors=1+indgen(!d.n_colors-2)
  ncolors=!d.n_colors
  ticklen=.2
endif else begin
  if ncolors ne nlevels-1 then message,'ncolors ne nlevels-1'
endelse

if nlabels gt 0 and ( nlabels lt nlevels-1 or nlabels gt nlevels )then  $
   message,'incorrect number of labels'

silent=keyword_set(silent)

if max([!x.window,!y.window],min=mn) eq mn then $
  plot,[0,1],[0,1],xstyle=4,ystyle=4,/nodata

sx0=!x.window(0)
sx1=!x.window(1)-sx0
sy0=!y.window(0)
sy1=!y.window(1)-sy0

barw=.75*!d.y_px_cm

dyinit=(barw+3.5*charsize*!d.y_ch_size)


if n_elements(pos) ne 4 then begin

  x0=.1 & x1=.9 
  y0=.1 & y1=y0+float(dyinit)/!d.y_vsize
  message=not keyword_set(silent)
  curbox,x0,x1,y0,y1,/init,message=message

  if keyword_set(subnorm) then begin
    posi=[(x0-sx0)/sx1,(y0-sy0)/sy1,(x1-sx0)/sx1,(y1-sy0)/sy1]
  endif else begin
    posi=[x0,y0,x1,y1]
  endelse

  posstring=string(form='(a,4(f10.2,a))',$
                   ',pos=[',posi(0),',',posi(1),',',posi(2),',',posi(3),']')
  print,strcompress(posstring,/remove_all)
endif else begin
  posi=pos
endelse

; convert back to normal coordinates

if keyword_set(subnorm) then $
  posi=[sx0+posi(0)*sx1,sy0+posi(1)*sy1,sx0+posi(2)*sx1,sy0+posi(3)*sy1]


posi=posi*[!d.x_vsize,!d.y_vsize,!d.x_vsize,!d.y_vsize]

dx=fix(posi(2)-posi(0))
dy=barw*(posi(3)-posi(1))/dyinit
x1=fix(posi(0))
y1=(fix(posi(1))+!d.y_ch_size*4) < fix(posi(1)+.8*(posi(3)-posi(1)))

if !d.name eq 'X' then $
  tv,colors(findrng(0,ncolors,dx)) # replicate(1,dy),x1,y1,/device $
else $
  tv,colors(findrng(0,ncolors,dx)) # replicate(1,2),x1,y1,/device,  $
        xsize=dx,ysize=dy

plots,x1+[0,dx,dx,0,0],y1+[0,0,dy,dy,0],/device
xv=findrng(x1,x1+dx,n_elements(levels))
yv=[y1,y1+dy*ticklen]

for i=0,nlevels-1 do plots,xv(i),yv,/device

if nlabels eq 0 then begin
  fmt='(g20.3)'
  if n_elements(digits) ne 0 then begin
    if digits eq 0 then fmt='(i20)' $
                   else fmt='(g20.'+string(f='(i1,a)',digits,')')
  endif
  ticlab=string(f=fmt,levels)
endif else begin
  ticlab=labels
endelse

ticlab=strtrim(ticlab,2)

if n_elements(stride) ne 0 then begin
  ii=where(indgen(nlevels) mod stride ne 0)
  ticlab(ii)=''
endif

if nlabels eq nlevels-1 then xv=xv(1:*)-.5*dx/nlabels

lablen=lenstr(ticlab)*!d.x_vsize
lablen=.5*(lablen+shift(lablen,1))
lablen=max(lablen(1:*))
ticspace=xv-shift(xv,1)
ticspace=min(ticspace(1:*))
lcharsize=((ticspace-2.)/lablen) < charsize > .1

yv=y1-2*!d.y_ch_size*lcharsize

xyouts,xv,yv,ticlab,align=.5,charsize=lcharsize,/device

if keyword_set(title) then begin
  tlen=lenstr(title)*!d.x_vsize
  if charsize*tlen gt dx then tcharsize=float(dx)/tlen  $
                         else tcharsize=1.2*charsize
  yt=y1-!d.y_ch_size*(2*lcharsize+1.5*tcharsize)
  xyouts,x1+.5*dx,yt,title,align=.5,/device,charsize=tcharsize
endif

end
