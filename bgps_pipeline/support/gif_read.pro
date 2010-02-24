pro gif_read,file,im,r,g,b,view=view
;+
; ROUTINE:      gif_read
;
; PURPOSE:      copy image on current window to a gif image file
;
; USEAGE:       gif_read,file
;
; INPUT:
;   file        gif file name
;
; KEYWORD INPUT:
;  view         if set display the image 
;
; OUTPUT:       
;   im          image array
;   r,g,b       color vectors
;
; SIDE EFFECTS: if VIEW is set, the color table is altered to match the
;               RGB settings read from the file
;
; EXAMPLE:
;               loadct,5
;               window,0
;               tvim,sin(hanning(200,200))
;               gif_write,'test_image.gif'
;               wdelete,0
;               gif_read,'test_image.gif',/view
;
;  author:  Paul Ricchiazzi                            feb94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
; REVISIONS:
;-
;
read_gif,file,im,r,g,b
if keyword_set(view) then begin
  tvlct,r,g,b
  tv,im
endif
end
