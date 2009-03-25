;+
; ROUTINE:     xmap
;
; PURPOSE:     Display a world map and allow user to zoom in on a given region
;
; INPUT:       none
; OUTPUT:      none
;
;                         INTERACTIVE CONTROLS:
;
; BUTTON EVENTS WITHIN MAP FRAME:
;
;   Left mouse button --- Display lat-lon coordinates under cursor.
;
;   Middle mouse button - Display distance between the last LMB click
;                         and the current cursor position
;
;   Right mouse button -- Enter region selection mode.  An interactive
;                         cursor box appears.  The user selects the ZOOM
;                         region by moving the cursor and using the
;                         left/middle mouse buttons to decrease/increase
;                         the box size.  Hitting the right mouse
;                         button again selects the region, draws the
;                         map and displays the MAP_SET command line
;                         which duplicates the displayed map.  NOTE: to
;                         improve performance, the whole world map is
;                         drawn at low resolution whereas the zoomed
;                         in maps are drawn at high resolution.
;
; BUTTONS:
;
; DONE
;    quit XMAP
;
; WORLD
;    Redisplay world map
;
; ROTATE
;    Rotates the central longitude by 180 degrees.
;
; COLOR
;    Adjust color values of lines used to indicate continental
;    boundaries, US state boundaries, political boundaries, and
;    rivers.
;
;    NOTE: Color adjustment is accomplished via the PICKC widget.
;    Motion of the cursor inside the PICKC window adjusts
;    the Hue and Saturation values.  The intensity is adjusted
;    with a horizontal slider.
;
; SPAWN
;    Copy current map to a new window. The spawned window will
;    remain visible after XMAP terminates.
;              
;
; PRINT
;    Pull down menu  
;      TERM:     Print current map to device TERM 
;      TREE:     Print current map to device TREE
;      PSCOLOR:  Print current color map to device PSCOLOR
;      BW PS:    create a BW postscript file named plot.ps
;      COLOR PS: create a color postscript file named plotc.ps
;
; PATH
;    trace a path on the map and compute total distance
;    LMB adds a new path line segment
;    MMB erases last path segment
;    RMB computes total distance of path in km, and return to normal mode
;
; CITIES
;    mark major city locations 
;
; HELP       
;   Display this help file in a scrollable widget.
;
;
; TEXT WIDGET  (labeled WHERE IS:)
;   Enter the latititude <comma> longitude.   A symbol is drawn to
;   indicate point on map.  NOTE: the code will bomb if you mess up
;   the format
;
;  author:  Paul Ricchiazzi                            Dec92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO mapbox, x1,x2,y1,y2,aspect=aspect
;
;
; CALLING SEQUENCE:
;        MAPBOX, x1,x2,y1,y2,aspect=aspect
;
; INPUT/OUTPUT
;   x1,x2,y1,y2
;     data coordinates of box edges.
;

device, get_graphics = old, set_graphics = 6, cursor_standard=33  ;Set xor

x0=.5*(x1+x2)
y0=.5*(y1+y2)

tvcrs,x0,y0,/data

px=[x1,x2,x2,x1,x1]
py=[y1,y1,y2,y2,y1]

plots,px,py,/data

zfac=1.05

if keyword_set(aspect) then asp=(x2-x1)*cos(y0*!dtor)/(y2-y1)

while 1 do begin
  x00=x0
  y00=y0
  cursor, x0, y0, /nowait, /data

  butn = !err

  if (x0 ne x00 and y0 ne y00) or (butn ne 0) then begin

    plots, px, py,/data                       ; erase old box
    empty
  
    case butn of
      1:fac=1./zfac 
      2:fac=zfac
      else: fac=1.
    endcase

    dy=.5*fac*(y2-y1)

    if keyword_set(aspect) then dx=dy*asp/cos(y0*!dtor)  $
                           else dx=.5*fac*(x2-x1)

    x0=x0<(!x.crange(1)-dx)>(!x.crange(0)+dx)
    y0=y0<(!y.crange(1)-dy)>(!y.crange(0)+dy)

    x1=x0-dx
    x2=x0+dx
    y1=y0-dy
    y2=y0+dy

    px=[x1,x2,x2,x1,x1]
    py=[y1,y1,y2,y2,y1]
    plots, px, py,/data                       ; draw new box
    empty
  
    if !err eq 4 then begin  ;Quitting?
      plots, px, py, /data
      empty
      device,set_graphics = 3, cursor_standard=30
      return
    endif
  endif
  !err=0
  wait,.05
endwhile

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro mapit,lat1,lon1,lat2,lon2,event_id,status_id
;
latmid=0
lonmid=.5*(lon1+lon2)

if n_elements(event_id) ne 0 then begin
  widget_control,event_id,sensitive=0
  widget_control,status_id,set_value='WORKING...'
endif

if lat2-lat1 gt 175. then yticks=12 else yticks=0
if lon2-lon1 gt 350. then xticks=12 else xticks=0

plot,[lon1,lon2],[lat1,lat2],/nodata,/xstyle,/ystyle,/xgrid,/ygrid, $
   /ticklen,ymargin=[2,1],xmargin=[5,1],xticks=xticks,yticks=yticks

pos=boxpos(/get)

if lat2-lat1 gt 175. and lon2-lon1 gt 350. then begin
  map_set3,latmid,lonmid,/cyl,/cont,/label,color=4,$
     limit=[lat1,lon1,lat2,lon2], $
     /noerase,/lores,pos=pos
endif else begin
  map_set3,latmid,lonmid,/cyl,/cont,/label,color=4,p_color=3,$
     s_color=2,r_color=1,limit=[lat1,lon1,lat2,lon2], $
     /noerase,/political,/usa,/rivers,lores=res,pos=pos
endelse

plot,[lon1,lon2],[lat1,lat2],/nodata,pos=pos,/xstyle,/ystyle,/noerase, $
   xticks=xticks,yticks=yticks

c=',' 
b=']'
lonstr=strcompress(string(lonmid),/remove_all)
ostr='map_set3,0,'+lonstr+',/cyl,/grid,/cont,/label,limit=['
lstr=string(f='(4(f7.2,a))',lat1,c,lon1,c,lat2,c,lon2,b)

if n_elements(event_id) ne 0 then begin
  widget_control,event_id,sensitive=1
  widget_control,status_id,set_value=ostr+strcompress(lstr,/remove_all)
  print,ostr+strcompress(lstr,/remove_all)
endif

end		      

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO xmap_event,event

common xmapblk,status_id,lat1,lat2,lon1,lon2,x2,y2,hemis
WIDGET_CONTROL,GET_UVALUE=instance,event.top
WIDGET_CONTROL, event.id, GET_UVALUE=eventval

ev=eventval
if strpos(ev,'PRINT') ge 0 then ev='PRINT'

case ev of

 "DONE"  :  WIDGET_CONTROL, event.top, /DESTROY

 "DRAW": begin
           cursor,x1,y1,/nowait
           if max([abs(x1-x2),abs(y1-y2)]) gt .001 and !ERR eq 1 then begin
             coor=string(Format='("Lat,Lon = ",f9.3,", ",f9.3)',y1,x1)
             widget_control,status_id,set_value=coor
             wait,.1
             x2=x1
             y2=y1
           endif
           if max([abs(x1-x2),abs(y1-y2)]) gt .001 and !ERR eq 2 then begin
             compass,y2,x2,y1,x1,rng,az
             coor1=string(Format='("Lat0,Lon0=(",f9.3,",",f9.3,")")',y2,x2)
             coor2=string(Format='("  Lat,Lon=(",f9.3,",",f9.3,")")',y1,x1)
             coor3=string(Format='("  Rng,Az=(",f9.3,",",f9.3,")")',rng,az)
             nstp=fix(rng/50.) > 2
             compass,y2,x2,findrng(0.,rng,nstp),az,alat,alon,/to_latlon
             oplot,alon,alat,color=.75*!d.n_colors
             widget_control,status_id,set_value=coor1+coor2+coor3
             wait,.1
           endif
           if !ERR eq 4 then begin
             cursor,lonbar,latbar,/up
             widget_control,status_id,set_value= $
                'Left MB=> Smaller, Middle MB=> Bigger, Right MB=> Select'
             dlat=(lat2-lat1)/12
             dlon=!d.x_vsize*dlat/(!d.y_vsize*cos(latbar*!dtor))
             lon1=lonbar-dlon
             lon2=lonbar+dlon
             lat1=latbar-dlat
             lat2=latbar+dlat
             mapbox,lon1,lon2,lat1,lat2,/asp
             WIDGET_CONTROL, event.top, /hourglass
             mapit,lat1,lon1,lat2,lon2,event.id,status_id
             WIDGET_CONTROL, event.top, hourglass=0
           endif
         end

 "WORLD": begin
            lat1=-90.
            lat2=90.
            lon1=-180.+hemis
            lon2=180.+hemis
            mapit,lat1,lon1,lat2,lon2
          endif
            
 "HEMIS": begin
            hemis=180.-hemis
            lat1=-90.
            lat2=90.
            lon1=-180.+hemis
            lon2=180.+hemis
            mapit,lat1,lon1,lat2,lon2
          end

 "PRINT": begin
            case eventval of
              "PRINT_TERM"   :toggle,/landscape
              "PRINT_TREE"   :toggle,/landscape              
              "PRINT_BWPS"   :toggle,/landscape
              "PRINT_PSCOLOR":toggle,/landscape,/color
              "PRINT_CLRPS"  :toggle,/landscape,/color
             endcase
             if strpos(eventval,'CLR') lt 0 then begin
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
             mapit,lat1,lon1,lat2,lon2,event.id,status_id
             WIDGET_CONTROL, event.top, hourglass=0
;
             if strpos(eventval,'CLR') lt 0 then begin
	       tvlct,rs1,gs1,bs1,1
	       tvlct,rs2,gs2,bs2,2
	       tvlct,rs3,gs3,bs3,3
	       tvlct,rs4,gs4,bs4,4
             endif
;
             case eventval of
              "PRINT_TERM"   :toggle,print='term'
              "PRINT_TREE"   :toggle,print='tree'
              "PRINT_BWPS"   :toggle
              "PRINT_CLRPS"  :toggle
              "PRINT_PSCOLOR":toggle,print='pscolor'
             endcase

             widget_control,event.id,sensitive=1
             widget_control,status_id,set_value='          '
           end

   "SPAWN" : begin
               owin=!d.window
               window,/free,xs=.7*!d.x_vsize,ys=.7*!d.y_vsize
               WIDGET_CONTROL, event.top, /hourglass
               mapit,lat1,lon1,lat2,lon2,event.id,status_id
               WIDGET_CONTROL, event.top, hourglass=0
               wset,owin
             end

   "COLOR"  : pickc,[1,4],group=event.top
                            
   "PATH"   : begin
                trace,xv,yv
                dx=(xv-shift(xv,1))(1:*)
                dy=(yv-shift(yv,1))(1:*)
                coslat=cos(!dtor*.5*(yv+shift(yv,1))(1:*))
                distance=6371.2*!dtor*total(sqrt((coslat*dx)^2+dy^2))
                dlabel=string(f='(a,2(g11.4,a))', $
                              'Path Distance =',distance,' km = ', $
                              distance/1.609344,' miles')
                widget_control,status_id,set_value=strcompress(dlabel)
                wait,.3
                !err=0
              end

   "CITIES":  map_cities

   "HELP"  :  begin
               xhelp,"/local/idl/user_contrib/esrg/xmap.pro",$
                TITLE = "XMAP HELP", $
                GROUP = event.top, $
                WIDTH = 80, $
                HEIGHT = 16
             end

   "WHERE" : begin
               widget_control,event.id,get_value=latlon
               lat=0. &  lon=0. & reads,latlon,lat,lon
               plots,lon,lat,psym=4
             end        

endcase
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PRO xmap

common xmapblk,status_id,lat1,lat2,lon1,lon2,x2,y2,hemis

IF(XRegistered("xmap") NE 0) THEN return
w_height=500
w_width=700

pmulti=!p.multi
!p.multi=0
base  = WIDGET_BASE(TITLE="xmap", /COLUMN)
row1  = WIDGET_BASE(base, /ROW)
junk1 = WIDGET_BUTTON(row1, VALUE='   DONE   ', UVALUE = "DONE")
junk1 = WIDGET_BUTTON(row1, VALUE='  WORLD   ', UVALUE = "WORLD")
junk1 = WIDGET_BUTTON(row1, VALUE='  ROTATE  ', UVALUE = "HEMIS")
junk1 = WIDGET_BUTTON(row1, VALUE='  COLOR   ', UVALUE = "COLOR")
junk1 = WIDGET_BUTTON(row1, VALUE='  SPAWN   ', UVALUE = "SPAWN")
junk1 = WIDGET_BUTTON(row1, VALUE='  PRINT   ', /MENU)
junk2 = WIDGET_BUTTON(junk1,VALUE='  TERM    ', UVALUE = "PRINT_TERM")
junk2 = WIDGET_BUTTON(junk1,VALUE='  TREE    ', UVALUE = "PRINT_TREE")
junk2 = WIDGET_BUTTON(junk1,VALUE='  BW PS   ', UVALUE = "PRINT_BWPS")
junk2 = WIDGET_BUTTON(junk1,VALUE=' COLOR PS ', UVALUE = "PRINT_CLRPS")
junk2 = WIDGET_BUTTON(junk1,VALUE=' PSCOLOR  ', UVALUE = "PRINT_PSCOLOR")
junk1 = WIDGET_BUTTON(row1, VALUE='   PATH   ', UVALUE = "PATH")
junk1 = WIDGET_BUTTON(row1, VALUE='  CITIES  ', UVALUE = "CITIES")
junk1 = WIDGET_BUTTON(row1, VALUE='   HELP   ', UVALUE = "HELP")
row2  = WIDGET_BASE(base, /ROW)
junk1 = WIDGET_LABEL(row2, VALUE='WHERE IS (lat,lon):',/frame)
junk1 = WIDGET_TEXT(row2, VALUE=' 0,0  ', UVALUE = "WHERE",/EDITABLE)
status_id = WIDGET_TEXT(base, VALUE='          ')

show = WIDGET_DRAW(base, YSIZE=w_height, XSIZE=w_width, /FRAME, RETAIN = 2,$
                   /MOTION_EVENTS,/BUTTON_EVENTS,UVALUE = "DRAW")

lat1=-90.
lat2=90.
lon1=-180.
lon2=180.
hemis=0
x2=0
y2=0


WIDGET_CONTROL, base, /REALIZE
WIDGET_CONTROL, show,GET_VALUE=winn
wset,winn
mapit,lat1,lon1,lat2,lon2

;  color=4,bdy_color=3,us_color=2,riv_color=1,$

tvlct,rs1,gs1,bs1,1,/get
tvlct,rs2,gs2,bs2,2,/get
tvlct,rs3,gs3,bs3,3,/get
tvlct,rs4,gs4,bs4,4,/get

tvlct,   50, 50,  255, 1            ; river color
tvlct, 160,  50,   50, 2            ; usa state boundaries
tvlct,   0, 160,    0, 3            ; political boundaries
tvlct, 255, 255,    0, 4            ; map border

XManager, "xmap", base, GROUP_LEADER = GROUP
;
; restore previous !p.multi and color table 
;

!p.multi=pmulti

tvlct,rs1,gs1,bs1,1
tvlct,rs2,gs2,bs2,2
tvlct,rs3,gs3,bs3,3
tvlct,rs4,gs4,bs4,4

END






