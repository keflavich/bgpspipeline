pro color_pal
;+
; ROUTINE:                 color_pal
;
; AUTHOR:                 Terry Figel, ESRG, UCSB 10-21-92
;
; CALLING SEQUENCE:        color_pal
;
; PURPOSE:                 Displays Color palette in a seperate window
;-

col_pal=findgen(255,50)
oldwin=!d.window
window,15,xs=255,ys=50,title='color_pal'
for i=0,254 do col_pal(i,*)=i 
tvscl,col_pal>0<255
if oldwin ne -1 then wset,oldwin 
return
end

