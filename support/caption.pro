pro caption,cap,xx,ybot=ybot,ytop=ytop,nchar=nchar,exdent=exdent, $
            color=color,bg_color=bg_color,vspace=vspace,fill=fill, $
            nowrap=nowrap
;+
; ROUTINE:  caption
;
; PURPOSE:  CAPTION can be used to print captions above or below a
;           figures.  The character size is determined by the number
;           of characters per line.  
;
; USEAGE:   caption,cap,xx,ybot=ybot,yt=ytop,nchar=nchar
;
; INPUT:    
;
;   cap     string used for caption.  Normally all text within CAP 
;           is line wrapped to produce a multiline caption. All
;           white space within CAP is preserved in the caption.
;           Within CAP the character "\" can be used to force a line
;           break (i.e., to start a new line).  Extra white space
;           following the "\" causes the text to be indented.
;
;           t='this is a test \     junk test test'+$
;             ' \     junk test \ \    junk: this is a test'
;
;           caption,t
;
;                             PRODUCES:
;
;           this is a test
;                junk test test
;                junk test
;
;                junk: this is a test
;
;           Note that the backslash character must be surrounded by
;           whitespace to be recognized
;
;  
;   xx      normal coordinates of left and right edge of caption
;   
;
; KEYWORD INPUT:
;
;   ytop       normal coordinates of top of caption
;              (default=!y.window(0)-.15)
;
;   nchar      number of characters per line
;
;   vspace     vertical space factor, controls vertical space between
;              lines (default = 1)
;
;   bg_color   background color
;
;   color      foreground color
;
;   exdent     number of character positions to indent all lines except
;              the first. (default=0)
;
;   nowrap     if set do not line wrap the input text, instead use
;              embedded backslash characters to control line breaks.
;
; KEYWORD OUTPUT:
;
;   ybot       normal coordinates of bottom of caption. The value of
;              of ybot can be used append more text with another call
;              to CAPTION.
;
; DISCUSSION:
;
; LIMITATIONS:
;
; COMMON BLOCKS:
;
; SIDE EFFECTS:
;  
; EXAMPLE:  
;
;    t1='CAPTION can be used to print captions above or below a '+$
;      'figures.  The character size is determined by the number '+$
;      'of characters per line.   here is a list of items: \ '+$
;      '     1. item 1 \ '+$
;      '     2. item 2 \ '+$
;      'END OF FIRST CAPTION
;       
;    t2='BEGINNING OF SECOND CAPTION \ HERE is more text to add to  '+$
;      'the previous text. Note how the  '+$
;      'text starts immediately below the last line of the previous  '+$
;      'written text. The use of ybot allows concatenation of text with  '+$
;      'different right and left margins'
;       
;    w8x11 & !p.multi=[0,1,2]
;    plot,dist(10)
;       
;    caption,t1,nchar=80,ybot=yy
;    xwid=.5*(!x.window(1)-!x.window(0))
;    xmid=.5*(!x.window(0)+!x.window(1))
;    caption,t2,xwid+.5*[-xwid,xwid],nchar=40,ytop=yy
;
;;; FILL option
;
;    t= 'HERE is more sample text to demonstrate the use of CAPTION''s, '+$
;       '"fill" option.  Note how the text is stretched to fill the '+$
;       'entire width of the line.  It is probably a good idea not '+$
;       'to force linebreaks using the backslash symbol while in this '+$
;       'mode.  The "fill" option works best when NCHAR is large'
;        
;    erase
;    caption,t,[.1,.9],ytop=.9,/fill,nchar=80
;       
;;; CAPTION used with READ_TEXT 
;
;   caption,read_text('caption.txt','Figure 1.'),nchar=60
;  
;
; AUTHOR:   Paul Ricchiazzi                        12 Mar 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if n_elements(nchar) eq 0 then nchar=60
if n_elements(xx) eq 0 then xx=!x.window
if n_elements(ytop) eq 0 then ytop=!y.window(0)-.15

if not keyword_set(exdent) then exdent=0

if keyword_set(nowrap) then begin
  str=cap
  nlines=n_elements(str_sep(str,'\'))
endif else begin
  str=pfill(cap,nchar=nchar,nlines=nlines,exdent=exdent)
endelse


if not keyword_set(vspace) then vspace=1.

capnum=nchar*!d.x_ch_size
capwidth=(xx(1)-xx(0))*!d.x_vsize
charsize=capwidth/capnum

ysz=charsize*float(!d.y_ch_size)/!d.y_vsize
xsz=charsize*float(!d.x_ch_size)/!d.x_vsize

ybot=ytop-1.1*ysz*(nlines)*vspace

if n_elements(color) eq 0 then color=!p.color

sss=str_sep(str,'\')
nn=n_elements(sss)

if n_elements(bg_color) ne 0 or keyword_set(fill) then len=lenstr(sss)


if n_elements(bg_color) ne 0 then begin
  xbox=[xx(0)-xsz,xx(1)] & xbox=xbox([0,1,1,0,0])
  ybox=[ybot,ytop+ysz]   & ybox=ybox([0,0,1,1,0])
  polyfill,xbox,ybox,color=bg_color,/norm
  plots,xbox,ybox,color=color,/norm
endif

yy=ytop
x1=xx(0)
x2=xx(1)-xsz

for i=0,nn-1 do begin
  if keyword_set(fill) then begin
    yoff=0.
    sl=sss(i)
    ll=len(i)
    sar=strarr(200)
    ic=0
    for p=0,strlen(sl)-1 do begin      
      s=strmid(sl,p,1)                 
      if s eq '!' then begin           
        p=p+1                          
        sa=strmid(sl,p,1)              
        s=s+sa                         
        if sa eq '1' then begin        
          p=p+1                        
          s=s+strmid(sl,p,1)           
        endif                          
      endif                            
      sar(ic)=s                        
      ic=ic+1                          
    endfor    
    x=x1
    if i lt nn-1 or i eq 0 then fac=(x2-x1)/(charsize*ll)
    for j=0,ic-1 do begin
      sch=sar(j)
      if strmid(sch,0,1) eq '!'  then begin
        esc=strlowcase(strmid(sch,1,1))
        if esc ge '0' and esc le '9' then fnt=sch
        case esc of
          'a':yoff=yoff+.6*ysz
          'b':yoff=yoff-.6*ysz
          'e':yoff=yoff+.6*ysz
          'd':yoff=yoff-.6*ysz
          'n':yoff=0.
          'x':if keyword_set(font) then sch=font else sch='!3'
          else:
        endcase
      endif

      xyouts,x,yy+yoff,sch,charsize=charsize,/norm,color=color,width=width
      x=x+width*fac
    endfor
  endif else begin
    xyouts,x1,yy,sss(i),charsize=charsize,/norm,color=color
  endelse
  yy=yy-ysz*1.1*vspace
endfor

ybot=yy

end


