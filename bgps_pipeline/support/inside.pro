 function inside,xx,yy,xpoly,ypoly,psym=psym,nbin=nbin
;+
; ROUTINE:       inside
;
; USEAGE:        RESULT = inside(xx,yy)
;                RESULT = inside(xx,yy,xpoly,ypoly,nbin=nbin)
;
; PURPOSE:       find the indices of the data quantities xx and yy which
;                lie inside a given polygonal region
;
; INPUT: 
;   xx           vector of quantity x, ploted on x axis of scatter plot
;   yy           vector of quantity y, ploted on y axis of scatter plot
;
; OPTIONAL INPUT:
;
;   xpoly        vector of x coordinates vertices of polygon
;   ypoly        vector of y coordinates vertices of polygon
; 
; OPTIONAL KEYWORD INPUT:
;
;   psym         if set, selected points are marked with symbol psym.
;                if psym=3, the screen is erased and a new plot is drawn.
;                this only works if the boundaries are specified 
;                interactively.
;
;   nbin         number of bins with which to resolve the polygon.
;                A two element vector may be used to specify number 
;                in x and y directions seperately.  (DEFAULT = 100)
;
; OUTPUT:
;                returned value = vector of array indecies inside polygon
;
; PROCEDURE:     If xpoly and ypoly are not supplied, the operator 
;                specifies the region using the interactive graphics
;                procedure, TRACE.
;                
;
; EXAMPLE
;          x=randomn(seed,20,20)
;          y=sin(5*x)+.8*randomn(seed,20,20)
;          plot,x,y,psym=3
;          i1=inside(x,y,psym=4)         ; the indecies of the data points
;          i2=inside(x,y,psym=5)         ; which are inside polygonal area
;          
;
; AUTHOR:              Paul Ricchiazzi    oct92 
;                      Earth Space Research Group, UCSB
;-

if n_params() eq 0 then begin
  xhelp,'inside'
  return,0
endif  

if keyword_set(xpoly) eq 0 then begin
  trace,xpoly,ypoly,/restore
  frmx=  '("xpoly= [",g8.3,'+string(n_elements(xpoly)-1)+'(",",g8.3),"]")'
  frmy=  '("ypoly= [",g8.3,'+string(n_elements(xpoly)-1)+'(",",g8.3),"]")'
  print,strcompress(string(form=frmx,xpoly),/remove_all)
  print,strcompress(string(form=frmy,ypoly),/remove_all)
endif
xmin=min(xpoly)
xmax=max(xpoly)
ymin=min(ypoly)
ymax=max(ypoly)
xdif=xmax-xmin
ydif=ymax-ymin
xmin=xmin-.1*xdif
xmax=xmax+.1*xdif
ymin=ymin-.1*ydif
ymax=ymax+.1*ydif
xdif=xmax-xmin
ydif=ymax-ymin
;
if keyword_set(nbin) eq 0 then begin 
  nx=100 
  ny=100
endif else begin
  if n_elements(nbin) eq 1 then begin
    nx=nbin
    ny=nbin
  endif else begin
    nx=nbin(0)
    ny=nbin(1)
  endelse
endelse
;
xxx=fix((nx-1)*((xx-xmin)/xdif > 0. < 1.))
yyy=fix((ny-1)*((yy-ymin)/ydif > 0. < 1.))
xb=(nx-1)*(xpoly-xmin)/xdif > 0. < (nx-1)
yb=(nx-1)*(ypoly-ymin)/ydif > 0. < (ny-1)
ii=polyfillv(xb,yb,nx,ny)
mm=bytarr(nx,ny)
mm(ii)=1
jj=where(mm(xxx,yyy) eq 1)
if keyword_set(psym) ne 0 then oplot,xx(jj),yy(jj),psym=psym
return,jj
end


