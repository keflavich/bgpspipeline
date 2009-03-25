 pro timestamp,label,charsize=charsize,right=right
;+
; ROUTINE      timestamp
; PURPOSE      print the current day and time in the lower right corner of
;              the device window
; 
; USEAGE       timestamp
;              timestamp,label,charsize=charsize
; INPUT:
;    label     optional label string. If LABEL not supplied the current
;              working directory is used
;
; KEYWORD INPUT:
;    charsize  character size multiplier (default=0.5)
;    right     put timestamp at lower right corner of the page
;              (default is lower left corner)
;
; OUTPUT:      none
;
; AUTHOR:              Paul Ricchiazzi    oct92 
;                      Earth Space Research Group, UCSB
;-

time=systime()
year=strmid(time,22,2)
month=strmid(time,4,3)
day=strmid(time,8,2)
t=strmid(time,10,9)

if keyword_set(label) eq 0 then cd,current=label
stamp=label+' '+day+month+year+t

len=strlen(stamp)
if keyword_set(charsize) eq 0 then charsize=.5
charwidth=!d.x_ch_size*charsize
charheight=!d.y_ch_size*charsize
if keyword_set(right) then xt=!d.x_vsize-charwidth*(len+2) else xt=0
yt=.5*charheight
xyouts,xt,yt,stamp,/device,charsize=charsize
return
end




