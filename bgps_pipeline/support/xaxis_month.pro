pro xaxis_month,year,top=top,charsize=charsize
;+
; ROUTINE:    xaxis_month
;
; PURPOSE:    label x axis with month names when the x axis plot quantity
;             is day of year
;
; USEAGE:     xaxis_month,year
;
; INPUT:      
;   year      year, reqiured to set leap year calendar.  if not set a
;             non-leap-year is used. 
;
; OUTPUT:     none
;
; SIDE EFFECTS:
;             draws in the x axis with month labels and tick marks 
;             between months
;  
; EXAMPLE:
;             x=indgen(365)+1
;             zensun,x,12,35,0,zen
;             plot,x,zen,xstyle=5,title='solar zenith angle',ytitle='zenith'
;             xaxis_month
;
; REVISIONS:
;
;  author:  Paul Ricchiazzi                            jan94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
if not keyword_set(year) then year=1994
if not keyword_set(top) then top=0
if not keyword_set(charsize) then begin
  if !p.charsize eq 0 then charsize=1. else charsize=!p.charsize
endif
xlab=intarr(12)
xtic=intarr(13)

for i=1,12 do xlab(i-1)=julday(i,15,year)-julday(1,0,year)
for i=1,13 do xtic(i-1)=julday(i,0,year)-julday(1,0,year)

month=['Jan','Feb','Mar','Apr','May','Jun',$
       'Jul','Aug','Sep','Oct','Nov','Dec']

oplot,!x.crange([0,1]),!y.crange([0,0])
oplot,!x.crange([0,1]),!y.crange([1,1])

ticl=.01*(!y.crange(1)-!y.crange(0))

for i=0,12 do oplot,xtic([i,i]),!y.crange(0)+2*[0,ticl]
for i=0,12 do oplot,xtic([i,i]),!y.crange(1)-2*[0,ticl]
for i=0,11 do oplot,xlab([i,i]),!y.crange(0)+[0,ticl]
for i=0,11 do oplot,xlab([i,i]),!y.crange(1)-[0,ticl]


yline=charsize*!d.y_ch_size*(!y.crange(1)-!y.crange(0))/$
                   (!d.y_vsize*(!y.window(1)-!y.window(0)))

ylab=!y.crange(0)-2*yline

xyouts,xlab,ylab,month,align=.5

end
