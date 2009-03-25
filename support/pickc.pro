;+
; ROUTINE:   pickc
;
; PURPOSE:   interactive adjustment of a series of discreet color values
;
; USEAGE:    pickc,colrng,labels=labels,group=group
;
; INPUT:
;  colrng    2 element vector specifying the color index range accessable
;            to pickc (default=[0,!d.n_colors-1])
; 
; KEYWORD INPUT:
;  labels    names to be associated with particular color indecies.
;            if labels are provided NN is reset to n_elements(LABELS).
;
;  group     widget id of widget procedure that calls PICKC
;
; OUTPUT:    none
;
; PROCEDURE:
;            When first called, PICKC will create a new IDL window
;            named "PICKC".  A color wheel is drawn with hue values
;            varying from 1 - 360 degrees around the circle and
;            saturation values varying from 0 at the center to 1 at
;            the outer edge of the circle.
;             
;            Motion of the cursor inside the PICKC window with the
;            with a mouse button pressed down adjusts the Hue and Saturation
;            values and leaves the brigtness unchanged.
;
;            Use the intensity slider to change the brightness.
;
;            Use the color index slider to select a new color index
;
; BUTTONS:
;
;      DONE: save new RGB values and quit
;
;    CANCEL: restore old RGB values and quit
; 
;   XLOADCT: call the XLOADCT widget
;    
;   DIFFUSE: smear the current color to adjacent color indicies
;            repeated clicks on DIFFUSE button causes the current
;            color to diffuse further along the color scale.
;
;      HELP: print this text
;
;
; EXAMPLE:
;            Make a color plot and use PICKC to adjust color values:
;
;  plot, [0,100],[-3,3],/nodata
;  d=findgen(100)
;  efac=exp(-((d-50)/20)^2)
;  oplot,3*sin(d/2)*efac,color=1,thick=3 
;  oplot,sin(d/3)*efac,color=2,thick=3  
;  oplot,sin(d/2)*efac,color=3,thick=3  
;  oplot,3*efac,color=4,thick=3
;  oplot,efac,color=5,thick=3
;  oplot,-3*efac,color=4,thick=3
;  oplot,-efac,color=5,thick=3
;  r=[0,0,127,255,0,127] & g=[0,127,255,0,127,255] & b=[0,255,0,127,255,0]
;  tvlct,r,g,b
;  pickc,[1,5]
;
;  loadct,0
;  pickc            ;  choose a color index, change its RGB value, smear it
;
;
;  author:  Paul Ricchiazzi                            5feb93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
pro pcsetup,c_index,h,s

; set up PICKC window

wd=200
wr=100
marg=50
xsize=wd+2*marg
ysize=wd+2*marg
;
c_name = [' Red','Yellow','Green','Cyan ','Blue','Magenta']
im=bytarr(wd,wd)
ix=indgen(wd)
iy=indgen(wd)
ix=ix # replicate(1,wd)
iy=replicate(1,wd) # iy
ii=where(float(ix-wr)^2+float(iy-wr)^2 lt wr^2)
im(ii)=c_index
tv,im,marg,marg
;
; draw grid lines, color names and other labels
;
a=findgen(5*360)*!dtor/5
plots,marg+wr*(1.+cos(a)),marg+wr*(1.+sin(a)),/device
plots,marg+wr*(1.+.333*cos(a)),marg+wr*(1.+.333*sin(a)),/device
plots,marg+wr*(1.+.667*cos(a)),marg+wr*(1.+.667*sin(a)),/device

xline=marg+wr*(1.+cos([0,60,120,180,240,300]*!dtor))
yline=marg+wr*(1.+sin([0,60,120,180,240,300]*!dtor))
plots,xline([0,3]),yline([0,3]),/device
plots,xline([1,4]),yline([1,4]),/device
plots,xline([2,5]),yline([2,5]),/device
xline=marg+wr*(1.+1.1*cos([0,60,120,180,240,300]*!dtor))
yline=marg+wr*(1.+1.2*sin([0,60,120,180,240,300]*!dtor))
xyouts,xline,yline,c_name,/device,align=.5
;
; initialize cursor position
;
xinit=marg+wr+s*wr*cos(!dtor*h)
yinit=marg+wr+s*wr*sin(!dtor*h)
;print,'c_index,h,s ',c_index,h,s
a=10*findgen(37)*!dtor
xsym=cos(a)
ysym=sin(a)
usersym,xsym,ysym,/fill,color=(c_index + 1) mod !d.n_colors
plots,xinit,yinit,psym=8,/device,symsize=2
usersym,xsym,ysym,color=0
plots,xinit,yinit,psym=8,/device,symsize=2
;
return
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro pccurs,c_index,rgb_id,h,s,v
;
;inputs: c_index     color index
;        rgb_id      rgb label widget id
;        v           color value
;        s           saturation
;output  h           hue
;        s           saturation
;        v           color value (brightness)

wr=100
marg=50

repeat begin
  cursor,x,y,/nowait,/device 
  if !err eq 0 then return
  
  xx=float(x-marg)/wr-1.
  yy=float(y-marg)/wr-1.
  s=sqrt(xx^2+yy^2)
  s=s < 1.
;  if !err eq 1 then v=(v-.01) > 0. 
;  if !err eq 4 then v=(v+.01) < 1.
  h=atan(yy,xx)/!dtor
  if h lt 0 then h=h+360
  color_convert,h,s,v,r,g,b,/hsv_rgb
  tvlct,r,g,b,c_index
  str=string(form='(3i5)',r,g,b)
  widget_control,rgb_id,set_value=str
endrep until 0
return
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro pickc_event,event

COMMON colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

WIDGET_CONTROL,event.top, GET_UVALUE=data
WIDGET_CONTROL, event.id, GET_UVALUE=eventval

clrmx=data.cindmx

case eventval of

 "HELP"  :begin
            xhelp,"/local/idl/user_contrib/esrg/pickc.pro",$
             TITLE = "PICKC HELP", $
             GROUP = event.top, $
             WIDTH = 80, $
             HEIGHT = 16
          end

 "DONE"  :  begin
              tvlct,r,g,b,/get
              r_orig=r
              r_curr=r
              g_orig=g
              g_curr=g
              b_orig=b
              b_curr=b
              WIDGET_CONTROL, event.top, /DESTROY
            end
 
 "CANCEL": begin
             tvlct,r_curr,g_curr,b_curr
             WIDGET_CONTROL, event.top, /DESTROY
           end

 "XLOADCT": begin
             tvlct,r,g,b,/get
             r_orig=r
             g_orig=g
             b_orig=b
             r_curr=r
             g_curr=g
             b_curr=b
             xloadct,group=event.top
            end

 "DIFFUSE": begin
             tvlct,rr,gg,bb,/get
             cx=data.c_index mod 256
             wfac=fix(data.c_index / 256) > 1
             rsv=rr(cx)
             gsv=gg(cx)
             bsv=bb(cx)
             cband=wfac*(data.cindmx-data.cindmn+1)/15
             cbeg=(cx-cband ) > data.cindmn
             cend=(cx+cband ) < data.cindmx
             ccc=indgen(!d.n_colors)
             arg=10 < (float(ccc-cx)/cband)^2 
             wt=exp(-arg)
             env=hanning(clrmx+1)
             if cx ne 0 and cx ne clrmx then wt=wt*(1<(env/env(cx)))
             wt=wt/max(wt)
             rr=rr*(1.-wt)+rsv*wt
             gg=gg*(1.-wt)+gsv*wt
             bb=bb*(1.-wt)+bsv*wt
             tvlct,rr,gg,bb
             r_orig=rr
             g_orig=gg
             b_orig=bb
             r_curr=rr
             g_curr=gg
             b_curr=bb
             color_convert,rsv,gsv,bsv,data.hue,data.sat,data.val,/rgb_hsv
             if data.c_index lt 20*256 then data.c_index=data.c_index + 256 
             widget_control,event.top,set_uvalue=data
           end

 "DRAW":   begin
             cx=data.c_index mod 255
             hhh=data.hue & sss=data.sat & vvv=data.val
             pccurs,cx,data.rgb_id,hhh,sss,vvv
             data.hue=hhh & data.sat=sss & data.val=vvv
             data.c_index=cx
             widget_control,event.top,set_uvalue=data
           end

 "ISLIDER":begin
             widget_control,event.id,get_value=sldval
             data.val=sldval/100.
             color_convert,data.hue,data.sat,data.val,r,g,b,/hsv_rgb
             tvlct,r,g,b,data.c_index
             widget_control,event.top,set_uvalue=data
           end
             
 "SLIDER" : begin
           WIDGET_CONTROL, event.id,   GET_VALUE = clrind
           clrind=clrind < data.cindmx
           step=float(!d.x_vsize-1)/(data.cindmx-data.cindmn+1)
           xpnt=.5*step+(data.c_index-data.cindmn)*step
           plots,xpnt,5,psym=4,color=0,/device
           data.c_index=clrind
           xpnt=.5*step+(data.c_index-data.cindmn)*step
           plots,xpnt,5,psym=4,/device
                       
           if event.drag eq 0 then begin
             tvlct,rr,gg,bb,/get
             r=rr(data.c_index)
             g=gg(data.c_index)           
             b=bb(data.c_index)
             color_convert,r,g,b,hhh,sss,vvv,/rgb_hsv
             data.hue=hhh & data.sat=sss & data.val=vvv
             pcsetup,data.c_index,data.hue,data.sat
             str=string(form='(3i5)',r,g,b)
             widget_control,data.rgb_id,set_value=str
             widget_control,data.int_id,set_value=data.val*100
           endif
           widget_control,event.top,set_uvalue=data
         end           

endcase
return
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO pickc,colrng,labels=labels,group=group,clrchg=clrchg

COMMON colors, r_orig, g_orig, b_orig, r_curr, g_curr, b_curr

tvlct,r,g,b,/get
r_curr=r
g_curr=g
b_curr=b

case n_elements(colrng) of
 0:begin
    cindmn=0
    cindmx=!d.n_colors-1
   end
 1:begin
    cindmn=0
    cindmx=colrng
   end
 2:begin
    cindmn=colrng(0)
    cindmx=colrng(1)
   end
 else:begin
    cindmn=0
    cindmx=!d.n_colors-1
 end
endcase

cind=cindmn
c_index=cindmn

font=!p.font
!p.font=0

IF(XRegistered("pickc") NE 0) THEN return
wd=200
wr=100
marg=50
xsize=wd+2*marg
ysize=wd+2*marg

pmulti=!p.multi
!p.multi=0
base  = WIDGET_BASE(TITLE="pickc", /COLUMN)
junk  = WIDGET_BASE(base, /ROW)
junk1 = WIDGET_BUTTON(junk, VALUE=' DONE ', UVALUE = "DONE")
junk1 = WIDGET_BUTTON(junk, VALUE='CANCEL', UVALUE = "CANCEL")
junk1 = WIDGET_BUTTON(junk, VALUE='XLOADCT', UVALUE = "XLOADCT")
junk1 = WIDGET_BUTTON(junk, VALUE='DIFFUSE', UVALUE = "DIFFUSE")
junk1 = WIDGET_BUTTON(junk, VALUE=' HELP ', UVALUE = "HELP")

hue=0. ;
sat=0. ; initial color value
val=1. ;

junk  = WIDGET_BASE(base, /ROW)
junk1 = widget_label(junk, value='     RGB:')
rgb_id= WIDGET_LABEL(junk, VALUE=' ')

int_id = WIDGET_SLIDER(base, TITLE = "intensity", MINIMUM = 0, $
        MAXIMUM = 100, VALUE = 0, /DRAG, UVALUE = "ISLIDER")


show = WIDGET_DRAW(base, YSIZE=ysize, XSIZE=xsize, /FRAME, RETAIN = 2,$
                   /BUTTON_EVENTS,/MOTION_EVENTS,UVALUE = "DRAW")

junk1 = WIDGET_SLIDER(base, TITLE = "color index", MINIMUM = cindmn, $
        MAXIMUM = cindmx, VALUE = cindmn, /DRAG, UVALUE = "SLIDER")

data={cind:cind,c_index:c_index,cindmn:cindmn,cindmx:cindmx,$
      hue:hue,sat:sat,val:val,int_id:int_id,rgb_id:rgb_id}

widget_control, base, set_uvalue=data
WIDGET_CONTROL, base, /REALIZE
clrbar=findgen(!d.x_vsize)/(!d.x_vsize-1)
clrbar=fix(cindmn+clrbar*(cindmx-cindmn+1)) < cindmx
clrbar=clrbar # replicate(1,20)
tv,clrbar,0,10 
plots,[0,!d.x_vsize-1],10,/device
plots,[0,!d.x_vsize-1],30,/device
xpnt=.5*float(!d.x_vsize-1)/(cindmx-cindmn+1)
plots,xpnt,5,psym=4,color=255,/device

WIDGET_CONTROL, show,GET_VALUE=winn

tvlct,rs1,gs1,bs1,/get

color_convert,rs1(c_index),gs1(c_index),bs1(c_index),hue,sat,val,/rgb_hsv

pcsetup,c_index,hue,sat

widget_control, int_id,set_value=val*100

Xmanager, "pickc", base, GROUP_LEADER = GROUP
;
; restore previous !p.multi and color table 
;
!p.multi=pmulti

!p.font=font

END

