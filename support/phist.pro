pro phist,arr,numbin=numbin,binsize=binsize,percent=percent,$
          cumulative=cumulative,overplot=overplot,xrange=xrange,yrange=yrange,$
          title=title,xtitle=xtitle,ytitle=ytitle,linestyle=linestyle, $
          xstyle=xstyle,color=color,width=width
;+
; NAME:
;       PHIST
;
; PURPOSE:
;       plot histogram
;
; CALLING SEQUENCE:
;       phist,variable
;
; INPUTS:
;   arr    	  array to be plotted
;
; KEYWORD INPUTS:
;
;   numbin        number of histogram bins
;   binsize       size of bins (nullifies effect NUMBIN)
;   xrange        x value range on plot (implies xstyle=1)
;   yrange        y value range on plot 
;   percent       show percentage histogram
;   cumulative    show cumulative histogram
;   overplot      plot this histogram over a previous plot
;   xtitle        x title on plot
;   ytitle        y title on plot
;   title         title on plot
;   width         width of the histogram bars (1 causes vertical bars
;                 to fill the horizontal space, values less than 1 leave
;                 space between bars)
;
;
; EXAMPLE:
;
;   !p.multi=[0,2,2]
;   r=randomn(seed,2000)
;   phist,r
;   phist,r,/perc
;   phist,r,/perc,/cum
;   phist,r,yrange=[0,.5],binsize=.5,color=100,/per
;   phist,r^3,yrange=[0,.5],binsize=.5,color=150,/per,/over,width=.3
; 
; AUTHOR and DATE:
;  author:  Paul Ricchiazzi                            feb95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
; MODIFICATION HISTORY:
;
;-
;

if keyword_set(overplot) then xrange=!x.crange

if keyword_set(xrange) then begin
  xstyle=1
  xmin=xrange(0)
  xmax=xrange(1)
  if not keyword_set(numbin) then numbin=20
endif else begin
  xrange=[min(arr,max=amax),amax]
  xstyle=0
  x=contlev(xrange,maxlev=numbin)
  xmin=min(x,max=xmax)
  xrange=[xmin,xmax]
  if not keyword_set(numbin) then numbin=n_elements(x)
endelse

if not keyword_set(binsize) then binsize=float(xmax-xmin)/numbin
nh=fix(.5+(xmax-xmin)/binsize)

his=histogram(arr,min=xmin,max=xmax,binsize=binsize)

xx=xmin+.5*binsize+findgen(nh)*binsize

if keyword_set(cumulative) then begin
  cumarr=fltarr(nh,nh)
  ii=lindgen(nh*nh)
  cumarr(where(ii mod nh le ii/nh)) = 1
  his=reform(his # cumarr)
  ii=0
  cumarr=0
endif

if keyword_set(percent) then begin
  if keyword_set(cumulative) then his=his/his(nh-1) else his=his/total(his)
endif

if not keyword_set(yrange) then yrange=[min(his,max=mx),mx]
if not keyword_set(xrange) then xrange=[xmin,xmax]
if not keyword_set(xtitle) then xtitle=''
if not keyword_set(ytitle) then ytitle=''
if not keyword_set(title) then title=''
if not keyword_set(linestyle) then linestyle=0
if not keyword_set(width) then width=1.
if n_elements(color) eq 0 then color=0

if not keyword_set(overplot) then begin
  plot,xx,his,xrange=xrange,yrange=yrange,title=title,xstyle=xstyle, $
     xtitle=xtitle,ytitle=ytitle,linestyle=linestyle,/nodata
endif

dx=float(xrange(1)-xrange(0))/nh
xbox=([0,1,1,0,0]-.5)*dx*width
ybox=[0,0,1,1,0]

ymax=max(!y.crange,min=ymin)

if color gt 0 then  $
   for i=0,nh-1 do polyfill,xx(i)+xbox,(ybox*his(i))>ymin<ymax,color=color

if color lt 0 then clr=abs(color) else clr=!p.color

for i=0,nh-1 do oplot,xx(i)+xbox,(ybox*his(i))>ymin<ymax,linestyle=linestyle, $
   color=clr

end
