pro globe_image2,input,output,windowsize=windowsize,limits=limits,title=title,$
	whole=whole,name=name
;+
; ROUTINE   globe_image
;
; AUTHOR:                 Terry Figel, ESRG, UCSB 10-21-92
;
; USEAGE:   globe_image,image
;
;           globe_image,image,animation,title=title,limits=limits,$
;                    windowsize=windowsize
;
;
; PURPOSE:             Display an image on a rotating globe
;
;
; INPUT    input           image quantity
;
; Optional keyword input:
;
;          title       plot title
;          windowsize  Controls the size of the window, Directly responsible
;                      for memory usage
;          limits      4 item array [min lat,min lon,max lat,max lon] of
;                      input image, if omitted presumed global 
;                      coverage [-90,0,90,360]
;			whole      treats image as whole world for map_image
;
; SIDE EFFECTS:        Uses a LOT of MEMORY ~30-50 MEGS, takes a few minutes
;                      to set up animation
;                      If windowsize left at 300 approx 13 megs used on DEC
;
; PROCEDURE            GLOBE_IMAGE first map an image to a globe
;                      Then it saves the image, rotates 10 degrees and repeats
;                      Then it animates the saved images
;
; LOCAL PROCEDURES:    None
;-

if keyword_set(title) then title=title else title=!p.title
if keyword_set(windowsize) then windowsize=windowsize else windowsize=300
if keyword_set(name) then name=name else name="output."

if keyword_set(limits)  then begin
	sz=size(limits)
	if (sz(1) ne 4) then begin
		print,'limits must have 4 elements '
		print,'[min lat,min lon,max lat,max lon]'
		return
	endif
	limits=limits 
endif else limits=[-90,0,90,360]
min_lat=limits(0)
min_lon=limits(1)
max_lat=limits(2)
max_lon=limits(3)




window,2,xs=windowsize,ys=windowsize,title=title
loadct,15
image_byte=bytscl(input)
output=bytarr(windowsize,windowsize,36)


for i=35,0,-1 do begin
	lon_low=i*10
	lon_high=i*10+180
	lon_mid=i*10+90
	print,'in here ',i,' of 36 ',lon_low,lon_high,lon_mid

	;First Do the map in the given projection
	map_set,-7.5,lon_mid,/cont,/grid,limit=[-90,lon_low,90,lon_high],$
		/noborder,title=title,/ortho

	; Then Map the image to the map_set
	if keyword_set(whole) then begin
			im=map_image(image_byte,stx,sty,latmin=min_lat,$
				latmax=max_lat,lonmin=min_lon,lonmax=max_lon,/whole)
		endif else begin
			im=map_image(image_byte,stx,sty,latmin=min_lat,$
				latmax=max_lat,lonmin=min_lon,lonmax=max_lon)
		endelse

	;Display rempaped image
	tv,im,stx,sty

	; Map over remapped image
	map_set,-7.5,lon_mid,/cont,limit=[-90,lon_low,90,lon_high],$
		/noborder,title=title,/noerase,/grid,/ortho

	; Read in screen
	buffer=tvrd()
	tvlct,r,g,b,/get
	;out=name+string(35-i)
	;out=strcompress(out,/remove)
	;write_gif,out,buffer,r,g,b
	output(*,*,35-i)=buffer


endfor
wdelete,2

return
end
