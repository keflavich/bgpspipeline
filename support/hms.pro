 function hms,time
;+
; NAME:         hms
;
; PURPOSE:      convert time in seconds to a time string in hh:mm:ss format
;
; USEAGE:       time_string=hms(time)
; 
; INPUTS:       time (seconds)
;
; RESTRICTIONS  time must be positive
;
; KEYWORDS:     none
;
; OUTPUTS:      return time string
;
; AUTHOR:       Paul Ricchiazzi       4jan94
;               Earth Space Research Group, UC Santa Barabara
;
;-
ts=long(time)
hh=ts / 3600
mm=(ts-hh*3600) / 60
ss=(ts-hh*3600-mm*60)
if hh gt 0 then digits=fix(abs(alog10(hh))+1) > 2 else digits=2
nd=strcompress(string(digits),/remove_all)
fmt='(i' + nd + ',":",i2.2,":",i2.2)'
return,string(f=fmt,hh,mm,ss)
end










