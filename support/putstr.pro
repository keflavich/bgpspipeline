pro putstr,label,xs,ys,orient=orient,charsize=charsize,color=color,$
      subnorm=subnorm,norm=norm,align=align,contrast=contrast
;+
; ROUTINE:
;   putstr
; 
; PURPOSE:
;   use cursor to position and orient text on a plot
;
; USEAGE:
;   putstr,label,xs,ys,orient=orient,charsize=charsize,color=color,$
;                 subnorm=subnorm,norm=norm,align=align,pschar=pschar
;
; INPUT:
;
;  label
;    text label, type string
;
;  xs
;    x position of string (data coordinates, default)
;
;  ys
;    y position of string (data coordinates, default)
;
;
; KEYWORD INPUT:
;
;  orient
;    orientation in degrees
;
;  charsize
;    character size parameter.  The character size is the value of 
;    CHARSIZE * !p.charsize.  (default=1)
;
;  subnorm
;    if set, x and y positions are specified in data window
;    sub-normalized coordinates, i.e, the range 0 to 1 spans the entire
;    data coordinate range.  Note that this is different then the
;    usual IDL normalized coordinates.  When SUBNORM is set, a
;    given x,y coordinate causes the text to appear in the same
;    data window region regardless of how the x and y axes are
;    scaled. LEGEND also uses this coordinate system.
;
;  norm
;    if set, x and y positions are specified in usual IDL normalized
;    coordinates, i.e, the range 0 to 1 spans the entire window
;    display range.
;
;  align
;    the text alignment point.  
;
;    ALIGN=0.0 =>  text is left justified to x,y
;    ALIGN=0.5 =>  text is centered at x,y
;    ALIGN=1.0 =>  text is right justified to x,y
;    
;    The use of ALIGN is particularly useful to center or justify a
;    multiline text string (see example).  Also, keep in mind the
;    length of a string isn't always predictable when written to a
;    hardcopy device. ALIGN should be used if you want to center or
;    right justify a string to line up with something.
;               
;  contrast
;    if set, PUTSTR writes the string twice; the first time the string
;    will be drawn with very thick lines and in a contrasting color.
;    The second time it will be drawn at the standard line thickness
;    (from !p.thick) and with the color set by the color keyword.  You
;    can control the thickness and the background color by setting
;    CONTRAST to a two element vector, [thick,color]. This option
;    should be used to draw annotation within image areas, where the
;    legibility may otherwise suffer due to lack of contrast.
;
; KEYWORD INPUT:
; 
; OUTPUT:
;    none
; 
; DESCRIPTION:
;   Use PUTSTR to interactively position a text label on a plot.  The
;   size and orientation of the text label are adjusted by pressing
;   the left or middle mouse buttons.  Initially the LMB and MMB
;   control the size of the label.  To enable the use of the LMB and
;   MMB to control the label orientation angle, press the RMB and
;   select the ANGLE menu item.
;               
;   To quit the proceedure press RMB and select the "QUIT" menu item.
;   
;   On exit, the PUTSTR command line options which will reproduce the
;   text in the final position and orientation is printed to the
;   terminal.  This string may be appended to the original PUTSTR
;   comand using xwindows cut and paste.
;   
;   For similar text annotation capabiltiy see LEGEND.PRO
;
; EXAMPLE:
;
;;; interactive placement of text strings:
;
; plot,randf(200,2)
; t1='Use PUTSTR to interactively position a text label!c'
; t2='on a plot.   The size and orientation of the text label!c'
; t3='are adjusted by pressing the left or middle mouse buttons.'
; text=t1+t2+t3
; putstr,text
; putstr,text,align=.5
; putstr,text,align=1
;
;;; use putstr in non-interactive mode
;
; !p.multi=[0,1,2]
; window,0,xs=600,ys=900
; plot,randf(200,2),ymargin=[10,2]
; text='Figure 1. Dew point temperature as a function of!c' + $
;      '          foobar position relative to mordant.'
; putstr,text,/subnorm,0.0,-0.2,charsize=2.0,orient=0.0
; plot,randf(200,3),ymargin=[10,2]
; text='Figure 2. Triple point temperature as a function of!c' + $
;      '          mordant position relative to foobar.'
; putstr,text,/subnorm,0.0,-0.2,charsize=2.0,orient=0.0
; 
;-
!err=0

csz=!p.charsize

IF n_elements(color) eq 0 THEN color = !p.color

IF NOT keyword_set(charsize) THEN charsize=1.

IF NOT keyword_set(orient) THEN orient = 0
IF NOT keyword_set(subnorm) THEN subnorm = 0
IF NOT keyword_set(norm) THEN norm = 0
IF subnorm THEN norm = 0
IF NOT keyword_set(align) THEN align = 0


IF n_elements(xs) eq 0  THEN BEGIN 
  fmt = '(",",g20.4,",",g20.4,",","charsize=",f3.1,",","orient=",f5.1)'
  
  if !x.crange(0) eq !x.crange(1) then plot,[0,1],xstyle=5,ystyle=5,/nodata
  xold = (!x.crange(0)+!x.crange(1))/2
  yold = (!y.crange(0)+!y.crange(1))/2
  xxx = convert_coord(xold,yold,/data,/to_device)
  tvcrs,xxx(0,0),xxx(1,0)
  orieno = 0
  charsizeo = charsize

  !err = 0

  device, get_graphics = old, set_graphics = 6  ,cursor_standard=17 ;Set xor
  xyouts,xold,yold,label,orient=orieno,charsize=charsizeo*csz,align=align

  mode = 1

  WHILE mode NE 3 DO begin
    IF !err EQ 0 THEN BEGIN
      cursor,xx,yy,/change  ; wait for change of state to suppress flicker
    ENDIF ELSE BEGIN
      cursor,xx,yy,/nowait  ; change size or orientation 
    ENDELSE                 ; continuously when button pressed 
    

    xyouts,xold,yold,label,orient=orieno,charsize=charsizeo*csz,align=align
    xyouts,xx,yy,label,orient=orient,charsize=charsize*csz,align=align

    xold = xx
    yold = yy
    orieno = orient
    charsizeo = charsize

    IF !err EQ 4 THEN BEGIN
      if not keyword_set(orient) then begin
        mode=3
      endif else begin
        mode = WMENU(['Mode', 'size', 'angle','quit'], TITLE=0, INIT=mode+1)
        xxx = convert_coord(xx,yy,/data,/to_device)
        tvcrs,xxx(0,0),xxx(1,0)
      endelse
    ENDIF
    IF !err EQ 1 THEN BEGIN
      IF mode EQ 1 THEN charsize = (charsize-.01) > .001
      IF mode EQ 2 THEN BEGIN
        orient = orient-1
        IF orient LT -180 THEN orient = orient+360
      ENDIF 
    ENDIF
    IF !err EQ 2 THEN BEGIN
      IF mode EQ 1 THEN charsize = (charsize+.01)
      IF mode EQ 2 THEN BEGIN
        orient = orient+1
        IF orient GT 180 THEN orient = orient-360
      ENDIF
    ENDIF
  endwhile

  device,set_graphics = old, cursor_standard=30

  CASE 1 OF 
    subnorm: BEGIN
      if !x.type eq 1 then xxx=alog10(xx) else xxx=xx
      if !y.type eq 1 then yyy=alog10(yy) else yyy=yy
      xs = (xxx-!x.crange(0))/(!x.crange(1)-!x.crange(0))
      ys = (yyy-!y.crange(0))/(!y.crange(1)-!y.crange(0))
    END
    norm: BEGIN
      xxx = convert_coord(xx,yy,/data,/to_norm)
      xs = xxx(0,0)
      ys = xxx(1,0)
    END
    ELSE: BEGIN
      xs = xx
      ys = yy
    END
  ENDCASE

  ostring = strcompress( string(f = fmt, xs,ys,charsize,orient),/remove_all)

  print,ostring

  if keyword_set(contrast) then begin
    othck=!p.thick
    if n_elements(contrast) eq 2 then begin
      thick,contrast(0)
      bcolor=contrast(1)
    endif else begin
      thick,5
      if color lt !p.color/2 then bcolor=!p.color else bcolor=1
    endelse
    xyouts,xx,yy,label,charsize=charsize*csz,orient=orient, $
       color=bcolor,align=align
    !p.thick=othck
  endif            

  xyouts,xx,yy,label,charsize=charsize*csz,orient=orient, $
     color=color,align=align

ENDIF ELSE BEGIN

  CASE 1 OF
    subnorm: BEGIN
      x0 = !x.crange(0)+xs*(!x.crange(1)-!x.crange(0))
      y0 = !y.crange(0)+ys*(!y.crange(1)-!y.crange(0))
      if !x.type eq 1 then x0=10.^x0
      if !y.type eq 1 then y0=10.^y0
      norm=0
    END
    norm: begin & x0=xs & y0=ys & norm=1 &   end
    ELSE: begin & x0=xs & y0=ys & norm=0 &   end
  ENDCASE
  if keyword_set(contrast) then begin
    othck=!p.charthick
    if n_elements(contrast) eq 2 then begin
      !p.charthick=contrast(0)
      bcolor=contrast(1)
    endif else begin
      !p.charthick=5
      if color lt !p.color/2 then bcolor=!p.color else bcolor=1
    endelse
    xyouts,x0,y0,label,charsize=charsize*csz,orient=orient,color=bcolor,$
           align=align,norm=norm
    !p.charthick=othck
  endif            

  xyouts,x0,y0,label,charsize=charsize*csz,orient=orient,$
             color=color,align=align,norm=norm
ENDELSE
  
return
END

