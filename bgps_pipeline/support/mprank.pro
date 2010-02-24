 function mprank,image,perc,binsize,interp=interp
;+
; routine       mprank
;
; purpose       compute the nth percentile value in each of a number of a
;               image superpixel subregions
; input:
;
;   image       image array
;
;   perc        percentile threshold ( measured from the top, 
;               ie perc=7 => the pixel value which is at the 93% percentile))
;
;   binsize     size of subregions (assumed square)
;
; keyword input:
;
;   interp      if set use, interpolation is used to resize results up
;               to the input image size. A boxy result is ofter produced
;               when INTERP is not set.
; output:
;
;   result=     value of pixels which are at the PERC percentilie in the
;               subarea.  Values are CONGRIDed up to the size of image.
;
; procedure:    MPRANK looks at each subregion in the image and seperately
;               evaluates the value within that subregion which is in the
;               upper PERC percentile.  The result of the function are
;               these values CONGRIDed up to the size of the original image.
; 
;
; EXAMPLE:
;               n=256
;               xs=sqrt(findgen(n))                  
;               ys=sqrt(findgen(n))                  ; xss and yss are used
;               xss=xs # replicate(1,n_elements(ys)) ; to give the random
;               yss=replicate(1,n_elements(xs)) # ys ; data a nice shape
;               f=randata(n,n,s=4)
;               !p.multi=[0,2,2]
;               tvim,f,title='original data'
;               tvim,mprank(f,5,32),title='no interp'
;               tvim,mprank(f,5,32,/interp),title='with interp'
;
;  author:  Paul Ricchiazzi                            Nov93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-
sz=size(image)
nx=sz(1)
ny=sz(2)
mx=nx/binsize
my=ny/binsize

pval=fltarr(mx,my)

for j=0,my-1 do begin
  y0=j*binsize
  for i=0,mx-1 do begin
    x0=i*binsize
    array=image(x0:x0+binsize-1,y0:y0+binsize-1)
    pval(i,j)=prank(array,100-perc)
  endfor
endfor

fx=(mx-1)*findgen(nx)/(nx-binsize)
fy=(my-1)*findgen(ny)/(ny-binsize)
fx=fx-fx(binsize/2)
fy=fy-fy(binsize/2)

if keyword_set(interp) then begin
  return,interpolate(pval,fx,fy,/grid)
endif else begin
  return,congrid(pval,nx,ny,/minus_one)
endelse

end
