pro barplot,y,over=over,color=color,dx=dx,xoff=xoff,xtitle=xtitle, $
            ytitle=ytitle,title=title,xlabels=xlabels,charsize=charsize, $
            grid=grid,yrange=yrange,xmargin=xmargin,ymargin=ymargin, $
            ynozero=ynozero,xlabvec=xlabvec
;+
; ROUTINE:  barplot
;
; PURPOSE:  produce a bar plot
;
; USEAGE:   barplot
;
; INPUT:  
;   y       bar values  
;
; KEYWORD INPUT:
;   over    if set, overplot new bar values
;
;   color   color index used to fill bars
;
;   dx      width of a bar (default=1).  An individual bar is sized to
;           fill a fraction .5*DX/nn of the total plot width, where nn
;           is the number of elements in y. Setting DX=2 eliminates
;           blank space between adjacent bars.
;
;   xoff    offset of bar with respect to labeled points on x-axis
;           (default=0).  XOFF should be in the range +/- 1.  Use this
;           parameter to offset bars in overplots. IF the difference in
;           XOFF between two calls lt DX/2, the overlayed bars will
;           partially cover previously ploted bars.
;
;           The xaxis labels are located at data coordinates 
;           xlab=findgen(nn)+.5, where nn =n_elements(y)
;            
;
;   xtitle  string, x title of plot
;
;   ytitle  string, y title of plot
;
;   title   string, title of plot
;
;   xlabels vector of strings used to label bar groups 
;
;   xlabvec vector of x values at which to put XLABELS.
;           if XLABVEC is not set, XLABELS are ploted at points
;           .5+findgen(n_elements(xlabels))/n_elements(xlabels)
;           range of XLABVEC 0-1
;
;   grid    if set, draw a y axis grid.  The numerical value of grid 
;           is used to set the grid style (1=dotted line)
;
;   yrange  a two element vector specifying the y axis range
;
;   ynozero if set, y range may not include zero if all y values are
;           are positive.
;
;   xmargin two element vector specifies left and right margin around plot
;           frame in units of character width.  (default = !x.margin)
;
;   ymargin two element vector specifies bottom and top margin around plot
;           frame in units of character height.  (default = !y.margin)
;
;
; OUTPUT:
;
;
; DISCUSSION:
;   For best results try to arrange the order of overplots so that larger
;   values of y are ploted first. See examples.
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE:  
;
;  loadct,5
;  y=randomu(iseed,6)
;  color=[.8,.6,.3]*!d.n_colors
;  dx=.6
;  xoff=.1
;  barplot,y,dx=dx,xlabels=1990+indgen(6),title='test',xtitle='Year',$
;      ytitle='power (Watts)',color=color(0),/grid,xoff=xoff ; right offset 
;  barplot,y^2,dx=dx,color=color(1),/over                    ; no offset
;  barplot,y^3,dx=dx,color=color(2),/over,xoff=-xoff         ; left offset
;
;; A fancier example
;
;  y=randomu(iseed,5) & y=y(sort(y))
;  xlabels=['January','February','March','April','May']
;  color=[.2,.4,.6,.8]*!d.n_colors
;  xoff=.24
;  dx=.32
;  barplot,y,dx=dx,xtitle='---- Month ----',$
;        ytitle='power (Watts)',color=color(3),yrange=[0,1.],ymargin=[5,7],$
;        /grid,xlabels=xlabels,charsize=1.5 ,xoff=xoff
;  barplot,y^2,dx=dx,color=color(2),/over,   xoff=xoff/3
;  barplot,y^3,dx=dx,color=color(1),/over,   xoff=-xoff/3
;  barplot,y^4,dx=dx,color=color(0),/over,   xoff=-xoff
;  x_axis,findgen(5)+.5,1.,xtickn=(y+y^2+y^3+y^4)/4,yspace=-1.5,$
;         xtitle='----- Cumulative Average -----'
;  x_axis,findgen(5)+.5,[1,4],xtitle='Plot Title',yspace=-.5,charsize=1.2,/ext
;  legend,'.cSensor\\AVHRR 1\AVHRR 2\GTR-200\PSP',color=color,$
;          /clrbox,bg=0,/box,pos=[0.06,0.57,0.23,0.98]
;
;; use with histogram to make nicer histogram plots
;
;  y=randomn(iseed,2000)
;  yy=histogram(y,binsize=.5,min=-3)
;  yy=yy(0:11)
;  xlabel=string(f='(f3.0)',findrng(-3,3,12))
;  ;plot,findrng(-3,3,12),yy,/xsty,psym=10  ; compare to this
;  barplot,yy,dx=2,color=20,xlabel=['-3','-2','-1','0','1','2','3']
;  
; AUTHOR:   Paul Ricchiazzi                        31 Aug 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

nx=n_elements(y)
if n_elements(xlabels) eq 0 then  $
   xlabels=strcompress(string(indgen(nx)),/remove_all)
if not keyword_set(color) then color=!p.color

if not keyword_set(charsize) then  $
   if !p.charsize eq 0 then charsize=1 else charsize=!p.charsize

if not keyword_set(title) then title=''
if not keyword_set(ytitle) then ytitle=''
if not keyword_set(xtitle) then xtitle=''
if not keyword_set(grid) then grid=0
if not keyword_set(yrange) then yrange=[0,0]
if not keyword_set(ynozero) then ynozero=0
if not keyword_set(ymargin) then ymargin=!y.margin
if not keyword_set(xmargin) then xmargin=!x.margin

if not keyword_set(over) then begin
  plot,y,/nodata,xstyle=1,xrange=[0,nx],xticklen=.001,charsize=charsize, $
     xmargin=xmargin,ymargin=ymargin,xtickname=replicate(' ',30),title=title, $
     ytitle=ytitle,yticklen=grid,ygridstyle=grid,yrange=yrange,ynozero=ynozero

  xx=findgen(nx)+.5
  if n_elements(xlabels) ne nx then begin
    if n_elements(xlabvec) ne 0 then begin
      xx=xlabvec*nx
    endif else begin
      nxx=n_elements(xlabels)
      xx=nx*findgen(nxx)/(nxx-1)
    endelse
  endif
  x_axis,xx,0,xticknames=xlabels,xtitle=xtitle,charsize=charsize

  if !y.crange(0) lt 0 and !y.crange(1) gt 0 then  $
     oplot,!x.crange([0,1]),[0,0],li=1
endif

if not keyword_set(dx) then dx=1
if not keyword_set(xoff) then xoff=0
xbox=.5+xoff+.5*([0,1,1,0,0]-.5)*dx
ybox=[0,0,1,1,0]

ymax=max(!y.crange,min=ymin)

for i=0,nx-1 do polyfill,i+xbox,(ybox*y(i))>ymin<ymax,color=color
for i=0,nx-1 do oplot,i+xbox,(ybox*y(i))>ymin<ymax

return
end





