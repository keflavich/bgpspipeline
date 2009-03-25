;+
; ROUTINE:     XGLOBE
;
; USEAGE:      XGLOBE
;
; PURPOSE:     Display a world map and allow user to zoom in on a given region
;
; INPUT:       none
; OUTPUT:      none
;
; BUTTONS:
;   DONE       quit XGLOBE
;
; ZOOM         Pull down menu 
;     ZOOM IN: The IDL routine BOX_CURSOR is used to select the region.
;              use left mouse button to point and drag the cursor box
;              use middle mouse button to resize cursor box
;              use right mouse to select region and draw the map
;
;              To reduce distortion on zoomed regions near the poles
;              it is a good idea to choose a short, wide map region.
;
;    ZOOM OUT: The latitude and longitude limits are increased by 20% and
;              the map is redrawn.
;
;       WORLD: Redisplay world map (equivalent to hitting ZOOM OUT many times)
;
;        PLOT: Replot map with current lat-lon limits.
;
; PRINT        Pull down menu
;        TERM: Print current map to device TERM 
;     GAUTIER: print current map to device GAUTIER 
;      PHASER: print current map to device PHASER (color plots)
;         DUP: print current map to device DUP
;
;
;   COLOR      Pull down menu
;  CONTINENTS: adjust color value of continental boundaries
;    US STATE: adjust color value of US state boundaries
;   POLITICAL: adjust color value of political boundaries
;      RIVERS: adjust color value of rivers
;
;	 NOTE: Each of these options use the procedure PICK_COLOR
;	       to adjust the color value for a single color index.
;	       Motion of the cursor inside the PICK_COLOR window 
;              adjusts the Hue and Saturation values.
;	       Holding down the left mouse button decreases brightness.
;	       Holding down the middle mouse button increases brightness. 
;	       Pressing the right mouse button selects the color and returns.
;
;   HELP       print this help file
;
;
; TEXT WIDGET  (labeled WHERE IS:)
;
;              Enter the latititude <comma>  longitude 
;              A symbol is drawn to indicate point on map.
;              NOTE: the code will bomb if you mess up the format
;
; DRAW WIDGET  The lat-lon coordinates under the cursor are
;              printed when the left mouse button is held down
;              (This feature is disabled in "ZOOM IN" region selection
;              mode)
;
;  author:  Paul Ricchiazzi                            DEC92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
pro mapit,lat0,lon0,radius,event_id,status_id,rrr,noerase=noerase
;
compass,lat0,lon0,radius,[-90,0,90,180],latl,lonl,/to_latlon
limit=reform(transpose([[latl],[lonl]]),8)
print,lat0,lon0
print,limit
if radius gt 6370 then limit=0
if radius lt 5000 then res=1 else res=0

if keyword_set(event_id) then begin
  widget_control,event_id,sensitive=0
  widget_control,status_id,set_value='WORKING...'
endif

bdy_color=!d.n_colors*(4000+5000)/10240.
us_color=!d.n_colors*(3000+5000)/10240.
riv_color=!d.n_colors*(-1000+5000)/10240.

xm=[15,15]
ym=[7,7]
if not keyword_set(noerase) then noerase=0
if res then begin
  if keyword_set(noerase) then begin
    map_set3,lat0,lon0,/ortho,/grid,/continent,/label,color=4,xmarg=xm,$
           ymarg=ym,/bdys,/usa,/rivs,limit=limit,bdy_color=bdy_color, $
           us_color=us_color,riv_color=riv_color,/noerase
  endif else begin
    map_set3,lat0,lon0,/ortho,/grid,/continent,/label,color=4,xmarg=xm,$
           ymarg=ym,/bdys,/usa,/rivs,limit=limit,bdy_color=bdy_color, $
           us_color=us_color,riv_color=riv_color
  endelse
endif else begin
  if keyword_set(noerase) then begin
    map_set,lat0,lon0,/ortho,/grid,/cont,/label,limit=limit,$
           ymarg=ym,xmarg=xm,/noerase
  endif else begin
    map_set,lat0,lon0,/ortho,/grid,/cont,/label,limit=limit,$
           ymarg=ym,xmarg=xm
  endelse
endelse
;
if keyword_set(event_id) then begin
  widget_control,event_id,sensitive=1
  widget_control,status_id,set_value='          '
endif

end		      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro drawbox,oradius,radius
;
device,set_graphics=6
dx=.5*sin((oradius/6371.)*!pi/2)
dy=dx
plots,.5+[-dx,dx,dx,-dx,-dx],.5+[-dy,-dy,dy,dy,-dy],/norm
dx=.5*sin((radius/6371.)*!pi/2)
dy=dx
plots,.5+[-dx,dx,dx,-dx,-dx],.5+[-dy,-dy,dy,dy,-dy],/norm
wait,.2
device,set_graphics=3
oradius=radius
end		      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO xglobe_event,event

common xglobeblk,status_id,lat0,lon0,radius,re,latp,lonp,res
WIDGET_CONTROL,GET_UVALUE=instance,event.top
WIDGET_CONTROL, event.id, GET_UVALUE=eventval

ev=eventval
if strpos(ev,'PRINT') ge 0 then ev='PRINT'

case ev of

 "DONE"  :  WIDGET_CONTROL, event.top, /DESTROY

 "DRAW": begin
           cursor,x,y,/nowait
           if max([abs(x-lonp),abs(y-latp)]) gt .001 and !ERR eq 1 then begin
             coor=string(Format='("Lat,Lon = ",f9.3,", ",f9.3)',y,x)
             widget_control,status_id,set_value=coor
             wait,.1
             lonp=x
             latp=y
           endif
           
           if max([abs(x-lonp),abs(y-latp)]) gt .001 and !ERR eq 2 then begin
             coor=string(Format='("Lat,Lon = ",f9.3,", ",f9.3)',y,x)
             lonp=y
             latp=x
             lat0=y
             lon0=x
             WIDGET_CONTROL, event.top, /hourglass
             mapit,lat0,lon0,radius,event.id,status_id,res
             WIDGET_CONTROL, event.top, hourglass=0
             widget_control,status_id,set_value=coor
           endif
           
         end

   "HELP"  : xhelp,"/local/idl/user_contrib/esrg/xglobe.pro",$
                TITLE = "XGLOBE HELP", $
                GROUP = event.top, $
                WIDTH = 80, $
                HEIGHT = 16

 "SLIDER": begin
            widget_control,event.id,get_value=r
            drawbox,radius,r
          end

 "WORLD":  begin
            WIDGET_CONTROL, event.top, /hourglass
            radius=6371
            mapit,lat0,lon0,radius,event.id,status_id,res
            WIDGET_CONTROL, event.top, hourglass=0
          end

 "PRINT": begin
            case eventval of
              "PRINT_BW"     :toggle,/landscape
              "PRINT_COLOR"  :toggle,/landscape,/color
             endcase
             if eventval ne "PRINT_COLOR" then begin
	       tvlct,rs1,gs1,bs1,1,/get
	       tvlct,rs2,gs2,bs2,2,/get
	       tvlct,rs3,gs3,bs3,3,/get
	       tvlct,rs4,gs4,bs4,4,/get
	       
	       tvlct,100,100,100,1             ; river color
	       tvlct,150,150,150,2             ; usa state boundaries
	       tvlct,200,200,200,3             ; political boundaries
	       tvlct,255,255,255,4             ; map border

             endif
;
             WIDGET_CONTROL, event.top, /hourglass
             mapit,lat0,lon0,radius,event.id,status_id,res
             WIDGET_CONTROL, event.top, hourglass=0
;
             if eventval ne "PRINT_COLOR" then begin
	       tvlct,rs1,gs1,bs1,1
	       tvlct,rs2,gs2,bs2,2
	       tvlct,rs3,gs3,bs3,3
	       tvlct,rs4,gs4,bs4,4
             endif
;
             toggle,/queue

             widget_control,event.id,sensitive=1
             widget_control,status_id,set_value='          '
           end
   "ALT" : begin
             openr,lun,/get_lun,filepath('worldelv.dat',subdir='images')
             elev=bytarr(360,360)
             readu,lun,elev
             free_lun,lun
             elev=shift(elev,180,0)
             im=map_image(elev,sx,sy,/bilin)
             im=(!d.n_colors-1)*float(im)/255
             tv,im,sx,sy
             coor=string(Format='("Lat,Lon = ",f9.3,", ",f9.3)',lat0,lon0)
             WIDGET_CONTROL, event.top, /hourglass
             mapit,lat0,lon0,radius,event.id,status_id,res,/noerase
             color_key,range=[-5000,5240]
             WIDGET_CONTROL, event.top, hourglass=0
             widget_control,status_id,set_value=coor
           end

   "WHERE" : begin
               widget_control,event.id,get_value=latlon
               nc=strpos(latlon,',') & nc=nc(0)
               if nc ge 0 then begin
                 lat=float(strmid(latlon,0,nc))
                 lon=float(strmid(latlon,nc+1,100))
                 plots,lon,lat,psym=4
               endif
             end        

   "XLOADCT": xloadct

   "PICKC"  : pickc,[1,4],group=event.top,$
                 labels=['RIVERS','US STATE BOUNDARIES',$
                       'POLITICAL BOUNDARIES','CONTINENT BOUNDARIES']
                            
endcase
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO xglobe

common xglobeblk,status_id,lat0,lon0,radius,re,latp,lonp,res

IF(XRegistered("xglobe") NE 0) THEN return
w_height=700
w_width=700

pmulti=!p.multi
!p.multi=0
base  = WIDGET_BASE(TITLE="xglobe", /COLUMN)
junk  = WIDGET_BASE(base, /ROW)
junk1 = WIDGET_BUTTON(junk, VALUE='   DONE   ', UVALUE = "DONE")
junk1 = WIDGET_BUTTON(junk, VALUE='  WORLD   ', UVALUE = "WORLD")
junk1 = WIDGET_BUTTON(junk, VALUE=' ALTITUDE ', UVALUE = "ALT")
junk1 = WIDGET_BUTTON(junk, VALUE='  COLOR   ', /menu)
junk2 = widget_button(junk1,value=' xloadct  ', uvalue= "xloadct")
junk2 = widget_button(junk1,value='  pickc   ', uvalue= "pickc")
junk1 = WIDGET_BUTTON(junk, VALUE='  PRINT   ', /MENU)
junk2 = WIDGET_BUTTON(junk1,VALUE='Black & White', UVALUE = "PRINT_BW")
junk2 = WIDGET_BUTTON(junk1,VALUE='    Color    ', UVALUE = "PRINT_COLOR")
junk1 = WIDGET_BUTTON(junk, VALUE='   HELP   ', UVALUE = "HELP")
junk1 = WIDGET_LABEL(junk, VALUE='WHERE IS:',/frame)
junk1 = WIDGET_TEXT(junk, VALUE=' 0,0  ', UVALUE = "WHERE",/EDITABLE)
junk= widget_slider(base,title='ZOOM',value=6371,minimum=1,maximum=6371,$
                    uvalue='SLIDER',/drag)

status_id = WIDGET_LABEL(base, VALUE='          ')

show = WIDGET_DRAW(base, YSIZE=w_height, XSIZE=w_width, /FRAME, RETAIN = 2,$
                   /button_events,/MOTION_EVENTS,UVALUE = "DRAW")

lat0=45
lon0=-100
re=6371
radius=re
latp=lat0
lonp=lon0
WIDGET_CONTROL, base, /REALIZE
res=0
WIDGET_CONTROL, show,GET_VALUE=winn
wset,winn
mapit,lat0,lon0,radius,0,0,0

;  color=4,bdy_color=3,us_color=2,riv_color=1,$

; Define interpolation points:  (elevation in meters, r, g, b)
; be sure elevation of 1st element is -5000 (data value 0), and last is
; 5240 (data value 256).


alts=[-5000, -4900, -1500, -40,   0,   250, 1000,  3000, 4000,   5240] 
red= [    0,     0,     0, 192,  64,   150,  200,   255,  255,    255]
grn= [    0,     0,     0, 192, 192,   150,  200,    80,  255,    255]
blu= [    0,   128,   255, 255,  64,    75,  100,     0,    0,    255]

r=interpol(red,alts,findrng(-5000,5240,!d.n_colors))
g=interpol(grn,alts,findrng(-5000,5240,!d.n_colors))
b=interpol(blu,alts,findrng(-5000,5240,!d.n_colors))

tvlct,r,g,b


XManager, "xglobe", base, GROUP_LEADER = GROUP
;
; restore previous !p.multi and color table 
;

!p.multi=pmulti

loadct,0

END






