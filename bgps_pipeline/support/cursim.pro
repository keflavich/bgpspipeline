 pro cursim,a,yy,xx,point=point
;+
; ROUTINE:        cursim
;
; USEAGE:         cursim,a,yy,xx,range=range
;
; PURPOSE:        Use the graphics cursor to interrogate a TVIM image for
;                 pixel values and positions. 
;
; INPUT:    
;
;    a            image array, same size as used in TVIM image
;
;    yy, xx       2-D arrays of "vertical" and "horizontal" position
;                 in the geographical case these would be lat and lon arrays
;                 If these arrays are not supplied the x and y data
;                 coordinates are used instead.
;
; OPTIONAL INPUT:
;    point        if set, CURSIM will print the range and azimuth 
;                 of the cursor from this point. (Palmer = [-64.767,-64.067] )
;
;                 When this option is used the lat,lon coordinates must
;                 be available either in the data coordinates of the plot
;                 (i.e., as specified by the XRANGE and YRANGE parameter 
;                 in the TVIM call) or explicitly as the YY and XX parameters
;                 in CURSIM
;
; EXAMPLE: 
;                 tvim,hanning(200,200),xrange=[-180,180],yrange=[-90,90] 
;                 map_set,0,0,/cont,/grid,pos=boxpos(/get),/noerase
;                 cursim,hanning(200,200),point=[35,-120]
;
;  author:  Paul Ricchiazzi                            sep92
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

if n_params() eq 0 or n_params() eq 2 then a=fltarr(2,2)

on_error,2              ;Return to caller if an error occurs
sz=size(a)
;
print,'Press left or center mouse button for new output line."
print,'... right mouse button to exit.'
print,' '

plabel=['value','x','y','x_ind','y_ind','range','azimuth']

cr = string("15b)

geo=keyword_set(point)

if geo then begin
  plabel=['value','lon','lat','x_ind','y_ind','range','azimuth']
  form0="(7a10)"
  form1='($,3f10.4,2i10,2f10.2,a)'
  plat=point(0)
  plon=point(1)
  plots,plon,plat,psym=4,/data
  plots,plon,plat,psym=3,color=0,/data
endif else begin
  plabel=['value','x','y','x_ind','y_ind']
  form0="(5a10)"
  form1='($,3f10.4,2i10,a)'
endelse
print,form=form0,plabel

!err=0
;
while 1 do begin 

  cursor,xxd,yyd,/wait,/data

  if (!err eq 4) then begin
    print,form="($,a,a)",' ',cr
    print,' '
    point_label=string(',point=[',ypnt,',',xpnt,']')
    print,strcompress(point_label,/remove_all)
    return
  endif

  if (!err eq 2) ne 0 then begin ; New line
    print,form="($,a)",string("12b)
    cursor,xxd,yyd,/up,/data 
  endif

  xn=(xxd-!x.crange(0))/(!x.crange(1)-!x.crange(0))
  yn=(yyd-!y.crange(0))/(!y.crange(1)-!y.crange(0))
; 
  if xn lt 0. or xn gt 1. or yn lt 0 or yn gt 1. then begin
    print,form="($,a,a)",' ',cr
  endif else begin
    ix=fix((sz(1)-1)*xn)
    iy=fix((sz(2)-1)*yn)
    if n_elements(yy) ne 0 then yy1=yy(ix,iy) else yy1=yyd
    if n_elements(xx) ne 0 then xx1=xx(ix,iy) else xx1=xxd
    if keyword_set(geo) ne 0 then begin
      compass,plat,plon,yy1,xx1,rng,az
      print,form=form1,a(ix,iy),xx1,yy1,ix,iy,rng,az,cr
    endif else begin
      print,form=form1,a(ix,iy),xx1,yy1,ix,iy, cr
    endelse
    xpnt=xx1
    ypnt=yy1
    wait,.1
  endelse
endwhile

end

