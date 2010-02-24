PRO sprite,xvec,yvec,psym=psym,color=color,init=init,$
           xtitle=xtitle,ytitle=ytitle
;+
;ROUTINE:      sprite
;
;PURPOSE:      
;    interactive display of multi parameter correspondences.  Points
;    corresponding to a single independent index variable is hilighted
;    by a small "sprite" symbol on several plot frames simultaneously. 
;    The sprite position is controlled by the master index, which can
;    be incremented/decremented via the mouse.
;                
;
;USEAGE:
;    plot,x1,y1 & sprite,x1,y1,/init
;    plot,x2,y2 & sprite,x2,y2
;    plot,x3,y3 & sprite,x3,y3
;      ...
;    sprite
;               
;
;INPUT:
;
;  xvec
;    x vector for current plot. Only required when accumulating the
;    DATA and CONTROL info after each plot. If xvec and yvec are not
;    set, SPRITE executes in interactive mode
;
;  yvec 
;    y vector for current plot. Only required when accumulating the
;    DATA and CONTROL info after each plot.
;
;
;KEYWORD INPUT:
;
;  init
;    Set the keyword to reinitialize SPRITE for a new set of plots.
;
;  psym
;    symbol used to indicate sprite
;
;  color
;    color index used to draw sprite
;
;  xtitle
;    title of x variable for current plot, used to label quantity in
;    print out widget.
;
;  ytitle
;    title of y variable for current plot, used to label quantity in
;    print out widget.
;
;
; DISCUSSION:   SPRITE operates in two modes:
;
;    1. in accumulation mode SPRITE is called immediately after each
;    plot is written to the screen.  Multiple plot frames can be
;    accumulated because SPITE stores all the data and plot geometry
;    information in an internal common block, SPRITE_BLK, for latter
;    use. 
;    
;    NOTE:   SPRITE ignors the values of PSYM, COLOR and
;            LABELS while in accumulation mode.
;    
;    2. In interactive mode a sprite control window is created with
;    several mouse-sensitive areas defined.  Pressing a mouse button
;    in one of these areas causes the following actions:
;    
;    control area    action
;    ------------    ------
;    QUIT            quit 
;      <<            move sprite backward taking large steps
;      <             move sprite backward one step
;      >             move sprite forward one step
;      >>            move sprite forward taking large steps
;    
;    Using the MMB in the "<", ">" areas causes the sprite to pause
;    between steps and to update the print-out widget after each step.
;    Otherwise, if the LMB or RMB is used, the print-out widget is
;    updated only after the button is released.
;
;
; SIDE EFFECTS: 
;    Draws a sprite on each of the plot frames
;
;    While in operations the XOR graphics mode is set.
;
;    If psym is not set, user symbol, psym=8, is redefined to a filled
;    diamond
;
; COMMON BLOCKS:
;    sprite_blk
;  
; EXAMPLE:
;
;; use sprite to show solar flux values :
;
;       !p.multi=0
;       solar,wv,f
;       xtitle='wavenumber' & ytitle='W/m2' & title='irradiance'
;       plot,wv,f,xtitle=xtitle,ytitle=ytitle,title=title
;       sprite,wv,f,xtitle=xtitle,ytitle=title,/init
;       sprite,color=150
;
;; try a four frame plot 
; 
;       !p.multi=[0,2,2]
;       time=findgen(100)*10 & tlab='Time (hours)'
;       lon=-90+10*cos(!dtor*time)+randf(100,3)
;       lat=30+5*sin(!dtor*time)+randf(100,3)
;       alt=5000*sin(time*!pi/999)+2000*randf(100,3.3)
;       ch1=10.+randf(100,3)
;       ch2=25.+randf(100,2.5)^3
;       plot,lon,lat,/yno,xtit='Longitude',ytit='Latitude',title='Flight path'
;       sprite,lon,lat,xtit='Longitude',ytit='Latitude',/init     ; initialize 
;       plot,time,alt,xtitle=tlab,title='Altitude',ytitle='meters'
;       sprite,time,alt,xtitle=tlab,ytitle='Altitude'
;       plot,time,ch1,xtitle=tlab,title='Ch1 flux'
;       sprite,time,ch1,ytitle='Ch1 flux'
;       plot,time,ch2,xtitle=tlab,title='Ch2 flux'
;       sprite,time,ch2,ytitle='Ch2 flux'
;       loadct,5
;       sprite,color=150
;
;; You can also have two sprites in one plot frame:
;
;       !p.multi=[0,1,2]
;       w8x11
;       y2=randf(10000,3) & x1=indgen(10000)
;       y1=y2+.5*randf(10000,2)
;       !p.font=-1
;       plot,x1,y1  ,xtitle='time',ytitle='ch1 and ch2 flux'
;       sprite,x1,y1,xtitle='time',ytitle='ch1 flux',/init      ; initialize 
;       oplot,x1,y2,li=3
;       sprite,x1,y2,ytitle='ch2 flux'
;       sprite,color=150
;
; 
; AUTHOR:   Paul Ricchiazzi                       2 March 95
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;-
;
common sprite_blk,data,control,labels

if not keyword_set(xtitle) then xtitle=''
if not keyword_set(ytitle) then ytitle=''

IF keyword_set(init) THEN BEGIN
  xmn = !x.crange(0) & xmx = !x.crange(1)   ; limit range to
  ymn = !y.crange(0) & ymx = !y.crange(1)   ; avoid PLOTS crashes
  data = [[reform(xvec) > xmn < xmx ],[reform(yvec) > ymn < ymx]]
  control = [!x,!y]				
  labels=[xtitle,ytitle]
  return
ENDIF

IF keyword_set(xvec) THEN BEGIN
  xmn = !x.crange(0) & xmx = !x.crange(1) 
  ymn = !y.crange(0) & ymx = !y.crange(1)
  data = [[data],[reform(xvec) > xmn < xmx ],[reform(yvec) > ymn < ymx]]
  control = [control,!x,!y]
  labels=[labels,xtitle,ytitle]
  return
ENDIF

;
; DATA, CONTROL and LABELS are ready to be used
;

IF NOT keyword_set(psym) THEN BEGIN
  xsym=[-1,0,1,0,-1] & ysym=[0,1,0,-1,0] 
  usersym,1.5*xsym,1.5*ysym,/fill
  psym = 8
ENDIF

IF NOT keyword_set(color) THEN color = .75*!p.color

nfrm = n_elements(control)/2


font = !p.font

;
;       set up control window
; 

dispwin=!d.window
xsdsp=400 & ysdsp=100
window,/free,xs=xsdsp,ys=ysdsp,xpos=200,ypos=200,title='SPRITE CONTROL'
cntrlwin=!d.window
xbot=[1,2,3]*(xsdsp-1)/4
yreg=.5*(ysdsp-1)
for j=0,n_elements(yreg)-1 do plots,[0,xsdsp-1],[yreg(j),yreg(j)],/dev
for i=0,n_elements(xbot)-1 do plots,[xbot(i),xbot(i)],[0,yreg],/dev
xyouts,(xsdsp)/2,.75*ysdsp,'QUIT',/dev,align=.5,charsize=1.4
xyouts,(xbot(0))/2,.25*ysdsp,'<<',/dev,align=.5,charsize=1.4
xyouts,(xbot(0)+xbot(1))/2,.25*ysdsp,'<',/dev,align=.5,charsize=1.4
xyouts,(xbot(1)+xbot(2))/2,.25*ysdsp,'>',/dev,align=.5,charsize=1.4
xyouts,(xbot(2)+xsdsp)/2,.25*ysdsp,'>>',/dev,align=.5,charsize=1.4

;
; set XOR graphics mode
;


device, get_graphics = old, set_graphics = 6  ,cursor_standard=94 ;Set xor


tvcrs,(xbot(1)+xbot(2))/2,.75*ysdsp

;
; set up value labels for XMESSAGE window
;

ilab=where(labels ne '',nlab)
if nlab ne 0 then begin
  labl=labels(ilab)
endif else begin
  ilab=indgen(2*nfrm)
  nlab=2*nfrm
  labx=strcompress("x"+string(indgen(nfrm)),/remove_all)
  laby=strcompress("y"+string(indgen(nfrm)),/remove_all)
  labl=transpose([[labx],[laby]])
  labl=reform(labl,2*nfrm)
endelse

nel = n_elements(data(*,0))
ii = fix(.1*(nel-1))
io = ii

wset,dispwin
FOR ifrm = 0,nfrm-1 DO BEGIN
  !x = control(2*ifrm)
  !y = control(2*ifrm+1)
  xx = data(*,2*ifrm)
  yy = data(*,2*ifrm+1)
  plots,xx(ii),yy(ii),psym = psym,color = color
ENDFOR

fontfixed="-misc-fixed-bold-r-normal--13-120-75-75-c-80-iso8859-1"
str=[string(f='(a20,i20)',"INDEX",ii),$
     string(f='(a20)',labl)+string(f='(g20.4)',data(ii,ilab))]
xmessage,str,wbase=wbase,wlabels=wlabels,title="sprite",font=fontfixed

dii=2
nbutton=1
loopit=1
while loopit do begin
  wset,cntrlwin 
  cursor,x,y,/nowait,/dev
  if !err ne 0 then begin 
    if y gt yreg then begin
      if nbutton eq 1 then loopit=0 else tvcrs,x,.25*ysdsp
    endif else begin
      case 1 of
        x lt xbot(0): begin                                  ; fast reverse
          f=(x-xbot(0))/float(0.-xbot(0))
          dii=fix(2*(1-f)+f*(nel)/50)
          ii=(ii-dii+nel) mod nel 
          if y lt .1*ysdsp or y gt .45*ysdsp then tvcrs,x,.25*ysdsp
        end
      
        x lt xbot(1): begin                                  ; reverse
          ii=(ii-1+nel) mod nel
          if !err eq 2 then wait,.2
          if y lt .1*ysdsp or y gt .45*ysdsp then tvcrs,x,.25*ysdsp
        end
    
        x lt xbot(2): begin                                  ; play
          ii=(ii+1+nel) mod nel
          if !err eq 2 then wait,.2
          if y lt .1*ysdsp or y gt .45*ysdsp then tvcrs,x,.25*ysdsp
        end
    
        else: begin                                  ; fast forward
          f=(x-xbot(2))/float(xsdsp-xbot(2))
          dii=fix(2*(1-f)+f*(nel)/50)
          ii=(ii+dii+nel) mod nel 
          if y lt .1*ysdsp or y gt .45*ysdsp then tvcrs,x,.25*ysdsp
        end
       
      endcase 
      
    endelse

    if !err eq 2 then begin
      str=[string(f='(a20,i20)',"INDEX",ii),$
           string(f='(a20)',labl)+string(f='(g20.4)',data(ii,ilab))]
      xmessage,str,relabel=wlabels
    endif

    wset,dispwin
    FOR ifrm = 0,nfrm-1 DO BEGIN
      !x = control(2*ifrm)
      !y = control(2*ifrm+1)
      xx = data(*,2*ifrm)
      yy = data(*,2*ifrm+1)
      plots,xx(io),yy(io),psym = psym,color = color
      plots,xx(ii),yy(ii),psym = psym,color = color
    ENDFOR
  
    io = ii
    nbutton=0

  endif else begin
     str=[string(f='(a20,i20)',"INDEX",ii),$
          string(f='(a20)',labl)+string(f='(g20.4)',data(ii,ilab))]
     xmessage,str,relabel=wlabels
     cursor,xdum,ydum,/wait
     nbutton=1
  endelse
endwhile

;;; close up shop,  wipe out sprites and kill XMESSAGE


FOR ifrm = 0,nfrm-1 DO BEGIN 
  !x = control(2*ifrm)
  !y = control(2*ifrm+1)
  xx = data(*,2*ifrm)
  yy = data(*,2*ifrm+1)
  plots,xx(ii),yy(ii),psym = psym,color = color
ENDFOR

wdelete,cntrlwin

xmessage,kill=wbase

device, set_graphics = 3 ,cursor_standard=30

return
END








