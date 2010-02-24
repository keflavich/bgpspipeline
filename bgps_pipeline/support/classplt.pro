 pro classplt,xx,yy,alat,alon,title=title,xtitle=xtitle,ytitle=ytitle,sym=sym
;+
; ROUTINE:   classplt
;
; USEAGE:    classplt,xx
;
;            classplt,xx,yy,alat,alon,$
;                    [title=title,xtitle=xtitle,ytitle=ytitle,sym=sym]
;
; PURPOSE:   Draws two seperate plots to the graphics device:
;            1. 2-d scatter plot of yy vs xx
;            2. physical position of selected classes with respect
;               to coastline features.
; 
; INPUT:
;     xx       index array of selected points for a class 
;              (class definition mode)
;
;     xx       2-D array, x quantity of scatter plot (ploting mode)
;     yy       2-D array, y quantity of scatter plot     
;     alat     latitude array
;     alon     longitude array
;     title    plot title (optional).  One or two element string array
;              if two strings are specified the first string is used to
;              title the scatter plot while the second titles the mapped
;              plot
;     xtitle   x title (optional)
;     ytitle   y title (optional)
;     sym      a vector of symbol index values.  Classes are assigned symbols
;              in the sequence specified in SYM. (default=[1,4,7,5,6,2])
;              (1=+, 2=*, 3=., 4=diamond, 5=triangle, 6=square, 7=x)
;
;
; PROCEDURE:   At least two steps are required to make plots with CLASSPLT: 
;
;              1. In class definition mode CLASSPLT is called with a single 
;                 argument one or more times to accumulate class definitions
;                 to be used later in the ploting mode.
;              2. In plotting mode CLASSPLT is called with at least 4 
;                 arguments.  In this mode CLASSPLT produces a scatter 
;                 plot and position plot of the previously defined classes.
;
; EXAMPLE:
;
; a4=congrid(avhrr4,40,30)                        ; reduce size of sample set
; a3=congrid(avhrr3,40,30)                        ;   could also use SUPERPIX
;
; classplt,inside(a4,a3-a4,[3,6,5,3],[4,3,5,4])   ; define classes
; classplt,where(a4 gt -6 and a3-a4 lt 8)         ;
; classplt,where(a4 gt -17 and a3-a4 gt 8)        ; 
;
; classplt,a4,a3-a4,alat,alon                     ; make the plot
;
; Here is a sequence of commands which uses the interactive graphics
; procedure, INSIDE, to simplify class specifcation.
; 
; classplt,inside(a4,a3-a4)
; classplt,inside(a4,a3-a4)
; classplt,inside(a4,a3-a4)
; classplt,a4,a3-a4,alat,alon
;
; COMMON BLOCKS: classblk
;
;
;  author:  Paul Ricchiazzi                            oct92 
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
;

if n_params() eq 0 then begin
  xhelp,'classplt'
  return
endif  

ncl=6
common classblk,count,m,mx,jj
if n_params() eq 1 then begin
  if keyword_set(count) eq 0 then count=0
  if count eq 0 then begin
    jj=lonarr(10000)
    m=intarr(ncl)
    nn=n_elements(xx)
    m(count)=nn
    jj(0:nn-1)=xx
    print,'number in class:',m(0)
  endif else begin
    if count gt ncl then message,'can not store, too many classes'
    nn=n_elements(xx)
    m(count)=m(count-1)+nn
    i1=m(count-1)
    i2=m(count)-1
    jj(i1:i2)=xx
    print,'number in class:',m(0:count)
  endelse
  mx=count
  count=count+1
endif else begin

;
  if keyword_set(sym) eq 0 then sym=[1,4,7,5,6,2]
  title_a=''
  title_b=''
  if keyword_set(title) ne 0 then begin
    title_a=title(0)
    if n_elements(title) eq 2 then title_b=title(1)
  endif
  if keyword_set(xtitle) eq 0 then xtitle=''
  if keyword_set(ytitle) eq 0 then ytitle=''

  pmulti=!p.multi
  !p.multi=[0,1,2]
  print,'number in class:',m(0:mx)
  print,'symbol of class:',sym(0:mx)

  plot,xx,yy,psym=3,title=title_a,xtitle=xtitle,ytitle=ytitle
  for i=0,mx do begin
    if i eq 0 then k=jj(0:m(0)-1) else k=jj(m(i-1):m(i)-1)
    oplot,xx(k),yy(k),psym=sym(i)
  endfor

  sz=size(xx)
  nx=sz(1)
  ny=sz(2)
  latmin=min(alat)
  latmax=max(alat)
  lonmin=min(alon)
  lonmax=max(alon)
  xc0=lonmin
  xc1=(lonmax-lonmin)/(nx-1)
  yc0=latmin
  yc1=(latmax-latmin)/(ny-1)

  xp=xc0+xc1*(findgen(nx) # replicate(1,ny))
  yp=yc0+yc1*(replicate(1,nx) # findgen(ny))
  plot,xp,yp,title=title_b,psym=3,xstyle=1,ystyle=1,$
            xtitle='Longitude',ytitle='Latitude'
  for i=0,mx do begin
    if i eq 0 then k=jj(0:m(0)-1) else k=jj(m(i-1):m(i)-1)
    xp=xc0+xc1*float(k mod nx)
    yp=yc0+yc1*float(k/nx)
    oplot,xp,yp,psym=sym(i)
  endfor
  coastline,alat,alon
  count=0                       ; reset count
  !p.multi=pmulti
endelse
end







