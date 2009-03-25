PRO curbox, x1,x2,y1,y2,xwin,ywin,xrng,yrng,init=init,message=message,inc=inc,$
            index=index,label=label,color=color,charsize=charsize,fill=fill
;+
; NAME:
;        CURBOX
;
; PURPOSE:
;        Emulate the operation of a variable-sized box cursor (also known as
;        a "marquee" selector).  CURBOX can be used to select a sub-region
;        from a TVIM image (see example).   
;
; CATEGORY:
;        Interactive graphics.
;
; CALLING SEQUENCE:
;        CURBOX, x1,x2,y1,y2
;
;        curbox,x1,x2,y1,y2,xwin,ywin,xrng,yrng,init=init,$
;                message=message,inc=inc, index=index,label=label, $
;                color=color,charsize=charsize
;+
;
; INPUTS:
;   x1,x2,y1,y2
;     coordinates of box edges. If XWIN,YWIN,XRNG,YRNG are set, then
;     input is in data coordinates, otherwise in normalized coordinates.
;
; KEYWORD PARAMETERS:
;
;   init
;     If this keyword is set, the initial position of the cursor
;     is given by X1,X2,Y1,Y2
;
;   message
;     If this keyword is set, print a short message describing
;     operation of the cursor.
;
;   xwin,ywin
;     two element vectors giving normalized x and y coordinates of window
;     subregion, for example that given by !x.window or !y.window
;   
;   xrng,yrng
;     two elements vectors giving data range of window subregion, for 
;     example, as given by !x.crange or !y.crange.  When CURBOX is used
;     with TVIM (and XRANGE and YRANGE are not used with TVIM), XRNG
;     and YRNG represent the total index range of the displayed
;     image. X1,X2,Y1,Y2 will then be the array subrange of the
;     selected region.
;
;   index
;     if set, the XRNG,YRNG,XWIN,YWIN parameters are set to the values of
;     the last data window, i.e., !x.crange,!y.crange, !x.window, and
;     !y.window respectively.  Setting INDEX causes X1,X2,Y1,Y2 to be
;     interpreted as index range coordinates.
;     
;   inc
;     increment by which to change cursor box size when right or left
;     mouse button is pressed.  Specified in data index coordinates (i.e.,
;     array index coordinate) when XWIN,YWIN,XRNG,YRNG are set, otherwise
;     in normalized coordinates.  The x and y increments may be specified
;     separately by providing INC as a two element array.
;
;   label
;     a string which is used to label the selected region.  The string is
;     centered within the region and is sized to ensure that it fits within
;     the box.  If LABEL is set the box is not erased after CURBOX returns
;     
;   color
;     color used to label regions
;
;   charsize
;     character size used for region labels
;
;   fill
;     color used to fill box region, only effective when LABEL is set
;
; OUTPUTS:
;   x1,x2,y1,y2
;     normalized coordinates coordinates of box edges.  Howvever, if
;     xwin, ywin, xrng, and yrng are set, output is in data index
;     coordinates, i.e., x1,x2,y1,y2 provide the index range of the
;     boxed region of the image.
;
;     If xwin,ywin,xrng,yrng are set, the output range is clipped to be
;     within the limits of xrng and yrng.  
;
; COMMON BLOCKS:
;        None.
;
; SIDE EFFECTS:
;        A box is drawn in the currently active window.  It is erased
;        on exit.
;
; RESTRICTIONS:
;        Works only with window system drivers.
;
; PROCEDURE:
;        The graphics function is set to 6 for eXclusive OR.  This
;        allows the box to be drawn and erased without disturbing the
;        contents of the window.
;
;        Operation is as follows:
;   
;        Left mouse button:   reduce box size
;        Middle mouse button: increase box size
;        Right mouse button:  Exit this procedure, returning the 
;                             current box parameters.
;
;        NOTE: CURBOX is designed for applications in which the aspect
;              ratio of the cursor box is fixed. However, if the
;              aspect ratio must be adjusted do the following: jam the
;              box against one of the window borders.  If you force
;              the box against the left or right borders (while
;              keeping the cursor pointer within the window) box size
;              is constrained to change only in the height. Similarly
;              the box can be made fatter or thiner by pushing the box
;              against the top or bottom. As usual the LMB decreases
;              size and the MMB increases size.
;
;
;
;; EXAMPLE
;;
;;    use curbox to interactively select subregions from a TVIM image
;
;       w8x11
;       !p.multi=[0,1,2]
;       f=randata(128,128,s=3)
;       tvim,f,/interp
;       xw=!x.window & xr=!x.crange
;       yw=!y.window & yr=!y.crange
;        
;       x1=60 & x2=80 & y1=60 & y2=80
;       !p.charsize=2
;       !p.multi=[4,2,4]
;       curbox,x1,x2,y1,y2,xw,yw,xr,yr,/init,inc=4,/mess,label='region 1'
;       confill,f(x1:x2,y1:y2),title='region 1'
;       curbox,x1,x2,y1,y2,xw,yw,xr,yr,/init,inc=4,/mess,label='region 2'
;       confill,f(x1:x2,y1:y2),title='region 2'
;       curbox,x1,x2,y1,y2,xw,yw,xr,yr,/init,inc=4,/mess,label='region 3'
;       confill,f(x1:x2,y1:y2),title='region 3'
;       curbox,x1,x2,y1,y2,xw,yw,xr,yr,/init,inc=4,/mess,label='region 4'
;       confill,f(x1:x2,y1:y2),title='region 4'
;
;;    use CURBOX to find the normalized coordinates of a window region
;;    of given aspect ratio
;
;        x1=.4 & x2=x1+.3 & y1=.4 & y2=y1+.1
;        curbox,x1,x2,y1,y2,/init,/mess
;        print,x1,x2,y1,y2
;
; author   Paul Ricchiazzi      April, 1993
;-


device, get_graphics = old, set_graphics = 6   ;Set xor
xdvsz=!d.x_vsize-1
ydvsz=!d.y_vsize-1
if keyword_set(index) then begin
  xwin=!x.window
  ywin=!y.window
  xrng=!x.crange
  yrng=!y.crange
endif
if keyword_set(xwin) then begin
  cx=poly_fit(xwin,xrng,1)
  cy=poly_fit(ywin,yrng,1)
  centx=.5*(xwin(0)+xwin(1))
  centy=.5*(ywin(0)+ywin(1))
  indexed=1
endif else begin
  cx=[0.,1.]
  cy=[0.,1.]
  centx=.5
  centy=.5
  indexed=0
endelse

if keyword_set(init) then begin  ;Supply default values for box:
  x0=xdvsz*(.5*(x1+x2)-cx(0))/cx(1)
  y0=ydvsz*(.5*(y1+y2)-cy(0))/cy(1)
  mx=x2-x1+indexed
  my=y2-y1+indexed
  fixit=size(x1)
  if fixit(1) eq 2 or fixit(1) eq 3 then fixit=1 else fixit=0
endif else begin
  x0 = !d.x_size*centx
  y0 = !d.y_size*centy
  if indexed then begin
    mx=.5*(xrng(1)-xrng(0)+1)
    my=.5*(yrng(1)-yrng(0)+1)
    fixit=1
  endif else begin
    mx=.2
    my=mx*xdvsz/ydvsz
    fixit=0
  endelse
endelse
   
tvcrs,x0,y0

if keyword_set(inc) then begin
  if n_elements(inc) eq 1 then begin
    dx=inc 
    dy=inc
  endif else begin
    dx=inc(0)
    dy=inc(1)
  endelse
  mx=dx*fix(mx/dx)
  my=dy*fix(my/dy)
endif else begin
  dx=mx/10.
  dy=my/10.
endelse  

aspin=float(mx)/my

mxin=float(mx)
nx=xdvsz*mx/cx(1)
ny=ydvsz*my/cy(1)

px=[x0,x0+nx,x0+nx,x0,x0]-nx/2
py=[y0,y0,y0+ny,y0+ny,y0]-ny/2

plots,px,py,/device

chgx=1
chgy=1

if keyword_set(message) then begin
  szlabel=strcompress(string(f='(a,f10.4)',"SIZE = ",mx/mxin))
  if indexed then szlabel=szlabel+"    "+strcompress(string(mx," x ",my))
  strings=["Hit the left mouse button to reduce the box size",$
           "Hit the middle mouse button to increase the box size",$
           "Hit the right mouse button to quit",szlabel]
  xmessage,strings,wbase=wbase,wlabels=wlabels,title="CURBOX info:"
  lastlabel=wlabels(n_elements(strings)-1)
endif

xinit=x0
yinit=y0

while 1 do begin
  nxo=nx
  nyo=ny
  x00=x0
  y00=y0
  cursor, x0, y0, /nowait, /dev

  butn = !err

  if (x0 ne x00 and y0 ne y00) or $
     (nx ne nxo) or (ny ne nyo) or (butn ne 0) then begin

    if butn eq 1 then begin
      if chgx then mx=(mx-dx) > dx
      if chgy then my=(my-dy) > dy
      nx=xdvsz*mx/cx(1)
      ny=ydvsz*my/cy(1)
      if keyword_set(lastlabel) ne 0 then begin
        szlabel=strcompress(string(f='(a,f10.4)',"SIZE = ",mx/mxin))
        if indexed then szlabel=szlabel+"    "+strcompress(string(mx," x ",my))
        xmessage,szlabel,relabel=lastlabel
      endif

    endif
    if butn eq 2 then begin
      if chgx then mx=(mx+dx)
      if chgy then my=(my+dy)
      nx=xdvsz*(mx/cx(1) < 1.)
      ny=ydvsz*(my/cy(1) < 1.)
      if keyword_set(lastlabel) ne 0 then begin
        szlabel=strcompress(string(f='(a,f10.4)',"SIZE = ",mx/mxin))
        if indexed then szlabel=szlabel+"    "+strcompress(string(mx," x ",my))
        xmessage,szlabel,relabel=lastlabel
      endif
    endif

    plots, px, py,/device                       ; erase old box
    empty
  
    xnew = x0 > (nx/2) < (!d.x_size-nx/2)
    ynew = y0 > (ny/2) < (!d.y_size-ny/2) 
  
    chgx=xnew eq x0
    chgy=ynew eq y0

    x0=xnew
    y0=ynew

    px=[x0,x0+nx,x0+nx,x0,x0]-nx/2
    py=[y0,y0,y0+ny,y0+ny,y0]-ny/2
  
    plots, px, py,/device                       ; draw new box
    empty
  
    if !err eq 4 then begin  ;Quitting?
      plots, px, py,/device
      empty
      device,set_graphics = old, cursor_standard=30
      if keyword_set(message) then xmessage,kill=wbase

      x1=poly((x0-.5*nx)/xdvsz,cx)
      x2=x1+mx-indexed
      y1=poly((y0-.5*ny)/ydvsz,cy)
      y2=y1+my-indexed
      
      if indexed then begin
        x1=x1 >xrng(0) <xrng(1)
        x2=x2 >xrng(0) <xrng(1)
        y1=y1 >yrng(0) <yrng(1)
        y2=y2 >yrng(0) <yrng(1)
      endif
      
      if fixit then begin
        x1=fix(.51+x1)
        x2=fix(.51+x2)
        y1=fix(.51+y1)
        y2=fix(.51+y2)
      endif
      
      if keyword_set(label) then begin
        if n_elements(fill) ne 0 then polyfill,px,py,/device,color=fill
        if not keyword_set(color) then color=!p.color
        plots,px,py,color=color,/device
        xlen=!d.x_vsize*lenstr(label)
        if keyword_set(charsize) then begin
          chsz=charsize
        endif else begin
          if !p.charsize ne 0 then chsz=!p.charsize else chsz=1.
        endelse
        chsz=chsz < (.8*nx/xlen)
        y0lab=y0-.25*chsz*!d.y_ch_size
        xyouts,x0,y0lab,label,charsize=chsz,align=.5,/device
      endif
      return

    endif
  endif
  wait,.05
endwhile

end






