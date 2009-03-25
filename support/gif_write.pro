pro gif_write,file,wid=wid,fgc=fgc,bgc=bgc
;+
; ROUTINE:      gif_write
;
; PURPOSE:      copy image on current window to a gif image file
;
; USEAGE:       gif_write,file
;
; INPUT:
;   file        output file name, image will be written in gif image format
;
; KEYWORD INPUT:
;   wid         index of the idl window from which to copy the image,
;               if not set gif_write copies from current default window
;
;   bgc         background color.  sets color index 0 of gif image to 
;               specified RGB value.  Does not affect current color table.
;               A scalor value of BGC is automatically turned into a color
;               triplet, i.e., bgc=255   =>  RGB=[255,255,255]
;
;   fgc         foreground color.  sets color index 255 of gif image to 
;               specified RGB value.  Does not affect current color table.
;               A scalor value of FGC is automatically turned into a color
;               triplet, i.e., fgc=0   =>  RGB=[0,0,0]
;
; OUTPUT:       none
;
; EXAMPLE:
;           loadct,5
;           window,0
;           tvim,sin(20*hanning(200,200)*dist(200)),title='GIF test image',/sc
;           gif_write,'test_image.gif',fgc=0,bgc=[210,255,210]
;           exit
;
;           xv test_image.gif
;
;  author:  Paul Ricchiazzi                            feb94
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
; REVISIONS:
;-
;
if n_elements(wid) ne 0 then begin
  oldwin=!d.window
  wset,wid
endif

tvlct,r,g,b,/get
im=bytscl(tvrd())

r=congrid(r,256,/minus_one)
g=congrid(g,256,/minus_one)
b=congrid(b,256,/minus_one)

case n_elements(fgc) of
1:begin
  r(255)=fgc
  g(255)=fgc
  b(255)=fgc
end
3:begin
  r(255)=fgc(0)
  g(255)=fgc(1)
  b(255)=fgc(2)
end
else:
endcase

case n_elements(bgc) of
1:begin
  r(0)=bgc
  g(0)=bgc
  b(0)=bgc
end
3:begin
  r(0)=bgc(0)
  g(0)=bgc(1)
  b(0)=bgc(2)
end
else:
endcase

write_gif,file,im,r,g,b

if n_elements(wid) ne 0 then wset,oldwin
end
