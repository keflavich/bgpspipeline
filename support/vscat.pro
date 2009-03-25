 pro vscat,x,y,image,xrange=xrange,yrange=yrange,$
         xtitle=xtitle,ytitle=ytitle,title=title
;+
; ROUTINE         vscat
;
; PURPOSE:        1. use the interactive graphics cursor and the 
;                    DEFINE_REGION procedure to select a region
;
;                 2. plot a x vs y scatter plots of two variables from that
;                    region
;
; USEAGE          vscat,x,y,image
; 
; INPUT:
;   x             array ploted on x axis of scatter plot
;   y             array ploted on y axis of scatter plot
;   image         image used to select regions to plot
;
; KEYWORD INPUT:
;   xrange        range of scatter plot x axis
;   yrange        range of scatter plot y axis
;   xtitle        title of scatter plot x axis
;   ytitle        title of scatter plot y axis
;   title         title of image plot
;
; EXAMPLE
;       !p.multi=[0,1,2]
;       x=20*randata(128,128,s=4)+(findgen(128) # replicate(1.,128))
;       y=20*randata(128,128,s=4)+(replicate(1.,128) # findgen(128))
;       image=x+y
;       vscat,x,y,image
;
;
;
; OUTPUT:         none
;
;  author:  Paul Ricchiazzi                            aug93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
sz=size(image)
nx=sz(1)
ny=sz(2)
if keyword_set(xrange) eq 0 then xrange=[min(x),max(x)]
if keyword_set(yrange) eq 0 then yrange=[min(y),max(y)]
if keyword_set(xtitle) eq 0 then xtitle=''
if keyword_set(ytitle) eq 0 then ytitle=''
if keyword_set(title)  eq 0 then title=''

window,1
window,0
savep=!p.multi
!p.multi=0
dcolors,/view
tvim,image,/scale,title=title,nbotclr=11
savex=!x
savey=!y
indx=9
wset,1
while 1 do begin
  indx=(indx+1) mod 10
  wset,0
  !x=savex
  !y=savey
  trace,xv,yv,ii,/region
  if ii(0) eq -1 then return
  xave=total(ii mod nx)/n_elements(ii)
  yave=total(ii / nx)/n_elements(ii)
  xyouts,xave,yave,string(form='(i2)',indx+1)
  wset,1
  if indx eq 0 then begin
    plot,x,y,psym=3,title=string(form="(a,i3)","region",indx),$
          xrange=xrange,yrange=yrange,xtitle=xtitle,ytitle=ytitle,/nodata
    sx1=!x
    sy1=!y
  endif else begin
    !x=sx1
    !y=sy1
  endelse
  oplot,x(ii),y(ii),psym=3,color=indx+1
  wait,.5
endwhile
!p.multi=savep
end




