pro digitize,x,y,xr=xr,yr=yr
;+
; ROUTINE:    digitize
;
; PURPOSE:    digitize hardcopy graphical information.
;
; USEAGE:     digitize,x,y
;
; INPUT:      none
;
; KEYWORD INPUT:
;   xr        x axis range of hardcopy plot, prompted for if not supplied
;   yr        y axis range of hardcopy plot, prompted for if not supplied
;
; OUTPUT:
;   x         vector of x coordinate values
;   y         vector of y coordinate values
;
;
; PROCEDURE:  1.  make a photo copy of the graph  on tranparency film.
;
;             2.  run DIGITIZE and enter the x and y axis range.
;
;             3.  align the hard copy graph onto the axis drawn by DIGITIZE
;                 and use scotch tape to stick the film onto your screen
;
;             4.  click with LMB on the axis end points (will prompt)
;
;             5.  trace over the plot with cursor, LMB adds points, MMB
;                 erases points and RMB exits the program
;
;             NOTE: Because the outer glass surface of the screen is not
;                   on the same plane as the displayed image their is a 
;                   slight parallax effect between the tranparency and the
;                   DIGITIZE grid.  The parallax error is minimized by
;                   keeping your line of sight normal to the screen.
;  
; EXAMPLE:    
;             digitize,x,y        ; try it
;             plot,x,y
;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            sep93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

window,xs=700,ys=700
if n_elements(xr) eq 0 then begin
  xr=fltarr(2)
  read,'enter x axis range [beg,end]: ',xr
endif
if n_elements(yr) eq 0 then begin
  yr=fltarr(2)
  read,'enter y axis range [beg,end]: ',yr
endif
tvlct,r,g,b,/get
loadct,8

xax=[.1,.1,.9]*!d.x_vsize
yax=[.9,.1,.1]*!d.y_vsize
plots,xax,yax,/device
print,'click on x axis end point'
cursor,xmax,ymin,wait=1,/norm
wait,.5
print,'click on y axis end point'
cursor,xmin,ymax,wait=1,/norm
wait,.5
pos=[xmin,ymin,xmax,ymax]

plot,xr,yr,/xstyle,/ystyle,/nodata,pos=pos,charsize=.1,ticklen=1
trace,x,y
tvlct,r,g,b
return
end




