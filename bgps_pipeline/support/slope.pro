pro slope,a,b
;+
; NAME:         slope
;
; PURPOSE:      compute a two point fitting function, y=f(x)
;
; USEAGE:       slope,a,b
; 
; INPUTS:       none
;
; KEYWORDS:     none
;
; OUTPUTS:      
;   a           fit coefficients
;   b           fit coefficients
;
; PROCEDURE:    use the LMB to specify two points on the plot.  
;               The form of the fitting function depends on whether the plot 
;               has log axis in either the x or y directions, as follows,
;
;                       x          y
;                      linear - linear           y=a+b*x
;                      log    - linear           y=a+b*log(x)
;                      linear -  log             y=a*exp(b*x)
;                      log    -  log             y=a*x^b
;
;               After two points are chosen SLOPE will show the form of the
;               fitting function and the value of a and b in an XMESSAGE
;               widget.  At this point the user can exit the procedure by
;               hitting any of the mouse buttons.  The XMESSAGE widget is not
;               not destroyed if the RMB is used to exit SLOPE.
;                
;
;  author:  Paul Ricchiazzi                            nov93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
; REVISIONS:    
;
;-
label=replicate('-------------------------------------------',3)

case 2*!y.type+!x.type  of
  0:label(0)='               y = a + b * x               '
  1:label(0)='             y = a + b * log(x)            '
  2:label(0)='              y = a * exp(b*x)             '
  3:label(0)='                 y = a * x^b               '
endcase
label(2)='use mouse to select first point'
xmessage,label,wbase=wbase,wlabel=wlabel,title='slope.pro'
device, get_graphics = old, set_graphics = 6 

tvcrs,!d.x_vsize/2,!d.y_vsize/2
cursor,x1,y1,/w,/up
label(2)='use mouse to select second point'
xmessage,label(2),relabel=wlabel(2)
cursor,x2,y2,/w
xx=[x1,x2]
yy=[y1,y2]

if !x.type eq 1 then begin
  x1=alog(x1)
  x2=alog(x2)
endif
if !y.type eq 1 then begin
  y1=alog(y1)
  y2=alog(y2)
endif
dydx=(y2-y1)/(x2-x1)
y0=y1-dydx*x1

b=dydx
if !y.type eq 1 then a=exp(y0) else a=y0

label(2)=strcompress(' a = '+string(a)) + '    ' $
        +strcompress(' b = '+string(b))

xmessage,label(2),relabel=wlabel(2)
plots,xx,yy
device,cursor_standard=16
tvcrs,!d.x_vsize/2,!d.y_vsize/2
cursor,xdum,ydum,/wait,/up,/device
cursor,xdum,ydum,/wait,/device
plots,xx,yy
device,cursor_standard=30,set_graphics=old
if !err ne 4 then xmessage,kill=wbase

return
end












