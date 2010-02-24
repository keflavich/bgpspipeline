 function boxpos,aspect=aspect,rmarg=rmarg,xpos=xpos,ypos=ypos,get=get,$
            curbox=curbox,print=print
;+
; ROUTINE:   boxpos
; USEAGE:
;            result=boxpos()
;            result=boxpos(aspect=aspect,rmarg=rmarg,xpos=xpos,ypos=ypos,$
;                         get=get,curbox=curbox,print=print)
;
; PURPOSE:   returns the 4 element position of a properly shaped data window.
;            output is in normalized coordinates
;
; INPUT:
;
;    none required
;
; keyword input:
;
;    aspect       x/y aspect ratio of map (default = 1)
;
;    rmarg        the amount of margin to leave on the right side of the
;                 box.  The margin is specified in units of 10 character
;                 widths, so merely setting the RMARG parameter provides
;                 enough space for COLOR_KEY
;
;    get          if set, retrieve the position information of the last
;                 plot drawn. 
; 
;    xpos         two element vector specifying x position of a multi frame
;                 plot,  the first element specifies the frame number, the
;                 second element specifies the number of frames
;                
;    ypos         two element vector specifying y position of a multi frame
;                 plot, the first element specifies the frame number, the
;                 second element specifies the number of frames
;
;    print        if set, print out the normal coordinates of the box
;                 edges in format,
;                                   pos=[x0,y0,x1,y1]
;
;                 where (x0,y0) and (x1,y1) are the normal coordiates
;                 of the lower left and upper right corners of the box
;                 The default value of PRINT is 1 if the CURSOR keyword
;                 is set.
;
;                
; OUTPUT:
;                 result=[x1,y1,x2,y2], 
;                 where (x1,y1) and (x2,y2) are the lower left hand
;                 and upper right hand corner of the new data window
;                 in normalized coordinates.
;                 
; EXAMPLE:        Draw a map over a TVIM image
;
;     tvim,dist(200)
;     map_set,0,0,/orth,/cont,/grid,pos=boxpos(/get),/noerase
;
;                 Draw a map of the southern hemisphere with 2:1 aspect
;                 ratio
;
;     map_set,-90,0,/orth,/cont,/grid,pos=boxpos(aspect=2)
;                  
;                    now try a 1:1 aspect ratio
;
;     map_set,-90,0,/orth,/cont,/grid,pos=boxpos(/aspect)
;
;                  now allow room for color key, and draw color key
;
;     map_set,-90,0,/orth,/cont,/grid,pos=boxpos(/aspect,/rmarg)
;     color_key
;
;
;                Draw a multframe plot 
; 
;     x=findgen(100)
;     plot,x,x,pos=boxpos(aspect=1,ypos=[3,3])
;     plot,x,x^2,pos=boxpos(aspect=1,ypos=[2,3]),/noerase
;     plot,x,x^3,pos=boxpos(aspect=1,ypos=[1,3]),/noerase
;
;
;;    NOTE: the XMULTI and YMULTI proceedures (in this directory) can
;;          also be used to make multiframe plots and are more flexible
;;          than BOXPOS for positioning the individual frames.
;
;  author:  Paul Ricchiazzi                            25jan93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;
;-
;

case 1 of 
keyword_set(get) eq 1 :    begin
                             px=!x.window
                             py=!y.window
                           end
keyword_set(curbox) eq 1 : begin
                             curbox,x1,x2,y1,y2,/message
                             px=[x1,x2]
                             py=[y1,y2]
                             if n_elements(print) eq 0 then print=1
                           end
else:                      begin
                             plot,[0,0],xstyle=4,ystyle=4,/nodata,/noerase
                             if keyword_set(aspect) eq 0 then aspect=1.
                             if keyword_set(rmarg) then  $
                                space=rmarg*10*!d.x_ch_size else space=0
                             px=!x.window
                             py=!y.window
                             xs=px(1)-px(0)
                             ys=py(1)-py(0)
                             xsize=xs*!d.x_vsize-space
                             ysize=ys*!d.y_vsize
                             if xsize gt ysize*aspect then begin
                               tmarg=xsize-ysize*aspect
                               xsize=ysize*aspect 
                               px(0)=px(0)+.5*tmarg/!d.x_vsize
                             endif else begin
                               tmarg=ysize-xsize/aspect
                               ysize=xsize/aspect
                               py(0)=py(0)+.5*tmarg/!d.y_vsize
                             endelse
                             px(1)=px(0)+xsize/!d.x_vsize
                             py(1)=py(0)+ysize/!d.y_vsize
                           end
endcase

if n_elements(xpos) ne 0 then begin
  pxx0=px(0)+(xpos(0)-1)*(px(1)-px(0))/float(xpos(1))
  pxx1=px(0)+xpos(0)*(px(1)-px(0))/float(xpos(1))
  px=[pxx0,pxx1]
endif
if n_elements(ypos) ne 0 then begin
  pyy0=py(0)+(ypos(0)-1)*(py(1)-py(0))/float(ypos(1))
  pyy1=py(0)+ypos(0)*(py(1)-py(0))/float(ypos(1))
  py=[pyy0,pyy1]
endif

if keyword_set(print) then begin
  xn0=string(px(0))
  xn1=string(px(1))
  yn0=string(py(0))
  yn1=string(py(1))
  print,strcompress("pos=["+xn0+","+yn0+","+xn1+","+yn1+"]",/remove_all)
endif

return,[px(0),py(0),px(1),py(1)]
end









