pro boxonmap, wx0, wy0, wx1, wy1, INIT = init, FIXED_SIZE = fixed_size, $
 MESSAGE = message
;+
; ROUTINE:
;   BOXONMAP, derived from IDL User Library Procedure BOX_CURSOR
;
; PURPOSE:
;   Emulate the operation of a variable-sized box cursor (also known as
;   a "marquee" selector).
;
; CATEGORY:
;   Interactive graphics.
;
; CALLING SEQUENCE:
;   BOXONMAP, wx0, wy0, wx1, wy1 [, INIT = init] [, FIXED_SIZE = fixed_size]
;
; INPUTS:
;  No required input parameters.
;
; OPTIONAL INPUT PARAMETERS:
; wx0, wy0, wx1, and wy1 give the initial location of the lower left
;       (wx0, wy0) and upper right (wnx, wny) corners of the box if the
; keyword INIT is set.  Otherwise, the box is initially drawn in the
; center of the screen.  Both input and output parameters are in
;       Longitude (X) and Latitude (Y).
;
; KEYWORD PARAMETERS:
; INIT:  If this keyword is set, wx0, wy0, wx1, and wy1 contain the
;       initial parameters for the box.
;
; FIXED_SIZE:  If this keyword is set, the initial parameters fix the
; size of the box.  This size may not be changed by the user.
;
; MESSAGE:  If this keyword is set, print a short message describing
; operation of the cursor.
;
; OUTPUTS:
; wx0:  X value (Lon) of lower left corner of box.
; wy0:  Y value (Lat) of lower left corner of box.
; wx1:  X value (Lon) of upper right corner of box.
; wy1:  Y value (Lat) of upper right corner of box.
;
; The box is also constrained to lie entirely within the window.
;
; COMMON BLOCKS:
; None.
;
; SIDE EFFECTS:
; A box is drawn in the currently active window.  It is erased
; on exit.
;       A window for display of numeric latitude and longitude is created.
;       It is destroyed on exit.
;
; RESTRICTIONS:
; Works only with window system drivers.
;
; PROCEDURE:
; The graphics function is set to 6 for eXclusive OR.  This
; allows the box to be drawn and erased without disturbing the
; contents of the window.
;
; Operation is as follows:
; Left mouse button:   Move the box by dragging.
; Middle mouse button: Resize the box by dragging.  The corner
;  nearest the initial mouse position is moved.
; Right mouse button:  Exit this procedure, returning the
;        current box parameters.
;
; MODIFICATION HISTORY:
; DMS, April, 1990.
; DMS, April, 1992.  Made dragging more intutitive.
; NFH, March, 1993,  Warp box & use map coordinates,
;                          display Lat & Lon in text box.
; PJR/ESRG, March, 1994, display lat & lon in xmessage window
;-

device, get_graphics = old, set_graphics = 6  ;Set xor
col = !d.n_colors -1

if keyword_set(message) then begin
  labels=replicate("                                       ",3)
  xmessage,["Drag Left button to move box.",$
           "Drag Middle button near a corner to resize box.",$
           "Right button when done.",labels],wbase=wbase,wlabels=wlabels
endif

if keyword_set(init) eq 0 then begin  ;Supply default values for box:
  if keyword_set(fixed_size) eq 0 then begin
    nx = !d.x_size/8   ;no fixed size.
    ny = !d.x_size/8
  endif
  x0 = !d.x_size/2 - nx/2
  y0 = !d.y_size/2 - ny/2
endif else begin  ;translate supplied input parameters
  result1 = convert_coord(wx0,wy0, /data, /to_device)
  x0 = result1(0) & y0 = result1(1)
  result2 = convert_coord(wx1,wy1, /data, /to_device)
  x1 = result2(0) & y1 = result2(1)
  nx = x1-x0 & ny = y1-y0
endelse

button = 0
wnx=0 & wny = 0
goto, middle

while 1 do begin
  old_button = button
  cursor, x, y, 2, /dev ;Wait for a button
  button = !err

  if (old_button eq 0) and (button ne 0) then begin
    mx0 = x  ;For dragging, mouse locn...
    my0 = y  
    x00 = x0 ;Orig start of ll corner
    y00 = y0
    result1 = convert_coord(x,y, /device, /to_data)
    result2 = convert_coord(x+nx,y+ny, /device, /to_data)

    wx0 = result1(0) & wy0 = result1(1)
    wx1 = result2(0) & wy1 = result2(1)
    wnx = wx1-wx0 & wny = wy1-wy0
    ;Orig displacement of ur corner, in data units
  endif

  if !err eq 1 then begin  ;Drag entire box?
    xok = x0 & yok = y0
    x0 = x00 + x - mx0
    y0 = y00 + y - my0
    result1 = convert_coord(x0,y0, /device, /to_data)
    wx0 = result1(0) & wy0 = result1(1)
    if abs(wx0) lt 720 and abs(wy0) lt 90 then begin
      wx1 = wx0+wnx & wy1 = wy0+wny
      result2 = convert_coord(wx1,wy1, /data, /to_device)
      x1 = result2(0)
      y1 = result2(1)
      result2 = convert_coord(wx1,wy0, /data, /to_device)
      x2 = result2(0) & y2 = result2(1) ; LR corner
      result2 = convert_coord(wx0,wy1, /data, /to_device)
      x3 = result2(0) & y3 = result2(1) ; UL corner
    endif
    if abs(wx0) le 720 and abs(wy0) le 90 and $
                   abs(wx1) le 720 and abs(wy1) le 90 and $
                   x2 gt x0 and y2 lt y1 and x3 lt x1 and y3 gt y0 and $
                   x0 gt 10 and y0 gt 10 and $
                   x1 lt !d.x_size-10 and y1 lt !d.y_size-10 then begin
      nx = x1-x0 & ny = y1-y0 ; confirm change
    endif else begin
      x0 = xok & y0 = yok     ; rescind change
    endelse
  endif

  if (!err eq 2) and (keyword_set(fixed_size) eq 0) then begin   ;New size?
    px=[x0, x0+nx, x0+nx, x0, x0]
    py=[y0, y0, y0+ny, y0+ny, y0]
    if old_button eq 0 then begin ;Find closest corner
      mind = 1e6
      for i=0,3 do begin
        d = float(px(i)-x)^2 + float(py(i)-y)^2
        if d lt mind then begin
          mind = d
          corner = i
        endif
      endfor
      nx0 = nx ;Save sizes.
      ny0 = ny
    endif
    dx = x - mx0 & dy = y - my0 ;Distance dragged...
    case corner of
     0: begin & x0=x00+dx & y0=y00+dy & nx=nx0-dx & ny=ny0-dy  &  end
     1: begin & y0=y00+dy & nx=nx0+dx & ny=ny0-dy & end
     2: begin & nx=nx0+dx & ny=ny0+dy & end
     3: begin & x0=x00+dx & nx=nx0-dx & ny=ny0+dy & end
    endcase
  endif

 plots, pxw, pyw, col=col, /data, thick=1, lines=0  ;Erase the box
 empty    ;Decwindow bug

 if !err eq 4 then begin  ;Quitting?
   device,set_graphics = old
   result1 = convert_coord(x0,y0, /device, /to_data)
   result2 = convert_coord(x0+nx,y0+ny, /device, /to_data)
   wx0 = result1(0) & wy0 = result1(1)
   wx1 = result2(0) & wy1 = result2(1)
   if keyword_set(wbase) then xmessage,kill=wbase
   return
 endif

 middle:
   x1=x0+nx & y1=y0+ny
  
   w = convert_coord(x0, y0, /device, /to_data)
   wx0 = w(0) & wy0 = w(1)
   w = convert_coord(x1, y1, /device, /to_data)
   wx1 = w(0) & wy1 = w(1)

   wx0=wx0>!map.out(2)
   wx1=wx1<!map.out(3)
   wy0=wy0>!map.out(4)
   wy1=wy1<!map.out(5)

   if wx0 gt 0 and wx1 lt 0 then wx1=wx1+360
   xsegs = 1 > (abs(wx1-wx0)/5)
   ysegs = 1 > (abs(wy1-wy0)/5)
   segs = findgen(xsegs)/xsegs
   pxa = interpolate([wx0, wx1], segs)
   pya = interpolate([wy0, wy0], segs)
   pxc = interpolate([wx1, wx0], segs)
   pyc = interpolate([wy1, wy1], segs)
   segs = findgen(ysegs)/ysegs
   pxb = interpolate([wx1, wx1], segs)
   pyb = interpolate([wy0, wy1], segs)
   pyd = interpolate([wy1, wy0], segs)
   pxd = interpolate([wx0, wx0], segs)
  
   pxw = [wx0, pxa, pxb, pxc, pxd, wx0]
   pyw = [wy0, pya, pyb, pyc, pyd, wy0]
   plots, pxw, pyw, /data, thick=1, lines=0  ;Draw the box
  
   ns='N' & ew='E'
   if wy1 lt 0 then begin &  ns='S' & wy1=-wy1 &  endif
   if keyword_set(message) then labels(0) = string(Format='(f7.2,a)',wy1,ns)
   if wx0 gt 180 then wx0=wx0-360
   if wx0 lt 0 then begin &  ew='W' & wx0 =-wx0 & endif
   if keyword_set(message) then labels(1) = string(Format='(f7.2,a)',wx0,ew)+' /'
   ns='N' & ew='E'
   if wx1 gt 180 then wx1=wx1-360
   if wx1 lt 0 then begin &  ew='W' & wx1 =-wx1 & endif
   if keyword_set(message) then labels(1) = labels(1) + string(Format='(F7.2,a)',wx1,ew)
   if wy0 lt 0 then begin & ns='S' & wy0=-wy0 &  endif
   if keyword_set(message) then labels(2) = string(Format='(f7.2,a)',wy0,ns)
   if keyword_set(message) then xmessage,labels,relabel=wlabels(3:5)
  
   wait, .1  ;Dont hog it all
 endwhile

end

;********** END OF IDL CODE ************






