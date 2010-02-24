function color_frame,color,pos=pos,xmargin=xmargin,ymargin=ymargin, $
                     bg_color=bg_color
;+
; ROUTINE:  color_frame
;
; PURPOSE:  draw a color background on which to overlay plots
;
; USEAGE:   result=color_frame(color,pos=pos,xmargin=xmargin,ymargin=ymargin)
;
; INPUT:  
;   color  
;     the background color of the plot frame  
;   
;
; KEYWORD INPUT:
;   pos
;     4 element vector specifying the lower left and upper right
;     normalized coordinates of the plot frame [xll,yll,xur,yur]
;
;   xmargin
;     2 element vector specifying the left and right margins in character
;     width units
;
;   ymargin
;     2 element vector specifying the lower and upper margins in character
;     height units
;
;   bg_color
;     back ground color used outside of plot frame
;;
; OUTPUT:
;   result
;     4 element vector specifying the lower left and upper right
;     normalized coordinates of the plot frame [xll,yll,xur,yur]
;
; DISCUSSION: 
;     COLOR_FRAME can be used to produce color backgrounds within plot
;     frames.  Since COLOR_FRAME itself calls PLOT to obtain the
;     default frame position, it is necessary to include the NOERASE
;     keyword in the PLOT call that actually draws the plot. When this
;     option is used new plots called with color_frame will not erase
;     the screen even when !p.multi(0)=0.  Thus, in order to start a
;     new page the user must explicitly erase the page using the ERASE
;     command.  See examples.
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE:  
;
;  !p.multi=[0,1,2]
;  loadct,5
;  xx=findrng(-2.5,2.5,200)
;  yy=exp(-xx^2)
;  yc=cos(xx*10)
;  plot,xx,yy,pos=color_frame(50),/noerase
;  plot,xx,yc*yy,pos=color_frame(70),/noerase
;  erase
;  plot,xx,yc^2*yy,pos=color_frame(90),/noerase
;  plot,xx,yc^3*yy,pos=color_frame(110),/noerase
;   
;;; multi-frame plot
;
;  loadct,5
;  !p.multi=[0,1,2]
;  plot,xx,yy,pos=color_frame(100,ymargin=ymulti(p,np=2)),/noerase
;  plot,xx,yc*yy,pos=color_frame(60,ymargin=ymulti(p)),/noerase
;   
;;; plot within a plot
;
;  loadct,5
;  polyfill,[0,1,1,0,0],[0,0,1,1,0],color=bg_color,/norm
;  !p.multi=0
;  plot,xx,yy*yc,pos=color_frame(50),/noerase
;  plot,xx,yy,pos=color_frame(100,pos=boxpos(/cur)),/noerase
;
; AUTHOR:   Paul Ricchiazzi                        23 Feb 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;

if keyword_set(pos) then begin
  xx=pos([0,2,2,0,0])
  yy=pos([1,1,3,3,1])
endif else begin
  if not keyword_set(xmargin) then xmargin=!x.margin
  if not keyword_set(ymargin) then ymargin=!y.margin
  plot,[0,1],[0,1],/nodata,xstyle=5,ystyle=5,xmargin=xmargin,ymargin=ymargin
  xx=!x.window([0,1,1,0,0])
  yy=!y.window([0,0,1,1,0])
endelse

polyfill,xx,yy,/norm,color=color

return,[xx(0),yy(0),xx(2),yy(2)]

end
