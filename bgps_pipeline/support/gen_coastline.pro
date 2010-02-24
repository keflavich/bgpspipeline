 pro gen_coastline,alat,alon,file=file,image=image
;
;+
; ROUTINE:  GEN_COASTLINE
;
; USEAGE:   gen_coastline
;           gen_coastline,alat,alon,file=file,image=image
;
; PURPOSE:  generate coastal outline map for satellite images
;
; INPUTS:   ALAT         2-D array of image latitude values (one value for
;                        each image pixel)
;           ALON         2-D array of image longitude values
;
;                        if ALON and ALAT are not provided,
;                        GEN_COASTLINE assumes a linear mapping of lat
;                        and lon to the current x and y ploting range.
;
;           FILE         Name of map coordinate data file. If FILE is
;                        not provided, GEN_COASTLINE queries for an
;                        output file name.  FILE is written in portable
;                        XDR binary format which can be read by the 
;                        companion procedure COASTLINE.
;
; OPTIONAL KEYWORD INPUT:
;           image        Image from which to infer coastal outline.
;                        If an image array is not provided, it is assumed
;                        that an image has already been displayed using
;                        the TVIM procedure.
;           
; SIDE EFFECT:           writes map file in current working directory
;
; PROCEDURE:
;  Before entering input mode the following pop-up menu appears,
; 
; 1. DEFINE AN OPEN CURVE                 Start a new coastal outline segment
;
; 2. DEFINE A CLOSED CURVE                Start an island outline segment
;
; 3. QUIT                                 Flush buffers and quit.  
; 
; After option 1 or 2 is selected, coastline coordinates are input by 
; using the mouse to click on coastal features from an image in the 
; default window.  The mouse buttons perform the following actions:
;
; LMB: left mouse button connects points along coastline
; MMB: middle mouse erases most recent point(s)
; RMB: right mouse button finishes a coastline segment.
;    
; If a coastal outline is intended to represent an island (option 2), 
; pressing the RMB causes the last point on the curve to be connected 
; to the first.
;
; The collection of [latitude, longitude] coordinates are written to the
; file FILE.  This map data file can be used as input for the companion
; procedure,  COASTLINE.PRO which plots the coast line data onto arbitrarily
; oriented image files. 
;
;
; EXAMPLE:
;          x=findgen(128)
;          y=findgen(128)
;          gengrid,x,y
;          d=randata(128,128,s=4)
;          d=d gt 3
;          gen_coastline,y,x,file='junk.dat',image=d
;          coastline,file='junk.dat',/view
;
; AUTHOR:     Paul Ricchiazzi    oct92 
;             Earth Space Research Group, UCSB
;
; REVISIONS
; 29oct92: accomodate TRACE revision of 29oct92
;-
;

if keyword_set(image) then tvim,image
px=!x.window*!d.x_vsize
py=!y.window*!d.y_vsize
x0=px(0)
y0=py(0)

if keyword_set(alat) then begin
  sz=size(alat)
  nx=sz(1)
  ny=sz(2)
endif else begin
  nx=px(1)-px(0)+1
  ny=py(1)-py(0)+1
endelse 

xf=(px(1)-px(0))/(nx-1)
yf=(py(1)-py(0))/(ny-1)

if n_elements(file) eq 0 then begin
  print,form='($,a,a)','Enter name of map file '
  file=''
  read,file
endif
print,'Left mouse button adds points'
print,'Middle mouse button deletes points'
print,'Right mouse button stops accumulation'
;
xret=xf*nx/2+x0
yret=yf*ny/2+y0
while 1 do begin
  op=wmenu(['Options','Define an open curve','Define a closed curve',$
            'Quit'],title=0,init=0)
  tvcrs,xret,yret
  if op eq 3 then goto, done
  trace,xverts,yverts,/silent
  if n_elements(xverts) le 1 then goto,done

  ix=xverts
  iy=yverts
  nn=n_elements(ix)
  xret=xf*xverts(nn-1)+x0
  yret=yf*yverts(nn-1)+y0
  if op eq 2 then begin
    ix=[ix,ix(0)]
    iy=[iy,iy(0)]
    nn=nn+1
  endif
  plots,ix,iy
  if keyword_set(alat) then begin
    llat=reform(alat(ix,iy),nn)
    llon=reform(alon(ix,iy),nn)
  endif else begin
    llat=!y.crange(0)+iy*(!y.crange(1)-!y.crange(0))
    llon=!x.crange(0)+ix*(!x.crange(1)-!x.crange(0))
  endelse
  if n_elements(lat) eq 0 then lat=llat else lat=[lat,llat]
  if n_elements(lon) eq 0 then lon=llon else lon=[lon,llon]
  lat=[lat,1000.]
  lon=[lon,1000.]
endwhile
done:
nn=n_elements(lat)

f=transpose([[lon],[lat]])

get_lun,lun
openw,lun,file,/xdr,/stream
writeu,lun,nn
writeu,lun,f
free_lun,lun
end

