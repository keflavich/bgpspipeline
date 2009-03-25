 pro tvb,im
;+
; ROUTINE:   tvb
;
; USEAGE:    tvb,im
;
; PURPOSE:   Display a large image in one window at reduced resolution.
;            Use the CURBOX routine to select a region of interest.
;            The sub-array is displayed in another window at full resolution
;            For each new sub-array the selected subscript range is printed
;            to the terminal.  
;
; INPUT:
;   im       a large two dimensional image array
;
; OUTPUT:    none
;
; PROCEDURE:
;            when first invoked TVB renders the full image (possibly
;            at reduced resolution) in a large window.  A region of
;            interest is selected via the CURBOX procedure, by moving
;            the mouse pointer or pressing the LMB or MMB to
;            decrease/increase the box size.  The region is selected
;            with the right mouse button.  Next, TVB draws the
;            selected region at full resolution in another window and
;            puts up a popup menu with 5 options.  The operator can
;            choose to
;
;         1. select a new region, killing the last special region window
;         2. select a new region, keeping the last special region window
;         3. blow up the current special region window by 50%
;         4. quit the procedure, keeping all windows
;         5. quit the procedure, killing all windows
;
; Side Effects:
;            When items 1,2,4 or 5 are selected the the sub-array indecies of 
;            the save window are printed to the terminal in format,
; 
;               window wid: (ix1:ix2, iy1:iy2)
;
;            where,
; 
;            wid      is the window id of the special region window
;            ix1:ix2  range of first subscript
;            iy1:iy2  range of second subscript
;
;            the sub array can be retrieved as,
; 
;            sub_array = im(ix1:ix2, iy1:iy2)
;
; EXAMPLE
;
;    loadct,5
;    im=randata(50,100,s=3)
;    im=congrid(im,500,1000,/interp)
;
;    tvb,im
;
;  author:  Paul Ricchiazzi                            oct93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
sz=size(im)
nx=sz(1)
ny=sz(2)
aspect=float(nx)/ny
if aspect gt 1. then begin
  nnx=1000 
  nny=1000/aspect
endif else begin
  nny=1000
  nnx=1000*aspect
endelse
window,/free,xs=nnx,ys=nny
tvscl,congrid(im,nnx,nny)
wind=!d.window

init=1
loop=1
xwin=[0.,1.]
ywin=[0.,1.]
xrng=[0,nx-1]
yrng=[0,ny-1]
szz=2^(3+indgen(10))
ib=where(nx/2 le szz)
ib=ib(0)
x1=nx/4
x2=x1+szz(ib)
y1=ny/4
y2=y1+szz(ib)
iwin=0
fmt='(a,i2,a,i3,a,i3,a)'

while loop eq 1 do begin

  wset,wind
  curbox, x1,x2,y1,y2,xwin,ywin,xrng,yrng,/init,inc=4,/message
  iwin=iwin+1
  xsz=x2-x1+1
  ysz=y2-y1+1
  zm=1
  while xsz<ysz lt 200 do begin & zm=2*zm & xsz=xsz*2 & ysz=ysz*2 & end
  while xsz>ysz gt 800 do begin & zm=zm/2 & xsz=xsz/2 & ysz=ysz/2 & end
  subscripts=strcompress(string("(",x1,":",x2,",",y1,":",y2,")"),/remove_all)
  szlab=string(f=fmt,"region",iwin,",  (",xsz ," x ", ysz,")")
  window,xs=xsz,ys=ysz,/free,title=szlab
  tvscl,rebin(im(x1:x2,y1:y2),xsz,ysz)

again:

  i = WMENU(['Options:', $
             'new region, kill old', $
             'new region, keep old', $
             'quit, keep all windows',$
             'quit, kill all windows'], TITLE=0, init=init)
  init=i
  case i of 

    1:begin
       print,"window" + string(f='(i3,":  ")',iwin),subscripts
       wdelete,!d.window
      end

    2:begin
       print,"window" + string(f='(i3,":  ")',iwin),subscripts
       loop=1
     end

    3:begin
       print,"window" + string(f='(i3,":  ")',iwin),subscripts
       loop=0
      end

    4:begin
       print,"window" + string(f='(i3,":  ")',iwin),subscripts
       loop=-1
      end

  endcase

endwhile
if loop eq -1 then while !d.window ge 32 do wdelete,!d.window
end








