pro x_axis,x,y,xticknames=xticknames,xtitle=xtitle,charsize=charsize, $
           yspace=yspace,ticklen=ticklen,gridstyle=gridstyle, $
           extend=extend,color=color,tcolor=tcolor
;+
; ROUTINE:  x_axis
;
; PURPOSE:  label x axis tick marks with the actual values of the x
;           vector.  
;
; USEAGE:   x_axis,x,y,xticknames=xticknames,xtitle=xtitle, $
;                  charsize=charsize,yspace=yspace,ticklen=ticklen, $
;                  gridstyle=gridstyle,extend=extend
;
; INPUT:    
;   x
;     a vector of x-axis points (data coordinates) to label or mark
;
;   y
;     a scalor or two element vector. First element specifies the
;     vertical subnormal coordinates of the x-axis line.  Y=0 puts
;     x-axis at bottom of the plot while Y=1 puts x-axis at top of
;     plot.  The second element, if present, specifies an additional
;     vertical offset of the x-axis in units of the character
;     height. (default=0)
;
; keyword input:
;   xticknames
;     string array of x axis tickmark labels, if not of type
;     string, will be coerced into string
;
;
;   xtitle
;     x axis title, If XTICKNAME is undefined, XTITLE appears immediately
;     below (YSPACE>0) or above (YSPACE<0) the x axis. Otherwise it
;     appears below/above the XTICKNAME labels.
;
;   yspace  
;     controls vertical spacing between x-axis, tick labels and x-axis
;     title.  By default the centerline of the tick labels appear 1
;     character height below the x-axis while the x-axis title appears
;     2.5 character heights below the x-axis.  The YSPACE factor
;     multiplies these vertical offsets. YSPACE < 0 causes the titles
;     to appear above the x-axis.  (default=1)
;
;   ticklen   
;     length of tickmarks as a PERCENTAGE of the entire y coordinate range
;     TICKLEN=2 produces the standard major tickmark length, while
;     TICKLEN=1 produces the standard minor tickmark length. (defualt=0)
;     
;   charsize
;     character size used for x-axis annotation.  If more than two
;     plots are ganged in either the X or Y direction, the character
;     size is halved.
;     
;   extend
;     if set and y lt 0 or y gt 1 then the y-axis lines are extended to 
;     to intersect the new x-axis line.  This produces an enclosed
;     rectangular area between the new x-axis and the old x-axis (if it
;     exists).
;
;   color
;     color index used to color axis
;
;   tcolor
;     color index used to color axis and tick titles (just for the characters)
;
; DISCUSSION:
;     Calling X_AXIS with no arguments causes the system variables
;     !x.ticname and !x.ticklen to be reset to values which eliminate
;     tickmarks and tick labeling on the following plot.  After the
;     plot is drawn, X_AXIS is called again to draw the specified
;     x-axis scale and reset the !x system variable.
;
; EXAMPLE:  
;
;    
;    y=randomn(iseed,6)^2 & y(0)=0 & y(5)=0
;    x_axis
;    plot,y,psym=10
;    x_axis,1+findgen(5),xtitle='Surface type for 1993 field campagn', $
;      xticknames=['dirt','snow','ocean','grass','forrest'],/ticklen
;
;; x_axis may be called repeatedly to build up fairly
;; elaborate x axis labeling 
;
;    xx=findrng(1.5,7.5,100)
;    x=2+indgen(6)
;    x_axis
;    plot,xx,planck(2^xx,200,/mic),ymargin=[10,10],/xstyle
;    oplot,xx,planck(2^xx,190,/mic)
;    oplot,xx,planck(2^xx,180,/mic)
;    oplot,xx,planck(2^xx,170,/mic)
;    x_axis,x,0,xtickn=2^x,ticklen=1,xtitle='wavelength (microns)'
;    x_axis,x,[1,3],ysp=-.5,xtitle='test',charsize=1.3,/ext
;    x_axis,x,1,xtickn=10000./2^x,ticklen=-1,yspace=-1,$
;          xtitle='wavenumber (cm!a-1!n)'
;
;; fancy log axis labeling
;
;    v=.2*(20/.2)^(findgen(100)/99)
;    w=-4*(.2/v)^2+ 2*(v/10) - 10*(v/10)^2 + 5*(v/10)^3
;    x_axis
;    plot_oi,v,w,/xsty & oplot,v,w^2,li=1 & oplot,v,w^3,li=2
;    x_axis,[.2,.5,2,5,20],0,xtickname=['0.2','0.5','2','5','20'],/tickl
;    x_axis,[1,10],0,xtickname=['1','10'],charsize=1.3,tickl=2
;    x_axis,[.2+indgen(8)*.1,2+indgen(8)],0,/tickl
;
;
; AUTHOR:   Paul Ricchiazzi                        24 Aug 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

if n_elements(color) eq 0  then color=!p.color
if n_elements(tcolor) eq 0 then tcolor=color

if n_params() eq 0 then begin
  !x.tickname=replicate(' ',30)
  !x.ticklen=.0001
  return
endif else begin
  !x.tickname=replicate('',30)
  !x.ticklen=0
endelse

if not keyword_set(charsize) then  $
   if !p.charsize eq 0 then charsize=1 else charsize=!p.charsize
if n_elements(yspace) eq 0 then yspace=1.
if not keyword_set(xtitle) then xtitle=''

nx=n_elements(x)
if n_elements(xticknames) ne 0 then begin
  sz=size(xticknames) 
  nn=n_elements(sz)
  if sz(nn-2) ne 7 then begin
    dx=min(xticknames(1+indgen(nx-1))-xticknames(indgen(nx-1)))

    case 1 of
      dx gt 9999 : fmt='(e10.2)'
      dx ge 1    : fmt='(i20)'
      else       : fmt='(f20.' $
                       +strcompress(string(ceil(-alog10(dx))),/remove_all) $
                       +')'
    endcase

    xlabels=strcompress(string(f=fmt,xticknames),/remove_all)
  endif else begin
    xlabels=xticknames
  endelse
endif else begin
  xlabels=replicate(' ',nx)
endelse

if !p.multi(1) gt 2 or !p.multi(2) gt 2  $
   then chrsz=.5*charsize  $
   else chrsz=charsize

dy=float(!d.y_ch_size)/((!y.window(1)-!y.window(0))*!d.y_vsize)

case n_elements(y) of 
  0:yy=0 
  1:yy=y
  2:yy=y(0)+chrsz*dy*y(1)
endcase

yoff=chrsz*(yspace+.5)
if n_elements(xticknames) ne 0 then begin
  ylab=!y.crange(0)+(yy-dy*yoff)*(!y.crange(1)-!y.crange(0))
  xyouts,x,replicate(ylab,nx),xlabels,charsize=chrsz,align=.5,color=tcolor
  yoff=yoff+1.5*chrsz*yspace
endif 

if n_elements(xtitle) ne 0 then begin  
  ylab=!y.crange(0)+(yy-dy*yoff)*(!y.crange(1)-!y.crange(0))
  xlab=.5*(!x.crange(0)+!x.crange(1))
  if !x.type eq 1 then xlab=10.^xlab
  xyouts,xlab,ylab,xtitle,charsize=chrsz,align=.5,color=tcolor
endif


xline=!x.crange([0,1])
yline=!y.crange(0)+(!y.crange(1)-!y.crange(0))*([yy,yy])

plots,xline,yline,color=color

if yy lt 0 or yy gt 1 and keyword_set(extend) then begin
  xline=!x.crange([0,0])
  yline=!y.crange(0)+(!y.crange(1)-!y.crange(0))*([0,yy])
  plots,xline,yline,color=color
  xline=!x.crange([1,1])
  plots,xline,yline
endif

if keyword_set(ticklen) then begin
  if not keyword_set(gridstyle) then gridstyle=0
  ytick=!y.crange(0)+(!y.crange(1)-!y.crange(0))*(yy+ticklen*[0,.01])
  for i=0,nx-1 do oplot,[x(i),x(i)],ytick,li=gridstyle,color=color,/noclip
endif

return
end


