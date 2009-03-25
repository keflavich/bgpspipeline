FUNCTION zoombar, range, INIT = init, ybar=ybar,xbar=xbar, $
                color=color,message=message
;+
; NAME:
;	zoombar
;
; USEAGE:    while zoombar(range) do ...
;
; PURPOSE:
;	Emulate the operation of a variable-sized box cursor (also known as
;	a "marquee" selector).
;
; CATEGORY:
;	Interactive graphics.
;
; CALLING SEQUENCE:
;	result = zoombar(range, INIT=init,message=message,$
;                        ybar=ybar,xbar=xbar)
;
; INPUTS:
;	No required input parameters.
;
; OPTIONAL INPUT PARAMETERS:
;	x0, y0, nx, and ny give the initial location (x0, y0) and 
;	size (nx, ny) of the box if the keyword INIT is set.  Otherwise, the 
;	box is initially drawn in the center of the screen.
;
; KEYWORD PARAMETERS:
;
;  INIT
;    Sets the initial x or y range of the cursor bar.  INIT should be
;    specified in data coordinates.
;
;  ybar
;    If this keyword is set, the horizontal size of the box
;    is fixed.  Set this keyword to set vertical range
;
;  xbar
;    If this keyword is set, the vertical size of the box
;    is fixed.  Set this keyword to set horizontal range
;    (default)
;
;  message
;    if set, an instructional pop-up widget appear
;    if MESSAGE is a string or string array, the contents of
;    MESSAGE are pre-pended to ZOOMBARs default instructions.
;                 
;
; OUTPUTS:
;    result: 1 if exit is caused by RMB clicked inside bar
;    result: 0 if exit is caused by RMB clicked outside bar
;
;    range:  the vertical (if ybar is set)  or horizontal 
;               (if xbar is set) range of the cursor bar.
;
; COMMON BLOCKS:
;       None.
;
; SIDE EFFECTS:
;       A box is drawn in the currently active window.  It is erased
;       on exit.
;
; RESTRICTIONS:
;       Works only with window system drivers.
;
; PROCEDURE:
;       The graphics function is set to 6 for eXclusive OR.  This
;       allows the box to be drawn and erased without disturbing the
;       contents of the window.
;
;       Operation is as follows:
;
;       Left mouse button:   Move the box by dragging.
;
;       Middle mouse button: Resize the box by dragging.  The corner
;               nearest the initial mouse position is moved.
;
;       Right mouse button:  Exit this procedure, returning the 
;                            current xrange or yrange parameters.  
;                            RMB click inside the bar,  return value = 1
;                            RMB click outside the bar, return value = 0
;
;;; Example:  
;
;    x=randf(1000,1.5) & plot,x & while zoombar(r,/mes) do plot,x,xr=r,/xst 
;
;;; select range in one window, plot zoomed plot in another:
;
;  window,1 & wset,0 & x=randf(1000,1.5) & plot,x & xs=!x & r=0
;  while zoombar(r,/mes,init=r) do begin &$
;     wset,1 & plot,x,xr=r & !x=xs & wset,0 & end
;-

device, get_graphics = old, set_graphics = 6  ;Set xor

col = !d.n_colors -1
IF n_elements(color) EQ 0 THEN color = .5*col

IF NOT keyword_set(ybar) THEN BEGIN
  xbar = 1
  ybar = 0
ENDIF ELSE BEGIN
  xbar = 0
  ybar = 1
ENDELSE

if keyword_set(message) then BEGIN 

  xms = ["Drag Left button to move bar",$
         "Drag Middle button near a corner to resize bar",$
         "Right button inside bar to use current range", $
         "Right button outside bar to exit"," "," "]
  sz = size(message)
  IF sz(n_elements(sz)-2) EQ 7 THEN xms = [message,xms]
  xmessage,xms, wlabel=wlabel,wbase=wbase,title = 'ZOOMBAR'
ENDIF


xmid = .5*(!x.crange(0)+!x.crange(1))
xdel = (!x.crange(1)-!x.crange(0))
ymid = .5*(!y.crange(0)+!y.crange(1))
ydel = (!y.crange(1)-!y.crange(0))

IF ybar THEN xpos = !x.crange(0)+[0,.01*xdel] $
        ELSE xpos = xmid+.2*xdel*[-1,1]
IF xbar THEN ypos = !y.crange(0)+[0,.01*ydel] $
        ELSE ypos = ymid+.2*ydel*[-1,1]

IF !x.type THEN xpos = 10.^xpos
IF !y.type THEN ypos = 10.^ypos

if keyword_set(init) then begin
  if xbar then xpos = init
  if ybar then ypos = init
endif

coord = convert_coord(xpos,ypos,/data,/to_dev)
x0 = coord(0,0)
y0 = coord(1,0)
x1 = coord(0,1)
y1 = coord(1,1)
nx = ceil(x1 - x0) > 15
ny = ceil(y1 - y0) > 15
tvcrs,(x0+.5*nx),(y0+.5*ny)

button = 0
goto, middle

while 1 do begin
        old_button = button
        cursor, x, y, 2, /dev   ;Wait for a button
        button = !err
        if (old_button eq 0) and (button ne 0) then begin
          mx0 = x               ;For dragging, mouse locn...
          my0 = y               
          x00 = x0              ;Orig start of ll corner
          y00 = y0
        endif
        if !err eq 1 then begin  ;Drag entire box?
          movex=(x-mx0) 
          movey=(y-my0)
          if ybar then movex=nx*(movex/nx)
          if xbar then movey=ny*(movey/ny)
          x0 = x00 + movex
          y0 = y00 + movey
        endif
        if (!err eq 2) and (keyword_set(fixed_size) eq 0) then begin ;New size?
          if old_button eq 0 then begin ;Find closest corner
            mind = 1e6
            for i=0,3 do begin
              d = float(px(i)-x)^2 + float(py(i)-y)^2
              if d lt mind then begin
                mind = d
                corner = i
              endif
            endfor
            nx0 = nx  ;Save sizes.
            ny0 = ny
          endif
          dx = x - mx0 & dy = y - my0   ;Distance dragged...
          IF keyword_set(ybar) THEN dx = 0
          IF keyword_set(xbar) THEN dy = 0
          case corner of
            0: begin 
                   x0 = x00 + dx
                   nx = nx0 - dx
                   y0 = y00 + dy
                   ny = ny0 - dy
               endcase
            1: BEGIN
                   y0 = y00 + dy
                   nx = nx0 + dx
                   ny = ny0 - dy
               endcase
            2: BEGIN
                   nx = nx0 + dx
                   ny = ny0 + dy
               endcase
            3: BEGIN
                   x0 = x00 + dx
                   nx = nx0 - dx
                   ny = ny0 + dy
               endcase
          endcase
        endif
        plots, px, py, col=col, /dev, thick=1, lines=0	;Erase previous box
        IF keyword_set(color) THEN polyfill,px,py,/dev, color = color
        
	empty				;Decwindow bug

	if !err eq 4 then begin  ;Quitting?
          device,set_graphics = old
          IF keyword_set(message) THEN xmessage,kill = wbase
          coord = convert_coord(px,py,/dev,/to_data)
          IF xbar THEN begin
            range = reform(coord(0,[0,1]))
          ENDIF ELSE BEGIN
            range = reform(coord(1,[0,2]))
          ENDELSE
 	  return, x GE x0 AND x LE x0+nx AND y GE y0 AND y LE y0+ny
	endif
middle:

	if nx lt 0 then begin
		x0 = x0 + nx
		nx = -nx
	endif
	if ny lt 0 then begin
		y0 = y0 + ny
		ny = -ny
	endif

	x0 = x0 > 0
	y0 = y0 > 0
	x0 = x0 < (!d.x_size-1 - nx)	;Never outside window
	y0 = y0 < (!d.y_size-1 - ny)

	px = [x0, x0 + nx, x0 + nx, x0, x0] ;X points
	py = [y0, y0, y0 + ny, y0 + ny, y0] ;Y values

	plots,px, py, col=col, /dev, thick=1, lines=0  ;Draw the box
        IF keyword_set(color) THEN polyfill,px,py,/dev, color = color
        if keyword_set(message) then BEGIN 
          coord = convert_coord(px,py,/dev,/to_data)
          
          IF xbar THEN BEGIN
            rlabel =  string("range = [" ,coord(0,0),coord(0,1)," ]")
          ENDIF ELSE BEGIN
            rlabel =  string("range = [" ,coord(1,0),coord(1,2)," ]")
          ENDELSE
          xmessage,rlabel,relabel = wlabel(n_elements(xms)-1) 
        ENDIF   

	wait, .1		;Dont hog it all
ENDWHILE

end
