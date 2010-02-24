 pro trace,xv,yv,ii,restore=restore,silent=silent,dt=dt,region=region,$
                   color=color
;+
; NAME:		TRACE
;
; PURPOSE:	Define a path through a plot or image using the image display 
;               system and the cursor/mouse.  TRACE can be used either to 
;               obtain the vector of x and y vertices of a path in data 
;               coordinates or, when used with TVIM, the array of image 
;               indecies of all points along the path or inside the defined
;               polygon.
;
; CATEGORY:	Image processing.
;
; CALLING SEQUENCE:
;	trace,xv,yv,ii,retore=retore,silent=silent,region=region,dt=dt,
;                  color=color
;
; INPUTS:         none
;
; KEYWORD INPUT PARAMETERS:
;
;	RESTORE   if set, originaly displayed image is restored to its
;		  original state on completion. 
;
;       SILENT    If set no intructional printout is issued at the 
;                 beginning of execution
;
;       DT        repitition time interval for adding or removing nodes
;                 when the mouse button is held down
;
;       REGION    keyword REGION is set II contains indecies of all points
;                 within the polygon defined by XV and YV
;
;       COLOR     color to shade polygonal region, 
;                 works only when REGION is set and RESTORE is not set
;
; OUTPUTS:
;
;       XV    Vector of x vertices of traced path in data coordinates
;
;       YV    Vector of y vertices of traced path in data coordinates
;
;       ii    subscript vector of all pixels along defined path.  This works
;             on an image displayed by TVIM as long as you don't define
;             an XRANGE and YRANGE in the TVIM call.
;
;             if keyword REGION is set II contains indecies of all points
;             within the polygon defined by XV and YV
;
;
; COMMON BLOCKS:
;	None.
;
; SIDE EFFECTS:
;	Display is changed if RESTORE is not set.
;
; RESTRICTIONS:
;       1. Only works for interactive, pixel oriented devices with a
;          cursor and an exclusive or writing mode.
;
;       2. A path may have at most 1000 vertices.  If this is not enough
;          edit the line setting MAXPNTS.
;
;       3. Only works with images displayed by TVIM
;
; PROCEDURE:
;       This procedure is intended to be used with TVIM.  The original
;       TVIM image should be displayed without the XRANGE and YRANGE
;       parameters set, because in this case the x and y axis of the
;       TVIM plot represents the actual image or array coordinates of
;       the imaged quantity.  TRACE uses these values to compute the
;       array indices either along a transect or within a specified
;       polygonal region.
;
;       The exclusive-or drawing mode is used to allow drawing and
;       erasing objects over the original object.
;
;       The operator marks the vertices of the path, either by
;       dragging the mouse with the left button depressed or by
;       marking individual points along the path by clicking the
;       left mouse button, or with a combination of both.
;
;       The center button removes the most recently drawn points.
;
;       Press the right mouse button when finished.  On exit gaps in the 
;       traced path are filled by interpolation
;
; EXAMPLE
;       !p.multi=[0,1,2]
;       d=dist(300,100)
;       tvim,d
;       trace,xv,yv,ii           ; draw a circle inside the image with the 
;                                ; the left mouse button pressed down
;       polyfill,xv,yv,color=100 ; shade the selected region
;       oplot,xv,yv,psym=-1      ; highlight the border of the region
;       plot,d(ii),psym=-1       ; plot a transect of the path
;
;
;; blowup a given region and show it under the original image
;
;       loadct,5
;       !p.multi=[0,1,2]
;       a=randata(200,200,s=4)
;       rng=[min(a,max=amx),amx]              ; save range for use in blowup
;       tvim,a,/scale,range=rng
;       trace,xv,yv,ii,/region
;       xv=[xv,xv(0)] & yv=[yv,yv(0)]         
;       oplot,xv,yv                           ; show border of blowup region
;       xrng=[min(xv,max=xmx),xmx]            ; save xrng and yrng for blowup
;       yrng=[min(yv,max=ymx),ymx]
;       b=fltarr(200,200)
;       b(ii)=a(ii)                           ; show only the selected region
;       b=b(xrng(0):xrng(1),yrng(0):yrng(1))
;       tvim,b,xrange=xrng,yrange=yrng,range=rng,/scale
;       oplot,xv,yv                           ; show border of blowup region
;
;
; Adapted from DEFROI by : Paul Ricchiazzi    oct92 
;                          Earth Space Research Group, UCSB
;
; REVISIONS
; 29oct92: if no points are selected return -1
; 11nov92: allow input parameter AA to be 2 element vector 
; 26apr93: massive simplifications to make TRACE easier to use
;-
;
;on_error,2             ;Return to caller if error

if n_params() eq 0 then begin
  xhelp,'trace'
  return
endif  

nc1 = !d.table_size-1   ;# of colors available
px=!x.window*!d.x_vsize
py=!y.window*!d.y_vsize
xx0=px(0) & xx1=px(1)
yy0=py(0) & yy1=py(1)

device, set_graphics=6             ;Set XOR mode
again:
n = 0
xmess=0
if keyword_set(silent) eq 0 then begin
  xmessage,['Left button to mark point',$
            'Middle button to erase previous point',$
            'Right button to flush and exit'],title='TRACE',wbase=xmess
endif
maxpnts = 1000                  ;max # of points.
xv = intarr(maxpnts)            ;arrays
yv = intarr(maxpnts)
xprev = -1
yprev = -1
if n_elements(dt) eq 0 then dt=.1
;
Cursor, xx, yy, /WAIT, /DEV		;Get 1st point with wait
repeat begin
  if (xx lt xx1) and (xx ge xx0) and (yy ge yy0) and (yy lt yy1) and $
        (!err eq 1) and ((xx ne xprev) or (yy ne yprev)) then begin
    xprev = xx                                     	    ;New point?
    yprev = yy
    if n ge (maxpnts-1) then begin
      print,'Too many points'
      n = n-1
    endif
    xv(n) = xx
    yv(n) = yy
    if n ne 0 then $
      plots,xv(n-1:n),yv(n-1:n), /dev,color=nc1,/noclip
    n=n+1
    wait, dt             ;Dont add points too fast
  endif
; We use 2 or 5 for the middle button because some Microsoft
; compatible mice use 5.
  if ((!err eq 2) or (!err eq 5)) and (n gt 0) then begin
    n = n-1
    if n gt 0 then begin  ;Remove a vertex
      plots,xv(n-1:n),yv(n-1:n), color=nc1,/dev,/noclip
      wait, dt           ;Dont erase too fast
    endif
  endif
  Cursor, xx, yy, /WAIT, /DEV    
endrep until !err eq 4
quit=n lt 2 or abs(max(xv)-min(xv))+abs(max(yv)-min(yv)) eq 0

if quit then begin
  device,set_graphics=3                         ;Re-enable normal copy write
  if xmess ne 0 then xmessage,kill=xmess &   xmess=0
  ii=-1
  xv=-1
  yv=-1
  return
endif

xv = xv(0:n-1)		                ;truncate
yv = yv(0:n-1)

if keyword_set(restore) then $
plots, xv, yv, /dev, color=nc1, /noclip

if !order ne 0 then yv = ny-1-yv	;Invert Y?
device,set_graphics=3                           ;Re-enable normal copy write
if xmess ne 0 then xmessage,kill=xmess &   xmess=0
;
; fill in points between nodes
;
xvyv=convert_coord(xv,yv,/device,/to_data)
xv=reform(xvyv(0,*))
yv=reform(xvyv(1,*))

if n_params() lt 3 then return

ii=lonarr(10000)
m=0

nx=fix(!x.crange(1)-!x.crange(0)+1)
ny=fix(!y.crange(1)-!y.crange(0)+1)

if keyword_set(region) eq 0 then begin

  for i=0,n-2 do begin
    pntx=abs(xv(i+1)-xv(i))
    pnty=abs(yv(i+1)-yv(i))
    pnts=fix(max([pntx,pnty]))
    if pnts gt 0 then begin
      pnts=findgen(pnts)/pnts
      xpath=interpol([xv(i),xv(i+1)],[0.,1.],pnts)
      ypath=interpol([yv(i),yv(i+1)],[0.,1.],pnts)
      mm=m+n_elements(xpath)-1
      ii(m:mm)=long(xpath)+long(ypath)*nx
      m=mm+1
    endif
  endfor
  ii=ii(0:mm)
endif else begin
  ii=polyfillv(xv,yv,nx,ny)
  if n_elements(color) ne 0 and keyword_set(restore) eq 0 then $
    polyfill,xv,yv,color=color
endelse
end








