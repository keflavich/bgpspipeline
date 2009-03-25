 PRO text_box,text,pos=pos,fg_color=fg_color,bg_color=bg_color,$
               center=center,right=right,box=box,vert_space=vert_space
;+
; Name        : text_box
;
; Purpose     : Writes a text message within a box in a graphics window.
;
; Description:  This procedure writes a short text message within a box-shaped
;               area in a graphics window.  The message may be split at word
;               boundaries into several lines, and the character size and
;               orientation may be adjusted for the text to fit within the box.
;
; Useage:       text_box,text,pos=pos,color=color,$
;                    justify=justify,vert_space=vert_space
;
; Inputs      
; TEXT          ASCII text string containing the message.
;
; keywords
;  pos          4 element vector specifying the box position and size
;               pos(0),pos(1) specify the lower left corner coordinate
;               pos(2),pos(3) specify the upper right corner coordinate
;               data window normalized coordinates are use
;
;   fg_color    color of box and legend titles (default=!P.COLOR)
;
;   bg_color    background color. Setting BG_COLOR erases the area 
;               covered by the text box (filling it with color BG_COLOR)
;               prior to writing the text.  If both BG_COLOR and !p.color
;               are zero then the background color is reset to 255 to
;               gaurantee a readability.
;               
;  right        if set, right justify text
;  center       if set, center the text
;
;  vert_space   vertical spacing of lines in units of character height 
;               (default = 1.5)
;
;
;  author:  Paul Ricchiazzi                            7Jul93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;
        ON_ERROR, 2
;
;  Check the number of parameters.
;
justify=-1
if keyword_set(right) ne 0 then justify=1
if keyword_set(center) ne 0 then justify=0
if keyword_set(vert_space) eq 0 then vert_space= 1.5
IF n_elements(text) eq 0 then message, 'must specify text'
nnx=!x.window*!d.x_vsize
nny=!y.window*!d.y_vsize


if n_elements(pos) eq 0 then begin

  box_cursor,xx1,yy1,nx,ny
  xx2=xx1+nx
  yy2=yy1+ny
  pos=[(xx1-nnx(0))/(nnx(1)-nnx(0)),(yy1-nny(0))/(nny(1)-nny(0)),$
       (xx2-nnx(0))/(nnx(1)-nnx(0)),(yy2-nny(0))/(nny(1)-nny(0))]
  posstring=string(form='(a,4(f5.2,a))',$
           ',pos=[',pos(0),',',pos(1),',',pos(2),',',pos(3),']')
  print,strcompress(posstring,/remove_all)

   
endif else begin
  
  
  xx1 = nnx(0)+pos(0)*(nnx(1)-nnx(0))
  xx2 = nnx(0)+pos(2)*(nnx(1)-nnx(0))
  yy1 = nny(0)+pos(1)*(nny(1)-nnx(0))
  yy2 = nny(0)+pos(3)*(nny(1)-nnx(0))

endelse
;
;  calculate the height and width of the box in characters.
;
  width  = (xx2 - xx1) / !d.x_ch_size
  height = (yy2 - yy1) / !d.y_ch_size
;
;  decompose the message into words.
;
  words = str_sep(text,' ')
; print,f='(20a)',words
  nwords=n_elements(words)
  wordlen=lenstr(words)*!d.x_vsize
  blanklen=lenstr(' ')*!d.x_vsize
  maxcharsize=(xx2-xx1)/(4*blanklen+max(wordlen))
  charsize=1  
  lpnt=intarr(nwords)
  nomore=0
  ntries=0
  repeat begin
    ntries=ntries+1
    if ntries gt 20 then message,'Can not fit message into box'
    ychsiz=vert_space*!d.y_ch_size*charsize
    wlen=wordlen*charsize
    blen=blanklen*charsize
    n_lines=fix((yy2-yy1)/ychsiz)-1
    sum=0
    ilines=0
;   print,f='(8a8)','charsz','i','ilines','n_lines','lpnt','wlen','sum','xwdth'
    for i=0,nwords-1 do begin
      sum=sum+wlen(i)+blen
      if sum+3*blen gt xx2-xx1 then begin
        ilines=ilines+1
        sum=wlen(i)+blen
      endif
      lpnt(i)=ilines        
      
;      print,f='(f8.2,4i8,3f8.2)',charsize,i,ilines,n_lines,lpnt(i),$
;                 wlen(i)+blen,sum+3*blen,xx2-xx1
    endfor        
    case 1 of
      ilines+1 lt n_lines: if charsize*1.1 gt maxcharsize then $
          vert_space=(yy2-yy1)/((n_lines-1)*!d.y_ch_size*charsize) $
          else charsize=charsize*1.1
      ilines+1 eq n_lines: nomore=1
      ilines+1 gt n_lines: charsize=charsize*.9
    endcase
endrep until nomore 

lines=strarr(n_lines)
maxlen=0

for i=0,n_lines-1 do begin
  ii=where(lpnt eq i,nc)
  maxlen=(total(wlen(ii))+nc*blen)>maxlen
  lines(i)=string(f='(200a)',words(ii)+' ')
; print,i,words(ii)
; print,i,lines(i)
endfor

;
  align=.5*(1+justify)
  
  case justify of
    -1:xx = xx1+.5*((xx2-xx1)-maxlen)
     0:xx = 0.5*(xx1 + xx2)
     1:xx = xx2-.5*((xx2-xx1)-maxlen)
  endcase

  dy=!d.y_ch_size*charsize*vert_space
  yy=yy2-0.5*dy

  xbox=[xx1,xx2,xx2,xx1,xx1]
  ybox=[yy1,yy1,yy2,yy2,yy1]
  if n_elements(bg_color) ne 0 then begin
    if !p.color eq 0 and bg_color eq 0 then bgc=255 else bgc=bg_color
    polyfill,xbox,ybox,color=bgc,/device
  endif

  if n_elements(fg_color) eq 0 then color = !p.color else color=fg_color

  for i_line = 0,n_lines-1 do begin
    yy = yy-dy
;   print,xx,yy,lines(i_line),charsize
    xyouts, xx, yy, lines(i_line), /device, charsize=charsize, $
      alignment=align, color=color, font=-1
  endfor
  if keyword_set(box) then plots,xbox,ybox,color=color,/device
;
return
end

