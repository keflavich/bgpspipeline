pro filter_convol,x,y,fwhm,xx,yy,type=type,isample=isample,osample=osample
;+
; ROUTINE:  filter_convol
;
; PURPOSE:  convolve a spectrum with a response function
;
; USEAGE:   filter_convol,x,y,fwhm,xx,yy,type=type,$
;                         isample=isample,osample=osample
;
; INPUT:    
;
;   x 
;     x value
;
;   y 
;     spectral values
;
;   fwhm   
;     filter width at half of maximum value in x units
;
; KEYWORD INPUT:
;   type  
;     filter type 
;     0 = square
;     1 = triangular
;     2 = gaussian
;
;   isample
;     sample interval of input spectrum (default = .1*fwhm)
;
;   osample
;     sample interval of filtered response (default = .5*fwhm)
;
; OUTPUT:
;
;   xx
;      x values at sample points
;
;   yy
;      response values
;
; DISCUSSION:
;
; EXAMPLE:  
;
; AUTHOR:   Paul Ricchiazzi                        20 Nov 96
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;           paul@icess.ucsb.edu
;
; REVISIONS:
;
;-
;
if not keyword_set(isample) then isample=.1*fwhm
if not keyword_set(osample) then osample=.5*fwhm

xmin=min(x,max=xmax)

nn=1+(xmax-xmin)/isample

xs=findrng(xmin,xmax,nn)
ys=interpol(y,x,xs)

nwhm=fwhm/isample

case type of
  0: filter=replicate(1,nwhm)
  1: filter=[1+findgen(nwhm/2),1+reverse(nwhm-nwhm/2)]
end

xx=xs
yy=convol(ys,filter,/edge_truncate)/total(filter)

ii=where(xx gt xmin+fwhm and xx lt xmax-fwhm)

xx=xx(ii)
yy=yy(ii)

nskip=osample/isample

if(nskip mod 1 eq 0.) then begin
  nx=n_elements(xx)
  ii=nskip*lindgen(nx/nskip) 
  if nx mod nskip ne 0 then ii=[ii,nx-1]
  xx=xx(ii)
  yy=yy(ii)
endif else begin
  xxx=findrng(xmin+fwhm,xmax-fwhm,1+(xmax-xmin-2*fwhm)/osample)
  yyy=interpol(yy,xx,xxx)
  xx=xxx
  yy=yyy
endelse
 
return
end

