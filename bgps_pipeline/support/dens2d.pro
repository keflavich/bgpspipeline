 pro dens2d,x,y,g,nbins=nbins,xrange=xrange,yrange=yrange,$
        title=title,xtitle=xtitle,ytitle=ytitle,psym=psym,grid=grid, $
        tvim=tvim,confill=confill,scale=scale,contur=contur,charsize=charsize
;+
; ROUTINE     dens2d,x,y,g,nbins=nbins,xrange=xrange,yrange=yrange,$
;               title=title,xtitle=xtitle,ytitle=ytitle,psym=psym,$
;               grid=grid,tvim=tvim,scale=scale,contur=contur
;
;
; PURPOSE     Compute and/or display the density function of a 2-d scatter
;             of points with coordinate x and y
;
; INPUTS:
;     x       array of values
;     y       array of values (same size as x)
;
; OUTPUTS:    
;  g          2-d histogram array of size nbins(0) x nbins(1)
;
; OPTIONAL INPUTS (keyword parameters):
;  nbins      1 or 2 element vector, number of bins in x and y direction
;             default is (20,20)
;  xrange     2 element vector, binning range in x direction
;  yrange     2 element vector, binning range in y direction
;  charsize   character size
;  title      plot title
;  xtitle     x axis label
;  ytitle     y axis label
;  psym       symbol used for scatter plot, if negative don't plot points
;  grid       if set, show binning grid 
;  contur     if set, draw in density contours (default)
;  confill    if set, use CONFILL is used to draw contours
;  tvim       if set, use TVIM to display the point density function
;             if tvim is set to 1 image is smoothed
;             if tvim is set to 2 image is not smoothed 
;  scale      if set, draw in a color scale      
;                 0=> no color scale
;                 1=> regular color scale (default)
;                 2=> stepped color scale
;
; EXAMPLE
;     x=randomn(is,2000)
;     y=4*randomn(is,2000) + x^3
;     dens2d,x,y,g,/tvim,/grid
;
;     dens2d,x,y,/tvim,/contur
;
;     dens2d,x,y,psym=-1,/contur
;
; AUTHOR:     Paul Ricchiazzi,  Earth Space Research Group, sep92
;-
;
if keyword_set(xrange) then begin
  xmin=xrange(0)
  xmax=xrange(1)
endif else begin
  xmin=min(x)
  xmax=max(x)
  xcen=.5*(xmax+xmin)
  xdif=.5*(xmax-xmin)
  xrange=[xcen-1.1*xdif,xcen+1.1*xdif]
endelse
if keyword_set(yrange) then begin
  ymin=yrange(0)
  ymax=yrange(1)
endif else begin
  ymin=min(y)
  ymax=max(y)
  ycen=.5*(ymax+ymin)
  ydif=.5*(ymax-ymin)
  yrange=[ycen-1.1*ydif,ycen+1.1*ydif]
endelse

case n_elements(nbins) of
 0:begin
    nbinx=20
    nbiny=20
  end
 1:begin
    nbinx=nbins
    nbiny=nbins
  end
 2:begin
    nbinx=nbins(0)
    nbiny=nbins(1)
  end
endcase

x1=xmin
x2=xmax
y1=ymin
y2=ymax
dx=(x2-x1)/nbinx
dy=(y2-y1)/nbiny

i=fix((x-x1)/dx > 0 < (nbinx-1))
j=fix((y-y1)/dy > 0 < (nbiny-1))
ii=j*nbinx+i
g=intarr(nbinx,nbiny)
g(*,*)=histogram(ii,min=0,max=nbinx*nbiny-1,bin=1)


if keyword_set(psym) eq 0 then psym=3
if keyword_set(xtitle) eq 0 then xtitle=' '
if keyword_set(ytitle) eq 0 then ytitle=' '
if keyword_set(title) eq 0 then title=' '
if keyword_set(charsize) eq 0 then charsize=1

if keyword_set(contur) eq 0 then ctur=0 else ctur=1
if keyword_set(confill) eq 0 then confill=0 else confill=1

xrange=[xmin,xmax]
yrange=[ymin,ymax]
xvec=findrng(xrange,nbinx)
yvec=findrng(yrange,nbiny)

case 1 of 


keyword_set(tvim): begin
  if n_elements(scale) eq 0 then scale=1
  if tvim eq 1 then interp=2 else interp=0
  tvim,g,xrange=xrange,yrange=yrange,title=title,xtitle=xtitle,$
         ytitle=ytitle,scale=scale,clevels=clevels,interp=interp,$
         pcharsize=charsize,lcharsize=charsize
  if ctur then contour,g,xvec,yvec,/overplot,levels=clevels
  if psym ge 0 then oplot, x,y,psym=psym
end

confill: begin
  confill,g,xvec,yvec,levels=tickv,xrange=xrange,yrange=yrange, $
           /xstyle,/ystyle,xtitle=xtitle,ytitle=ytitle,title=title,$
           charsize=charsize
  if psym ge 0 then oplot, x,y,psym=psym
end   

ctur: begin
  autorange,g,ntick,tickv
  contour,g,xvec,yvec,/follow,levels=tickv,xrange=xrange,yrange=yrange,$
           /xstyle,/ystyle,xtitle=xtitle,ytitle=ytitle,title=title,$
           c_charsize=charsize,charsize=charsize
  if psym ge 0 then oplot, x,y,psym=psym
end

else:  if psym ge 0 then plot, x,y,psym=psym,xrange=xrange,yrange=yrange,$
             title=title,/xstyle,/ystyle,charsize=charsize
endcase

if keyword_set(grid) then begin
  dx=(xmax-xmin)/nbinx
  dy=(ymax-ymin)/nbiny
  gray=!d.n_colors/2
  for i=1,nbiny-1 do oplot,[xmin,xmax],ymin+[dy,dy]*i,color=gray
  for i=1,nbinx-1 do oplot,xmin+[dx,dx]*i,[y1,y2],color=gray
endif
return
end




