pro tv_polar,psi,phi,theta,style=style,grdres=grdres,title=title,rot=rot, $
             image=image,xvec=xvec,yvec=yvec,phitics=phitics,half=half, $
             thetics=thetics,charsize=charsize,thephi=thephi,rmarg=rmarg, $
             labels=labels,colors=colors,lcharsize=lcharsize,stitle=stitle, $
             showpnts=showpnts,range=range,lower=lower,gclr=gclr, $
             clevels=clevels,noscale=noscale,barwidth=barwidth, $
             c_thick=c_thick,c_color=c_color,xtitle=xtitle,nadir=nadir
;+
; ROUTINE:    
;   tv_polar
; 
; USEAGE:     
;   tv_polar,psi,phi,theta
;
;   tv_polar,psi,phi,theta,style=style,grdres=grdres,title=title,rot=rot, $
;            image=image,xvec=xvec,yvec=yvec,phitics=phitics,half=half, $
;            thetics=thetics,charsize=charsize,thephi=thephi,rmarg=rmarg, $
;            labels=labels,colors=colors,lcharsize=lcharsize,stitle=stitle, $
;            showpnts=showpnts,range=range,lower=lower,gclr=gclr, $
;            clevels=clevels,noscale=noscale,barwidth=barwidth, $
;            c_thick=c_thick,c_color=c_color,xtitle=xtitle,nadir=nadir
;
; PURPOSE:    
;   Display of images defined in polar coordinates (without resorting
;   to IDL's mapping routines).
;
; INPUT:
;   psi      
;     image quantity (2-d array) one value at each (phi,theta) point
;     note that the phi coordinate is the first index
;
;   phi
;     monitonically increasing vector specifying azimuthal coordinate
;     PHI must span either 0 to 360 degrees or 0 to 180 degrees.  If
;     phi spans 0-180 degrees and the keyword HALF is not set, then
;     reflection symmetry is assumed, i.e.,
;     r(phi,theta)=r(360-phi,theta).
;
;   theta
;     monitonically increasing vector specifying polar coordinate (degrees)
; 
; KEYWORD INPUT:
;
;   style
;     0   do not plot anything, just return image,xvec and yvec
;     1   use confill for plot
;     2   use tvim for plot
;     3   use contour for plot, no grey scale
;
;   title
;     plot title
;
;   grdres
;     number of grid points in cartesian grid used to rebin polar
;     information.  Array size is (grdres x grdres) default=51
;
;   phitics
;     azimuth tic mark spacing in degrees 
;
;   thetics
;     polar angle tic mark spacing in degrees
; 
;   half
;     if set, the part of the polar plot with azimuth angles between
;     180 and 360 is not displayed.  if HALF lt 0 the half circle is
;     inverted so that the horizontal axis is at the top of the plot 
;     and the magnitude of HALF is the vertical offset (in character 
;     heights) below the previous plot (which is presumed to be a 
;     TV_POLAR plot of the upper hemisphere).  If abs(HALF) le 2 then
;     xaxis labeling is disabled. This option requires column major
;     ordering, i.e., either !P.MULTI(4)=1 or !P.MULTI(1)=1
;     Don't set HALF if ROT ne 0. (see example)
;
;   thephi
;     vector of azimuth angles at which to annotate polar angles.  For
;     example setting THEPHI=[45,315] causes all the polar angles
;     listed in THETICS to be labeled at azimuth angles 45 and 315.
;     If maximum element of THEPHI is negative then the 
;     (default is 45 degrees)
;
;   charsize
;     character size multiplier used on all plot labels but not on
;     color scale labels
;
;   rot
;     set location of azimuth zero point and direction of increase
;
;     0    right , azimuth increases counterclockwise (default)
;     1    top   , azimuth increases counterclockwise
;     2    left  , azimuth increases counterclockwise
;     3    bottom, azimuth increases counterclockwise
;     4    top   , azimuth increases clockwise       (standard compass)
;     5    left  , azimuth increases clockwise
;     6    bottom, azimuth increases clockwise
;     7    left  , azimuth increases clockwise
;             
;
;   range
;     two or three element vector indicating physical range over which
;     to map the color scale.  The third element of RANGE, if
;     specified, sets the step interval of the displayed color scale.
;     It has no effect when SCALE is not set. E.g., RANGE=[0., 1.,
;     0.1] will cause the entire color scale to be mapped between the
;     physical values of zero and one; the step size of the displayed
;     color scale will be set to 0.1.  RANGE overides CLEVELS.
;
;   rmarg
;     right margin expansion factor to provide more room for extra
;     wide color scale annotation (default=1)
;
;   labels
;     a vector of strings used to label the color key levels.  If not
;     set the default color key number labels are used.  If the number
;     of elements in LABELS is the same as the number of elements in
;     COLORS then the labels will appear in the middle of a given
;     color band instead of at the boundary between colors.  If COLORS
;     is not set the number of elements in LABELS should be at least
;     as large as the number of color key segments plus one.
;
;   colors
;     an array of color indicies.  When the COLORS array is set TVIM
;     will map values of A into the color values specified in COLORS.
;     How physical values are assigned to color values depends on how
;     the RANGE parameter is set, as shown in this table:
;     
;               RANGE           color_value
;               -----           -----------
;         1.  not set          COLORS(A)
;         2.  [amin,amax]      COLORS((A-amin)/dinc)
;         3.  [amin,amax,inc]  COLORS((A-amin)/inc)
;     
;     where amin, amax and inc are user specified elements
;     of RANGE and dinc=(amax-amin)/n_elements(COLORS).  In
;     case 1, A is used directly as a subscript into COLORS.
;
;   lcharsize
;     character size of color key number or labels
;
;   stitle
;     color key title (drawn to the right of color scale) 
;
;   contour
;     if set draw contour lines 
;
;   showpnts
;     if set original grid of (phi,theta) points are ploted on the
;     image
;
;   gclr
;     the color used for grid labels and axis, default=!p.color
;
;   clevels
;     a vector of contour levels
;
;   barwidth
;     width of color key which appears to right of contour plot (default=1).
;
;   noscale
;     if set don't draw color scale to the right of the plot
;
;   c_thick
;     thickness of contour lines, set to zero to eliminate contour lines
;
;   c_color
;     color of contour lines (special interpretation of c_color is
;     possible when CONFILL is used, see CONFILL documentation)
;     
;   lower
;     if set, theta values between 90 and 180 are ploted
;
;   nadir
;     if set, theta (which are usually zenith values) is displayed 
;     as 180-theta
;
;   xtitle
;     title for horizontal axis when HALF is set, the titles would
;     usually be either "nadir angle" or "zenith angle", 
;
; OUTPUT:
;     none
;
; KEYWORD OUTPUT:
;   image
;     rebined image of size (grdres,grdres) 
;
;   xvec
;     vector of x coordinate values
;
;   yvec
;     vector of y coordinate values
;
;     These optional output quantities can be used to overplot contour
;     lines over the TV_POLAR output.
;
; EXAMPLE:
;
;; show all styles
;
;    loadct,5
;    phi=findgen(25)*15
;    theta=5+findgen(17)*5
;    psi=(cos(4*phi*!dtor)#sin(5*theta*!dtor))^2
;    w11x8 &  !p.multi=[0,3,2]
;    tvim,psi,xrange=phi,yrange=theta,/interp
;    for s=1,3 do TV_POLAR,psi,phi,theta,style=s,c_thick=0
;    tv_polar,psi,phi,theta,style=1
;    tv_polar,psi,phi,theta,style=2
;
;; show all ROT possibilities
;
;    w8x11 & !p.multi=[0,2,4]
;    loadct,5
;    phi=findgen(25)*15
;    theta=5+findgen(14)*5
;    psi=(phi*!dtor)#replicate(1.,n_elements(theta))
;    title="ROT = " + string(f='(i2)',indgen(8))+repchr(50,' ')
;    for rot=0,7 do TV_POLAR,psi,phi,theta,rot=rot,title=title(rot),sty=2,c_t=0
;
;; plot radiance in lower and upper hemisphere
;
;
;    t=[0,15,32,45,60,70,80,89,91,100,110,120,135,148,165,180.]
;    p=[0,15,30,45,60,75,90,105,120,135,150,165,180.]
;    r=fltarr(13,16) & read,r
;           81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 81, 
;           96, 95, 93, 91, 87, 85, 84, 83, 80, 76, 74, 74, 73, 
;          130,128,123,119,113,103, 95, 92, 84, 81, 80, 77, 75, 
;          184,181,171,153,136,126,110,104, 93, 90, 84, 82, 84, 
;          293,279,243,212,182,152,134,117,106, 99, 90, 93, 80, 
;          388,370,323,250,208,165,144,119,110, 98, 91, 91, 90, 
;          513,448,344,274,194,160,127,106, 97, 82, 82, 72, 74, 
;          184,165,101, 71, 48, 40, 28, 26, 21, 19, 18, 18, 16, 
;           97, 94, 89, 81, 73, 66, 60, 55, 52, 49, 47, 46, 45, 
;          168,163,151,135,120,107, 96, 87, 80, 75, 71, 69, 69, 
;          244,232,208,181,157,136,120,108, 98, 91, 87, 84, 83, 
;          322,299,257,216,183,156,136,120,109,101, 95, 92, 91, 
;          356,332,284,238,199,169,146,129,117,108,102, 98, 97, 
;          291,281,254,222,193,168,148,132,121,112,107,103,102, 
;          200,198,191,181,170,158,148,139,131,125,121,119,118, 
;          148,148,148,148,148,148,148,148,148,148,148,148,148. 
;;
;  nclr=12 & cl=findrng(0,550,nclr) & clr=!d.n_colors*(1+findgen(nclr))/nclr
; !p.multi=[0,2,4,1,1] & w8x11 & !y.omargin=[12,0] & set_charsize,2
;  loadct,5 & xtz='Zenith Angle' & xtn='Nadir Angle' 
;
; tv_polar,r,p,t,xt=xtz,/half,clevels=cl,colors=clr,/noscale
; tv_polar,r,p,t,half=-4,/lower,clevels=cl,colors=clr,/noscale
;
; tv_polar,r,p,t,xt=xtn,/half,clevels=cl,colors=clr,/noscale,/nadir
; tv_polar,r,p,t,half=-4,/lower,clevels=cl,colors=clr,/noscale,/nadir
;
; tv_polar,r,p,t,/half,clevels=cl,colors=clr,/noscale
; tv_polar,r,p,t,half=-3,/lower,clevels=cl,colors=clr,/noscale
;
; tv_polar,r,p,t,/half,clevels=cl,colors=clr,/noscale
; tv_polar,r,p,t,half=-2,/lower,clevels=cl,colors=clr,/noscale
;
; color_bar,cl,clr,pos=[0.1,0.05,0.9,0.12],title='Radiance (W/m!a2!n/um/sr)'
; !y.omargin=0
; 
; DEPENDENCIES
;     TVIM, COLOR_KEY, CONTLEV, FINTERP, GENGRID, CONFILL, BOXPOS
;
; AUTHOR:     Paul Ricchiazzi    oct92 
;             Earth Space Research Group, UCSB
;-

if n_params() eq 0 then begin
  xhelp,'tv_polar'
  return
endif  

usersym,cos(findgen(37)*10*!dtor),sin(findgen(37)*10*!dtor),/fill
if n_elements(gclr) eq 0 then gclr=!p.color

if keyword_set(charsize) eq 0 then  $
   if !p.charsize eq 0 then charsize=1 else charsize=!p.charsize
charsz=charsize
if !p.multi(1) gt 2 or !p.multi(2) gt 2 then charsz=.5*charsize 

if not keyword_set(rot) then rot=0
if keyword_set(image) eq 0 then image=0  
if keyword_set(grdres) eq 0 then grdres=100
if max(phi)-min(phi) le 181 then begin
  np=n_elements(phi)
  if phi(np-1) eq 180 then begin
    ph=[phi,360-reverse(phi(0:np-2))]
    ii=[indgen(np),reverse(indgen(np-1))]
    rr=psi(ii,*)
  endif else begin
    ph=[phi,360-reverse(phi)]
    ii=[indgen(np),reverse(indgen(np))]
    rr=psi(ii,*)
  endelse
endif else begin
  rr=psi
  ph=phi
endelse
;
rr=[rr,rr(0,*)]                           ; extra value to bridge cut line
ph=[ph,360+ph(0)]
;
tmax=max(theta) < 90

ss=tmax*1.1
yrange=[-ss,ss]
xrange=[-ss,ss]
nx=grdres
ny=grdres

if not keyword_set(half) then half=0

if half gt 0 then begin
  yrange=yrange > 0.
  ny=(grdres+1)/2
endif

if not keyword_set(xtitle) then xtitle=''
if not keyword_set(title) then title=''

if half lt 0 then begin
  hemm=-1
  yrange=yrange < 0.
  ny=(grdres+1)/2
  dchary=!d.y_ch_size*charsz/float(!d.y_vsize)
  framepos=boxpos(/get) 
  framepos([1,3])=framepos([1,3])-(framepos(3)-framepos(1)-half*dchary)
  utitle=''
  ltitle=title
endif else begin
  hemm=1
  framepos=0
  utitle=title
  ltitle=''
endelse

xvec=findrng(xrange,nx)
yvec=findrng(yrange,ny)

xx=xvec # replicate(1,ny)                   ; x coordinate array
yy=replicate(1,nx) # yvec                   ; y coordinate array
;
tt=sqrt(xx^2+yy^2)                         ; polar angle array
pp=fltarr(nx,ny)
ii=where(tt ne 0.)

pp(ii)=atan(yy(ii),xx(ii))/!dtor           ; azimuth angle array
pp=(pp+360.) mod 360.
pp=reform(pp,nx,ny)

nth=n_elements(theta)
nph=n_elements(ph)

ip=finterp(ph,pp)

;  don't interpolate between upper and lower hemisphere

if keyword_set(lower) then begin
  itedge=where(theta gt 90, nedge)
  if nedge eq 0 then  message,'no data for lower hemisphere'
  it=finterp(180.-theta,tt) > itedge(0)
endif else begin
  itedge=where(theta lt 90, nedge)
  if nedge eq 0 then message,'no data for upper hemisphere'
  it=finterp(theta,tt) < itedge(nedge-1)
endelse

blank=where(tt gt tmax)
image=interpolate(rr,ip,it)               ; rebined, rectilinear array

if keyword_set(clevels) then begin
  levels=clevels 
endif else begin
  case n_elements(range) of
    0: levels=contlev(image)
    1: levels=contlev(image)
    2: levels=contlev(range)
    3: levels=range(0)+findgen(1+(range(1)-range(0))/range(2))*range(2)
  endcase
endelse

image(blank)=min(image)
if rot ne 0 then image=rotate(image,rot)

if keyword_set(scale) eq 0 then scale=0
if n_elements(style) eq 0 then style=1
if keyword_set(half) then aspect=2 else aspect=1
if n_elements(barwidth) eq 0 then barwidth=1
if n_elements(noscale) eq 0 then noscale=0
if n_elements(c_thick) eq 0 then  $
   if !p.thick ne 0 then c_thick=!p.thick else c_thick=1
if n_elements(c_color) eq 0 then c_color=!p.color

case style of

  0:return

  1: begin
     if not keyword_set(colors) then colors=0
     confill,image,xvec,yvec,title=utitle,xrange=xrange,yrange=yrange,$
       lcharsize=lcharsize,pcharsize=charsize,rmarg=rmarg,labels=labels, $
        levels=levels,aspect=aspect,xstyle=5,ystyle=5,stitle=stitle, $
        c_thick=c_thick,barwidth=barwidth,noscale=noscale,colors=colors, $
        c_color=c_color,position=framepos
     end

  2:begin
    if n_elements(range) eq 0 then range=[min(levels),max(levels)]
    tvim,image,scale=1-noscale,title=utitle,xrange=xrange,yrange=yrange, $
       /noframe,lcharsize=lcharsize,pcharsize=charsize,rmarg=rmarg, $
       labels=labels,colors=colors,stitle=stitle,range=range, $
       clevels=clevels,barwidth=barwidth,_extra=_extra,position=framepos
    if n_elements(clevels) ne 0 and c_thick ne 0 then $
       contour,image,xvec,yvec,levels=clevels,color=gclr,/overplot, $
       c_thick=c_thick,c_color=c_color
  end

  3:begin
    plot,xvec,yvec,/nodata,xstyle=5,ystyle=5,xrange=xrange,yrange=yrange,$
       pos=boxpos(aspect=aspect),charsize=charsize,title=utitle
    contour,image,xvec,yvec,levels=levels,/follow,/overplot, $
       c_thick=c_thick,c_color=c_color
  end
  
endcase

if keyword_set(showpnts) then begin        ; show original grid
  xx=ph
  yy=theta
  gengrid,xx,yy
  xpnts=yy*cos(!dtor*xx)
  ypnts=yy*sin(!dtor*xx)*hemm
  oplot,xpnts,ypnts,psym=8,color=gclr,symsize=.4
endif  
;
; draw polar coordinate axis
;

if keyword_set(half) then begin
  circ=5*findgen(36+1)*!dtor 
endif else begin
  circ=5*findgen(72+1)*!dtor
endelse

if keyword_set(thetics) then begin
  tinc=thetics
endif else begin
  tst=[1,2,5,10,15,30,45]
  ii=where(tmax/tst lt 5)
  tinc=tst(ii(0))
endelse
ntt=fix(tmax)/tinc

chszfac=!d.y_ch_size/((!y.window(1)-!y.window(0))*float(!d.y_size))

if half lt -2 or half gt 0 then begin
  x_tics=(1+indgen(ntt))*tinc
  x_tics=[-reverse(x_tics),0,x_tics]
  if half gt 0 then begin
    y_tics=!y.crange(0)-1.3*chszfac*charsz*(!y.crange(1)-!y.crange(0))
    y_lab=!y.crange(0)-2.3*chszfac*charsz*(!y.crange(1)-!y.crange(0))
  endif else begin
    y_tics=!y.crange(1)-.5*chszfac*charsz*(!y.crange(0)-!y.crange(1))
    y_lab=!y.crange(1)-1.5*chszfac*charsz*(!y.crange(0)-!y.crange(1))
  endelse
  y_tics=replicate(y_tics,n_elements(x_tics))
  xticl=abs(x_tics)
  if keyword_set(nadir) then xticl=180-xticl
  if keyword_set(lower) then xticl=180-xticl
  xticl=strcompress(string(xticl),/remove_all)

  xyouts,x_tics,y_tics,xticl,charsize=charsz,align=.5
  if keyword_set(xtitle) then xyouts,0.,y_lab,xtitle,charsize=charsz,align=.5
endif

ls=lenstr('0')

;norm --> data coordinates

facx=(!x.crange(1)-!x.crange(0))/(!x.window(1)-!x.window(0))
facy=(!y.crange(1)-!y.crange(0))/(!x.window(1)-!x.window(0))
dy=2*ls*facy*charsz

;
; blank out circle exterior
;

hcirc=!dtor*findgen(37)*5              
xbt=[ss,tmax*cos(hcirc),-ss,-ss,ss,ss]
ybt=hemm*[0,tmax*sin(hcirc),0,ss,ss,0]
polyfill,xbt,ybt,color=!p.background

if not keyword_set(half) then begin 
  hcirc=hcirc+!dtor*180
  xbb=[-ss,tmax*cos(hcirc),ss,ss,-ss,-ss]
  ybb=[0,hemm*tmax*sin(hcirc),0,-ss,-ss,0]
  polyfill,xbb,ybb,color=!p.background
endif

if ltitle ne '' then begin
  chsz=1.2*!p.charsize*charsz
  yltitle=!y.window(0)-.5*chsz*chszfac*(!y.window(1)-!y.window(0))
  xltitle=(!x.window(0)+!x.window(1))/2.
  if !p.multi(1) gt 2 or !p.multi(2) gt 2 then chsz=.5*chsz
  xyouts,xltitle,yltitle,ltitle,charsize=chsz,align=.5,/norm
endif


; draw theta angle circles

if n_elements(thephi) eq 0 then begin
  if keyword_set(half) then thephi=-1 else thephi=[45.,135,225,315]
endif

if thephi(0) ne -1 then begin
  if keyword_set(half) then tp=thephi(where(thephi le 180)) else tp=thephi
  for i=1,ntt do begin 
    oplot,tinc*i*cos(circ),hemm*tinc*i*sin(circ),li=1,color=gclr
    for j=0,n_elements(tp)-1 do begin
      anglab=string(form='(i2)',i*tinc)
      xcos=cos(tp*!dtor)*i*tinc
      ysin=hemm*(sin(tp*!dtor)*i*tinc-.4*dy)
      xyouts,xcos,ysin,anglab,color=gclr,charsize=charsz,align=.5 
    endfor
  endfor
endif else begin
  for i=1,ntt do oplot,tinc*i*cos(circ),hemm*tinc*i*sin(circ),li=1,color=gclr
endelse


oplot,tmax*cos(circ),hemm*tmax*sin(circ)

if not keyword_set(phitics) then phitics=30
for i=0,359,phitics do begin
  if rot le 3 then ang=(i+90*rot)*!dtor else ang=-(i+90*(7-rot))*!dtor
  cosa=cos(ang)  
  sina=sin(ang)
  xang=tmax*cosa
  yang=hemm*tmax*sina
  if not keyword_set(half) or i le 180 then begin
    if keyword_set(half) and (i eq 0 or i eq 180) then begin
      li=0 
      rclr=!p.color
    endif else begin
      li=1
      rclr=gclr
    endelse
    oplot,[0,xang],[0,yang],linestyle=li,color=rclr    ; draw radial lines
    anglab=strtrim(string(form='(i3)',i),2)
    ls=lenstr("|"+anglab+"|")
    dx=ls*facx*charsz
    xa=(.5*dx+tmax)*cosa
    ya=hemm*((dy+tmax)*sina)-.4*dy
    xyouts,xa,ya,anglab,align=.5,charsize=charsz     ; label azimuth angles
  endif
endfor
end




