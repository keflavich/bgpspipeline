 pro classify,xa,ya,class_out,image=image,class_in=class_in,select=select, $
           n_samples=n_samples,blow_up=blow_up,title=title,ytitle=ytitle, $
           xtitle=xtitle,ititle=ititle,no_color=no_color
;+
; ROUTINE:         CLASSIFY
;
; FUNCTION:
;            Display the physical locations of points selected on the
;            basis of image quantities, xa and ya.  An interactive
;            cursor box is used to select clusters of points from the
;            2-d scatter plot of xa vs ya. These points are drawn on a
;            satellite image to indicate their actual physical
;            location.
;
; CALLING SEQUENCE:
;
;       classify,xa,ya,class_out,image=image,class_in=class_in,select=select, $
;              n_samples=n_samples,blow_up=blow_up,title=title,ytitle=ytitle, $
;              xtitle=xtitle,ititle=ititle
;
; CATEGORY:
;       Interactive graphics
;
; REQUIRED INPUTS:
;       XA       First channel parameter, x-axis of scatter plot
;       YA       Second channel parameter, y-axis of scatter plot
;
; OPTIONAL INPUTS (keyword parameters):
;       IMAGE    Image of a particular satellite channel over which 
;                points are ploted.  If not supplied points are ploted
;                over blank plot
;
;    CLASS_IN    (Byte array) Pixel color class initialization.  Each
;                element corresponds to one pixel in the sample set
;                (see n_samples, below). An initial run of CLASSIFY
;                will generate the byte array, CLASS_OUT.  This can be
;                used in a subsequent run of CLASSIFY with
;                CLASS_IN=CLASS_OUT to restart CLASSIFY in its former
;                state.  When set, CLASS_IN overrides the effect of
;                SELECT and N_SAMPLES, below.
;
;    N_SAMPLES   2 element vector specifying the number of samples in the
;                x and y directions.  E.g., if N_SAMPLES=[100,150],
;                then the scatter plot will consist of a 100x150
;                element subset of the original image.  If N_SAMPLES
;                is not set, a default number of samples in the x and
;                y directions is used.
;                
;                
;       SELECT   Vector of pre-selected indices (longword integers). 
;                For example, SELECT=WHERE(XX LT 10) chooses only
;                those sample points for which parameter xx
;                is less than 10.
;
;      BLOW_UP   Two element vector of specifying the image size blowup factor 
;
;       TITLE    Title of scatter plot 
;       XTITLE   Scatter plot x-axis label
;       YTITLE   Scatter plot y-axis label
;       ITITLE   Plot title of satellite image
;       NO_COLOR don't use color, show points with unique symbols
;
; OUTPUTS
;     CLASS_OUT  (Byte array) Color class of each sample point.  Values
;                between 1 - 6 indicate different selected color
;                classes.  Greater values indicate unselected points
;                which can be selected with the cursor. CLASS_OUT can
;                be used in another call to CLASSIFY, e.g.,
;                CLASSIFY,XA,YA,CLASS_OUT ; followed by,
;                CLASSIFY,XA,YA,CLASS_IN=CLASS_OUT
;
;
; COMMON BLOCKS:
;       none
;
; SIDE EFFECTS:
;       Two windows are created to contain the scatter plot (window 0) and
;       the physical image (window 2).  Calls TVLCT to load a customized 
;       color table with grey scale for byte values greater than 10 and
;       discreet colors for byte values between 1 and 10.
;
; RESTRICTIONS:
;       Works only on window system drivers
;
; PROCEDURE:
;       Points which enter into the cursor box are hi-lighted and stored
;       for plotting on the satellite image.  The left mouse button increases
;       the size of the cursor box while the middle mouse button decreases it
;       The right mouse button stops the selection process and displays a 
;       pop-up menu with 4 options:
;
;       (n) select a new selection class (assign a new color)
;       (r) reset the selection set
;       (d) display the selection set on the satellite image
;       (p) save current plot to postscript file "plot.ps"
;       (q) clean up displays and quit
;
;  author:  Paul Ricchiazzi                            oct92 
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;----------------------------------------------------------------
;
mx=50          ; number of default super pixels in x 
my=50          ; number of default super pixels in y
;
; color settings
;
clr_off=0.5
clr_rub=0.0
!ERR=0
sz=size(xa)
nx=sz(1)
ny=sz(2)
;
if keyword_set(title) eq 0 then title=""
if keyword_set(xtitle) eq 0 then xtitle=""
if keyword_set(ytitle) eq 0 then ytitle=""
if keyword_set(ititle) eq 0 then ititle=""
;
; initialize from CLASS_IN
;
if keyword_set(class_in) then begin
  szm=size(class_in)
  mx=szm(1)
  my=szm(2)
  indx=bytarr(mx,my)
  indx=class_in
  select=where(indx ne 0,numset)
  xscale=float(nx-1)/(mx-1)
  yscale=float(ny-1)/(my-1)
;
; start-up from scratch
;
endif else begin
  if keyword_set(n_samples) then begin
     mx=n_samples(0)
     my=n_samples(1)
  endif
;
  if keyword_set(select) then begin
    print,form='($,a,a)','Resorting SELECT vector....',string("15b)
    is=0l
    ismax=n_elements(select)-1
    if ismax lt 10000 then begin
      mx=nx
      my=ny
      xscale=1.
      yscale=1.
    endif
    indx=bytarr(nx,ny)
    indx(select)=1
    indx=congrid(indx,mx,my)
  endif else begin
    indx=replicate(1,mx,my)
  endelse
  select=where(indx,numset)
  indx(*,*)=0
;
endelse
;
print,form='($,a,a)','Creating sub-sample array....',string("15b)
xsamp=fltarr(mx,my)
ysamp=fltarr(mx,my)
xscale=float(nx-1)/(mx-1)
yscale=float(ny-1)/(my-1)
for jy=0,my-1 do begin
  for jx=0,mx-1 do begin
    ix=fix(xscale*jx+.5)
    iy=fix(yscale*jy+.5)
    xsamp(jx,jy)=xa(ix,iy)
    ysamp(jx,jy)=ya(ix,iy)
  endfor
endfor
print,' '
print,form='(a,i5,a,i6,a)','Initial selection set contains ', $
        numset,' out of ',nx*ny,' total points'
;
if numset gt 0 then begin
  if max(select) lt 0 then return
endif
ymin=min(ysamp(select))
ymax=max(ysamp(select))
xmin=min(xsamp(select))
xmax=max(xsamp(select))
xrng=[xmin,xmax]
yrng=[ymin,ymax+0.1*(ymax-ymin)]
;yrng=[ymin,ymax]
;
;
; blowup factor for small images
;
if keyword_set(blow_up) then begin
  mult_x=blow_up(0)
  mult_y=blow_up(1)
endif else begin
  mult_x=fix(600/nx) > 1
  mult_y=fix(600/ny) > 1
endelse
imx=mult_x*nx
imy=mult_y*ny
;
!p.multi=0
window,0
window,2, xsize=100+imx, ysize=100+imy
;
; color settings using all available colors
;
numclrs=!d.n_colors-1
iclr=0                              ; initialize color index
; 
; set up color table
;
grey_scl=bytscl(indgen(numclrs))
red=grey_scl
green=grey_scl
blue=grey_scl
if keyword_set(no_color) then begin
; symbols: 1=+, 2=*, 3=dot, 4=diamond, 5=triangle, 6=square, 7=x
;
  ssym=[3,1,7,4,5,6,2]         ; symbol used to plot scatter plot positions
  red_class=replicate(255,n_elements(ssym))
  green_class=red_class
  blue_class=red_class
endif else begin
  ssym        =  [  1,  1,  1,  1,  1,  1,  1,  1,  1,  1]
  red_class   =  [255,255,  0,  0,  0,255,222,150,  0,255]
  green_class =  [  0,255,255,255,  0,  0,150,  0,150,175]
  blue_class  =  [  0,  0,  0,255,255,255,150,100,  0,125]
endelse
num_class=n_elements(red_class)
red(1:num_class)=red_class
green(1:num_class)=green_class
blue(1:num_class)=blue_class
tvlct,red,green,blue
;
class_clr=1+indgen(num_class)       ; color indecies 
gray_bot=num_class+1                ; used to adjust grayscale for tv
gray_top=numclrs-gray_bot           ; used to adjust grayscale for tv
iclr_max=num_class-1
on_color=numclrs
off_color=clr_off*numclrs
rub_color=clr_rub*numclrs
;
if keyword_set(class_in) eq 0 then indx(select)=off_color
;
wset,2
plot,[0,1],[0,1],xstyle=4,ystyle=4,/nodata
xw1=!x.window(0)*!d.x_vsize
xw2=!x.window(1)*!d.x_vsize
yw1=!y.window(0)*!d.y_vsize
yw2=!y.window(1)*!d.y_vsize
pos=[xw1,yw1,xw1+imx-1,yw1+imy-1]
xirng=[0,nx-1]
yirng=[0,ny-1]
if keyword_set(image) then begin
   tv,rebin(gray_bot+bytscl(image,top=gray_top),imx,imy),xw1,yw1
endif
plot,[0,0],[0,0],yrange=yirng,xrange=xirng,/noerase,$
       xstyle=1,ystyle=1,position=pos,/device,title=title
;
wset,0
;
plot,xsamp(select),ysamp(select),xrange=xrng,yrange=yrng,/nodata, $
     color=on_color,title=title,xtitle=xtitle,ytitle=ytitle
oplot,xsamp(select),ysamp(select),psym=ssym(0),color=off_color
psave=!p & xsave=!x & ysave=!y       ; save axis setings for oplot
;
if keyword_set(class_in) then begin
  for ic=0,iclr_max do begin
    points=where(indx eq class_clr(ic),num_points)
    if num_points ne 0 then begin
      print,form="(a,i2,a1,i5,a)",' class ',ic,':',num_points,' points'
      oplot,xsamp(points),ysamp(points),psym=ssym(ic),color=class_clr(ic)
      wset,2
      ypnts=points/mx
      xpnts=points-ypnts*mx
      xpnts=xpnts*xscale
      ypnts=ypnts*yscale
      plot,xpnts,ypnts,yrange=yirng,xrange=xirng,psym=ssym(ic),/noerase, $
          color=class_clr(ic),xstyle=1,ystyle=1,position=pos,/device
;          color=class_clr(ic),xstyle=5,ystyle=5,position=pos,/device
      wset,0
      !p=psave & !x=xsave & !y=ysave  ; restore scatter plot settings
    endif
  endfor
  ians=wmenu(['Do you wish to continue?','Yes','No'],title=0,init=1)
  if ians eq 2 then return
endif
;
dxwin=!x.crange(1)-!x.crange(0)
dywin=!y.crange(1)-!y.crange(0)
dx=dxwin/20
dy=dywin/20
old_dx=dx
old_dy=dy
old_x=0
old_y=0
xmenbox=[-dx,dx,dx,-dx,-dx]
ymenbox=[-dy,-dy,dy,dy,-dy]
xmen1=!x.crange(0)+  dxwin/6
xmen2=!x.crange(0)+2*dxwin/6
xmen3=!x.crange(0)+3*dxwin/6
xmen4=!x.crange(0)+4*dxwin/6
xmen5=!x.crange(0)+5*dxwin/6
ymen=ymax+dy
dxmen=dx
dymen=dy
;
num_points=0
first_time=1
print,' '
print,'Left mouse button decreases box size'
print,'Middle mouse button increases box size'
print,'Right mouse button interupts and displays menu '
print,' '
;
; begin looping
;
repeat begin
;
  cursor,x,y,/nowait
  button=!err
;
;  ------------
;  Menu options
;  ------------
;
  if( button eq 4) then begin
;
; erase cursor box
;
    oplot,[old_x-old_dx,old_x+old_dx,old_x+old_dx,$
          old_x-old_dx,old_x-old_dx],$
          [old_y-old_dy,old_y-old_dy,old_y+old_dy,$
          old_y+old_dy,old_y-old_dy],color=rub_color

    if first_time then begin
      print,' '
      print,' N = Start new class, (assign new color)'
      print,' D = Display current selection set'
      print,' R = Reset selection set and restart'
      print,' P = Plot to postscript file "plot.ps"'
      print,' q = Quit'
      print,' '
      first_time=0
    endif
;
; draw menu boxes
;
    polyfill,xmen1+xmenbox,ymen+ymenbox,color=class_clr(iclr)
    oplot,xmen1+xmenbox,ymen+ymenbox,color=on_color
    xyouts,xmen1,ymen,'N',charsize=1.2,alignment=.5,color=rub_color
    oplot,xmen2+xmenbox,ymen+ymenbox,color=on_color
    xyouts,xmen2,ymen,'D',charsize=1.2,alignment=.5,color=on_color
    oplot,xmen3+xmenbox,ymen+ymenbox,color=on_color
    xyouts,xmen3,ymen,'R',charsize=1.2,alignment=.5,color=on_color
    oplot,xmen4+xmenbox,ymen+ymenbox,color=on_color
    xyouts,xmen4,ymen,'P',charsize=1.2,alignment=.5,color=on_color
    oplot,xmen5+xmenbox,ymen+ymenbox,color=on_color
    xyouts,xmen5,ymen,'q',charsize=1.2,alignment=.5,color=on_color
    
    !err=0
    oclr=iclr
    loop=1
    wait,1
    while (loop) do begin
      cursor,xx,yy,/wait
      iflag=0
      loop=0
      if abs(xx-xmen1) le dxmen and abs(yy-ymen) le dymen then begin
        loop=1
        iclr=(iclr+1) mod num_class
        polyfill,xmen1+xmenbox,ymen+ymenbox,color=class_clr(iclr)
        oplot,xmen1+xmenbox,ymen+ymenbox,color=on_color
        xyouts,xmen1,ymen,'N',charsize=1.2,alignment=.5,color=rub_color
        xsymb=xmen1+.5*dx
        if keyword_set(no_color) then oplot,[xsymb,xsymb],[ymen,ymen],$
             psym=ssym(iclr),color=0
        print,form='($,a,i2,a)',' Color index set to ',iclr,string("15b)
      endif
      if abs(xx-xmen2) le dxmen and abs(yy-ymen) le dymen then iflag=2
      if abs(xx-xmen3) le dxmen and abs(yy-ymen) le dymen then iflag=1
      if abs(xx-xmen4) le dxmen and abs(yy-ymen) le dymen then iflag=4
      if abs(xx-xmen5) le dxmen and abs(yy-ymen) le dymen then iflag=3
      wait,.5
   endwhile
;
; erase menu boxes
;
    polyfill,xmen1+xmenbox,ymen+ymenbox,color=rub_color
    oplot,xmen1+xmenbox,ymen+ymenbox,color=rub_color
    oplot,xmen2+xmenbox,ymen+ymenbox,color=rub_color
    xyouts,xmen2,ymen,'D',charsize=1.2,alignment=.5,color=rub_color
    oplot,xmen3+xmenbox,ymen+ymenbox,color=rub_color
    xyouts,xmen3,ymen,'R',charsize=1.2,alignment=.5,color=rub_color
    oplot,xmen4+xmenbox,ymen+ymenbox,color=rub_color
    xyouts,xmen4,ymen,'P',charsize=1.2,alignment=.5,color=rub_color
    oplot,xmen5+xmenbox,ymen+ymenbox,color=rub_color
    xyouts,xmen5,ymen,'q',charsize=1.2,alignment=.5,color=rub_color
;
    if oclr ne iclr then begin
      num_points=0
      points=-1
    endif
;
; Reset and start over
;
    if iflag eq 1 then begin
      print,'RESET   color index set back to zero'
      iclr=0
      wset,2
      if keyword_set(image) then begin
        tv,rebin(gray_bot+bytscl(image,top=gray_top),imx,imy),xw1,yw1
      endif else begin
        plot,[0,0],[0,0],xrange=xirng,yrange=yirng,xstyle=1,ystyle=1,$
           title=title,/nodata
      endelse
      wset,0
      plot,xsamp(select),ysamp(select),xrange=xrng,yrange=yrng,/nodata, $
           color=on_color,title=title,xtitle=xtitle,ytitle=ytitle 
      oplot,xsamp(select),ysamp(select),psym=ssym(0),color=off_color
      dx=(xmax-xmin)/20
      dy=(ymax-ymin)/20
      old_dx=dx
      old_dy=dy
      old_x=0
      old_y=0
      indx(select)=off_color
      points_in_box=-1
      points=-1
    endif
;
; Display currently selected points
;
    if iflag eq 2 then begin
      print,'DISPLAY selected points'
      plot,xsamp(select),ysamp(select),xrange=xrng,yrange=yrng,/nodata, $
           color=on_color,title=title,xtitle=xtitle,ytitle=ytitle
      oplot,xsamp(select),ysamp(select),psym=ssym(0),color=off_color
      for ic=0,iclr_max do begin
        points=where(indx eq class_clr(ic),num_points)
        if num_points ne 0 then begin
          print,form="(a,i2,a1,i5,a)",' class ',ic,':',num_points,' points'
          oplot,xsamp(points),ysamp(points),psym=ssym(ic),color=class_clr(ic)
          wset,2
          ypnts=points/mx
          xpnts=points-ypnts*mx
          xpnts=xpnts*xscale
          ypnts=ypnts*yscale
          plot,xpnts,ypnts,yrange=yirng,xrange=xirng,psym=ssym(ic),/noerase,$
              color=class_clr(ic),xstyle=1,ystyle=1,position=pos,/device,$
              title=title
          wset,0
          !p=psave & !x=xsave & !y=ysave  ; restore scatter plot settings
        endif
      endfor
    endif
;
; Save to postscript file
;
    if iflag eq 4 then begin
      ans=0
      print,form='($,a)','portrait (0) or landscape (1) ' & read,ans 
      if ans eq 1 then begin
        toggle,/landscape,/color
        !p.multi=[0,2,1]
      endif else begin
        toggle,/portrait,/color
        !p.multi=[0,1,2]
      endelse
;
      plot,xsamp(select),ysamp(select),xrange=xrng,yrange=yrng,/nodata, $
           title=title,xtitle=xtitle,ytitle=ytitle
      oplot,xsamp(select),ysamp(select),psym=ssym(0),color=off_color
      for ic=0,iclr_max do begin
        points=where(indx eq class_clr(ic),num_points)
        if num_points ne 0 then begin
          print,form="(a,i2,a1,i5,a)",' class ',ic,':',num_points,' points'
          if keyword_set(no_color) then begin
            oplot,xsamp(points),ysamp(points),psym=ssym(ic)
          endif else begin
            oplot,xsamp(points),ysamp(points),psym=ssym(ic),color=class_clr(ic)
          endelse  
        endif
      endfor
;
      plot,[0],[0],xstyle=4,ystyle=4,/nodata
      xi1=!x.window(0)*!d.x_vsize
      xi2=!x.window(1)*!d.x_vsize
      yi1=!y.window(0)*!d.y_vsize
      yi2=!y.window(1)*!d.y_vsize
;
      
      aspect=float(nx)/ny
      xsize=xi2-xi1
      ysize=yi2-yi1
      if xsize gt ysize*aspect then xsize=ysize*aspect else ysize=xsize/aspect 
      if keyword_set(image) then begin
        tv,gray_bot+bytscl(image,top=gray_top),xi1,yi1, $
              xsize=xsize,ysize=ysize,/device
             posi=[xi1,yi1,xi1+xsize,yi1+ysize]
             plot,[0],[0],yrange=yirng,xrange=xirng,/noerase,/nodata, $
                  xstyle=5,ystyle=5,position=posi,/device
      endif else begin
        plot,[0,0],[0,0],xrange=xirng,yrange=yirng,xstyle=1,ystyle=1,$
           title=title,/nodata
      endelse

;
      for ic=0,iclr_max do begin
        points=where(indx eq class_clr(ic),num_points)
        if num_points ne 0 then begin
          ypnts=points/mx
          xpnts=points-ypnts*mx
          xpnts=xpnts*xscale
          ypnts=ypnts*yscale
          if keyword_set(no_color) and keyword_set(image) then $
            oplot,xpnts,ypnts,psym=ssym(ic),color=0,symsize=1.1
          oplot,xpnts,ypnts,psym=ssym(ic),color=class_clr(ic)
        endif
      endfor
;
      !p.multi=0
      toggle
      !p=psave & !x=xsave & !y=ysave  ; restore scatter plot settings
    endif
;
; Quit
;
    if iflag eq 3 then begin
      print,'Refresh and QUIT'
      plot,xsamp(select),ysamp(select),xrange=xrng,yrange=yrng,/nodata, $
           color=on_color,title=title,xtitle=xtitle,ytitle=ytitle
      oplot,xsamp(select),ysamp(select),psym=ssym(0),color=off_color
      for ic=0,iclr_max do begin
        points=where(indx eq class_clr(ic),num_points)
        if num_points ne 0 then begin
          print,form="(a,i2,a1,i5,a)",' class ',ic,':',num_points,' points'
          oplot,xsamp(points),ysamp(points),psym=ssym(ic),color=class_clr(ic)
        endif
      endfor
      class_out=indx
      return
    endif
    wait,1
  endif else begin
;
;  -------------------------------------
;  move cursor box and select new points
;  -------------------------------------
;
    if x ne old_x or y ne old_y or button ne 0 then begin
;
;  Select points
;
      x1=x-dx
      x2=x+dx
      y1=y-dy
      y2=y+dy
      points_in_box=where(xsamp ge x1 and xsamp le x2 and ysamp ge y1 $
               and ysamp le y2 and indx ne 0, nc)
;
      num_points=n_elements(points)
      if num_points eq 1 then $
         if points(0) eq -1 then num_points=0
;
      num_points_in_box=n_elements(points_in_box)
      if num_points_in_box eq 1 then $
       if points_in_box(0) eq -1 then num_points_in_box=0
;
      if ( num_points_in_box gt 0 ) then begin
        indx(points_in_box)=class_clr(iclr)
        points=where(indx eq class_clr(iclr),num_points)
      endif
;
;  Move cursor redraw selected points
;  Resize cursor box when mouse buttons 1 or 2 are pressed
;
      if ( button eq 1 ) then begin 
        dx=.9*dx 
        dy=.9*dy
      endif
      if ( button eq 2 ) then begin
        dx=dx/.9
        dy=dy/.9
      endif
      oplot,[old_x-old_dx,old_x+old_dx,old_x+old_dx,$
            old_x-old_dx,old_x-old_dx],$
            [old_y-old_dy,old_y-old_dy,old_y+old_dy,$
            old_y+old_dy,old_y-old_dy],color=rub_color
      oplot,[x-dx,x+dx,x+dx,x-dx,x-dx],$
            [y-dy,y-dy,y+dy,y+dy,y-dy],color=off_color
      if (num_points eq 1) then begin
        xpnt=xsamp(points(0))
        ypnt=ysamp(points(0))
        oplot,[xpnt],[ypnt],psym=ssym(iclr),color=class_clr(iclr)
      endif
      if (num_points gt 1) then begin
        oplot,xsamp(points),ysamp(points),psym=ssym(iclr),color=class_clr(iclr)
      endif
      oplot,[x-dx,x+dx,x+dx,x-dx,x-dx],$
            [y-dy,y-dy,y+dy,y+dy,y-dy],color=off_color
      old_dx=dx
      old_dy=dy
      old_x=x
      old_y=y
    endif
  endelse 
endrep until 0
end






