function randata,nx,ny,s=s,locked=locked,iseed=iseed
;+
; routine:      randata
; 
; purpose:      generate a random field of data with given power spectrum
;               and array size
;
; useage:       randata,n,slope,nx=nx,ny=ny
;
; inputs:
;   nx          size of output grid in x direction
;
;   ny          size of output grid in y direction, must be less than n.
;
;               Since an FFT is used to create the random data,
;               RANDATA runs faster if max(NX,NY) is a power of 2
;
; Keyword input:
;   
;   s           power law slope of power spectrum (default=4)
;   
;   locked      phases of fourier components locked to grid centers
;
; Keyword input/output
;
;   iseed       the seed used to randomize the phases
;
; EXAMPLE:      
;               n=64
;               xs=sqrt(findgen(n))                  
;               ys=sqrt(findgen(n))                  ; xss and yss are used
;               xss=xs # replicate(1,n_elements(ys)) ; to give the random
;               yss=replicate(1,n_elements(xs)) # ys ; data a nice shape
;
;               shade_surf,randata(n,n,s=4)*xss*yss,az=10,ax=40
;
;  author:  Paul Ricchiazzi                            27oct93
;           Institute for Computational Earth System Science
;           University of California, Santa Barbara
;-

p=ceil(alog(nx > ny)/alog(2.))
n=2^p

if keyword_set(s) eq 0 then s=4                  ; power law slope

power=1./(1.>(dist(n)^(s+1)))

if keyword_set(locked) then begin
  gg=randomu(iseed,n,n)
  gg=sqrt(power)*sin(2*!pi*gg)           ; random phase locked to grid
endif else begin
  gg=sqrt(power)
  gg=gg*exp(complex(0,2*!pi*randomu(iseed,n,n))) ; randomized phase
endelse
return,float((fft(gg,1))(0:nx-1,0:ny-1))         ; realization

end



